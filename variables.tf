variable "name" {
  default = "Default"
}

variable "project" {
  default = "Unknown"
}

variable "environment" {
  default = "Unknown"
}

variable "region" {
  default = "us-east-1"
}

variable "key_name" {}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "external_access_cidr_block" {
  default = "0.0.0.0/0"
}

variable "public_subnet_cidr_blocks" {
  type    = "list"
  default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type    = "list"
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b"]
}

variable "bastion_ami" {}

variable "bastion_instance_type" {
  default = "t2.micro"
}
