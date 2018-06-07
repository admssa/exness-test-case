resource "aws_elb" "nginx_elb" {
  name = "${var.environment}-${var.name}-${var.container_name}"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.elb_sg.id}"]

  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "http"
    lb_port           = "${var.elb_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.instance_port}/"
    interval            = 30
  }


  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Environment = "${var.environment}"
    role = "${var.container_name}"
    Environment = "${var.environment}"
  }

}




