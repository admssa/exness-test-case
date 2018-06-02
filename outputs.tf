output "aws_elb" {
  value = "${aws_elb.nginx_elb.dns_name}"
}