
output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "aws_elb" {
  value = "${aws_elb.nginx_elb.dns_name}"
}
