resource "aws_security_group" "elb_sg" {

  name = "elb-${var.name}-${var.environment}-sg"
  description = "Nginx port"

  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = "${var.elb_port}"
    to_port   = "${var.elb_port}"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    self = true
  }



  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags {
    Name = "elb-${var.name}-${var.environment}-sg"
    Application = "${var.container_name}"
    Environment = "${var.environment}"
  }


}

resource "aws_security_group" "ecs_sg" {
  name = "ecs-${var.name}-${var.environment}-sg"

  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    self = true
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [
      "${aws_security_group.elb_sg.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "ecs-${var.name}-${var.environment}-sg"
    Application = "${aws_ecs_cluster.exness_cluster.name}-cluster"
    Environment = "${var.environment}"

  }
}
