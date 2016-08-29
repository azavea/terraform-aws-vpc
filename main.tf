#
# VPC resources
#

resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.name}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "private" {
  count = "${length(var.private_subnet_cidr_blocks)}"

  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.default.*.id, count.index)}"
  }

  tags {
    Name        = "PrivateRouteTable"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name        = "PublicRouteTable"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count = "${length(var.private_subnet_cidr_blocks)}"

  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${element(var.private_subnet_cidr_blocks, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name        = "PrivateSubnet"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.public_subnet_cidr_blocks)}"

  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${element(var.public_subnet_cidr_blocks, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "PublicSubnet"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnet_cidr_blocks)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnet_cidr_blocks)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = "${aws_vpc.default.id}"
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = ["${aws_route_table.public.id}", "${aws_route_table.private.*.id}"]
}

#
# NAT resources
#

resource "aws_eip" "nat" {
  count = "${length(var.public_subnet_cidr_blocks)}"

  vpc = true
}

resource "aws_nat_gateway" "default" {
  count = "${length(var.public_subnet_cidr_blocks)}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  depends_on = ["aws_internet_gateway.default"]
}

#
# Bastion resources
#

resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name        = "sgBastion"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "${var.bastion_ami}"
  availability_zone           = "${element(var.availability_zones, 0)}"
  instance_type               = "${var.bastion_instance_type}"
  key_name                    = "${var.key_name}"
  monitoring                  = true
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
  subnet_id                   = "${element(aws_subnet.public.*.id, 0)}"
  associate_public_ip_address = true

  tags {
    Name        = "Bastion"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}
