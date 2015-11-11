variable "name" {
	default = "Default"
}
variable "region" {
	default = "us-east-1"
}
variable "key_name" { }
variable "cidr_block" {
	default = "10.0.0.0/16"
}
variable "external_access_cidr_block" {
  default = "0.0.0.0/0"
}
variable "public_subnet_cidr_blocks" {
	default = "10.0.0.0/24,10.0.2.0/24"
}
variable "private_subnet_cidr_blocks" {
	default = "10.0.1.0/24,10.0.3.0/24"
}
variable "availability_zones" {
	default = "us-east-1a,us-east-1b"
}
variable "nat_ami" { }
variable "nat_instance_type" {
	default = "t2.micro"
}
variable "bastion_ami" { }
variable "bastion_instance_type" {
	default = "t2.micro"
}
