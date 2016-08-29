output "id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "bastion_hostname" {
  value = "${aws_instance.bastion.public_dns}"
}

output "bastion_security_group_id" {
  value = "${aws_security_group.bastion.id}"
}

output "cidr_block" {
  value = "${var.cidr_block}"
}
