#
# VPC resources
#

resource "aws_vpc" "default" {
  cidr_block = "${var.cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "private" {
  count = "${length(split(",", var.private_subnet_cidr_blocks))}"

  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${element(aws_instance.nat.*.id, count.index)}"
  }

  tags {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "PublicRouteTable"
  }
}

resource "aws_subnet" "private" {
  count = "${length(split(",", var.private_subnet_cidr_blocks))}"

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${element(split(",", var.private_subnet_cidr_blocks), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"

  tags {
    Name = "PrivateSubnet"
  }
}

resource "aws_subnet" "public" {
  count = "${length(split(",", var.public_subnet_cidr_blocks))}"

  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${element(split(",", var.public_subnet_cidr_blocks), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "PublicSubnet"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(split(",", var.private_subnet_cidr_blocks))}"

  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count = "${length(split(",", var.public_subnet_cidr_blocks))}"

  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_vpc_endpoint" "s3" {
	vpc_id = "${aws_vpc.default.id}"
	service_name = "com.amazonaws.${var.region}.s3"
	route_table_ids = ["${aws_route_table.public.id}"]
}

#
# NAT resources
#

resource "aws_security_group" "nat" {
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sgNAT"
  }
}

resource "aws_instance" "nat" {
  count = "${length(split(",", var.public_subnet_cidr_blocks))}"

  ami = "${var.nat_ami}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  instance_type = "${var.nat_instance_type}"
  key_name = "${var.key_name}"
  monitoring = true
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "NATDevice"
  }
}

#
# Bastion resources
#

resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.external_access_cidr_block}"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_vpc.default.cidr_block}"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sgBastion"
  }
}

resource "aws_instance" "bastion" {
  ami = "${var.bastion_ami}"
  availability_zone = "${element(split(",", var.availability_zones), 0)}"
  instance_type = "${var.bastion_instance_type}"
  key_name = "${var.key_name}"
  monitoring = true
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  subnet_id = "${element(aws_subnet.public.*.id, 0)}"
  associate_public_ip_address = true

  tags {
    Name = "Bastion"
  }
}
