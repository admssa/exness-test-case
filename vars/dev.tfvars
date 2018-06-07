environment = "dev"
aws_region = "eu-west-1"

instance_size = "t2.micro"

name = "exness"
container_name = "nginx"

elb_port = "80"
instance_port = "80"
vpc_cidr = "10.200.0.0/16"
cluster_name = "exness-dev"
az_count = 3
ssh_key = "admssa"