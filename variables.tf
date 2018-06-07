variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "eu-west-1"
}

variable "environment" {}

variable "instance_size" {}
variable "name" {}
variable "container_name" {}
variable "vpc_cidr" {}
variable "cluster_name" {}
variable "az_count" {}
variable "elb_port" {}
variable "instance_port" {}
variable "ssh_key" {}