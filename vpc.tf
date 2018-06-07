resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${var.name}-${var.environment}-ecs"
  }
}

resource "aws_subnet" "public" {
  count             = "${var.az_count}"
  cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "public_route_table" {
  count            = "${var.az_count}"
  vpc_id           = "${aws_vpc.main.id}"
  depends_on       = ["aws_internet_gateway.igw"]
}

resource "aws_route" "public_route" {
  count                  = "${var.az_count}"
  route_table_id         = "${element(aws_route_table.public_route_table.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  depends_on             = ["aws_route_table.public_route_table"]
}

resource "aws_route_table_association" "public_route_association" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public_route_table.*.id, count.index)}"
  depends_on     = ["aws_route.public_route"]
}

