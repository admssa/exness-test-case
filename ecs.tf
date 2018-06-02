//resource "aws_ecs_cluster" "exness_cluster" {
//  name = "${var.environment}-${var.name}-cluster"
//}

resource "aws_ecs_task_definition" "nginx_task" {

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
  family = "servie"

   volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

}

resource "aws_ecs_service" "nginx_service" {
  name = "nginx"
  desired_count   = 2
  cluster = "${data.aws_ecs_cluster.exness_cluster.arn}"
  task_definition = "${aws_ecs_task_definition.nginx_task.arn}"


  load_balancer {
    container_name = "${var.container_name}"
    container_port = 80
    elb_name = "${var.environment}-${var.name}-${var.container_name}"

  }

  depends_on = ["aws_ecs_task_definition.nginx_task"]

}


data "aws_ecs_cluster" "exness_cluster" {
  cluster_name = "${var.cluster_name}"
}
