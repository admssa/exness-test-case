resource "aws_elb" "nginx_elb" {
  name = "${var.environment}-${var.name}-${var.container_name}"
  availability_zones = [ "${data.aws_availability_zones.available.names[0]}","${data.aws_availability_zones.available.names[1]}","${data.aws_availability_zones.available.names[2]}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }


  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Environment = "${var.environment}"
    role = "${var.container_name}"
  }

}



data "aws_subnet_ids" "public" {
  vpc_id = "${var.vpc_id}"
}

data "aws_availability_zones" "available" {

}