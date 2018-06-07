resource "aws_ecs_cluster" "exness_cluster" {
  name = "${var.environment}-${var.name}-cluster"
}

resource "aws_ecs_task_definition" "nginx_task" {
family = "${var.name}-${var.environment}-${var.container_name}-latest-${random_id.random.hex}"
  container_definitions = <<EOD
[
  {
    "name": "${var.container_name}",
    "image": "${aws_ecr_repository.nginx_repo.repository_url}:latest-${random_id.random.hex}",
    "cpu": 10,
    "memory": 512,
    "essential": true,
    "portMappings": [
    {
      "containerPort": 80,
      "hostPort": 80
    }
    ]
  }
]
EOD


   volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }
  depends_on = ["aws_ecs_cluster.exness_cluster","aws_autoscaling_group.ecs_cluster","aws_launch_configuration.ecs_lc"]
}

resource "aws_ecs_service" "nginx_service" {
  name = "nginx"
  desired_count   = 2
  cluster = "${aws_ecs_cluster.exness_cluster.arn}"
  task_definition = "${aws_ecs_task_definition.nginx_task.arn}"
  iam_role = "${aws_iam_role.assume_service_role.arn}"


  load_balancer {
    container_name = "${var.container_name}"
    container_port = 80
    elb_name = "${aws_elb.nginx_elb.name}"

  }

  depends_on = ["aws_ecs_task_definition.nginx_task"]

}

resource "aws_autoscaling_group" "ecs_cluster" {
  name = "ecs-${var.name}-${var.environment}-ag"
  min_size = 2
  max_size = 2
  health_check_type = "EC2"
  health_check_grace_period = 300
  launch_configuration = "${aws_launch_configuration.ecs_lc.name}"
  vpc_zone_identifier = ["${aws_subnet.public.*.id}"]
  tag {
    key = "Name"
    propagate_at_launch = false
    value = "ECS-${var.name}-${var.environment}"
  }

}



resource "aws_launch_configuration" "ecs_lc" {
  name = "ecs-${var.name}-${var.environment}-lc"
  image_id = "${data.aws_ami.latest_aws_ecs.id}"
  instance_type = "${var.instance_size}"
  security_groups = [ "${aws_security_group.ecs_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_profile.name}"
  key_name = "${var.ssh_key}"
  associate_public_ip_address = true
  user_data =  <<EOD
#!/bin/bash

echo ECS_CLUSTER="${aws_ecs_cluster.exness_cluster.name}" > /etc/ecs/ecs.config

EOD
}

resource "aws_iam_role" "assume_instances_role" {
  name = "ecs-instances-${var.name}-${var.environment}-role"
  assume_role_policy = "${file("policies/assume-policy.json")}"
}

resource "aws_iam_role_policy" "ecs_instance_role" {
  name = "${var.name}-${var.environment}-ecs-instance-role-policy"
  policy = "${file("policies/ecs_instances.json")}"
  role = "${aws_iam_role.assume_instances_role.id}"
}

resource "aws_iam_instance_profile" "ecs_profile" {
  name = "${var.name}-${var.environment}-ecs-profile"
  path = "/"
  role = "${aws_iam_role.assume_instances_role.name}"
}

resource "aws_iam_role" "assume_service_role" {
  name = "${var.name}-${var.environment}-ecs-service-role"
  assume_role_policy = "${file("policies/assume-policy.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role" {
  name = "${var.name}-${var.environment}-ecs-service-role-policy"
  policy = "${file("policies/ecs_services.json")}"
  role = "${aws_iam_role.assume_service_role.id}"
}





