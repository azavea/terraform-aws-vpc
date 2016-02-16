output "id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_subnet_ids" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "bastion_hostname" {
  value = "${aws_instance.bastion.public_dns}"
}

output "cidr_block" {
  value = "${var.cidr_block}"
}
