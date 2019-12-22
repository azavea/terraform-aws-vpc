# terraform-aws-vpc

[![CircleCI](https://circleci.com/gh/azavea/terraform-aws-vpc.svg?style=svg)](https://circleci.com/gh/azavea/terraform-aws-vpc)

A Terraform module to create an Amazon Web Services (AWS) Virtual Private Cloud (VPC).

## Usage

This module creates a VPC alongside a variety of related resources, including:

- Public and private subnets
- Public and private route tables
- Elastic IPs
- Network Interfaces
- NAT Gateways
- An Internet Gateway
- A VPC Endpoint
- A bastion EC2 instance

Example usage:

```hcl
module "vpc" {
  source = "github.com/azavea/terraform-aws-vpc"

  name = "Default"
  region = "us-east-1"
  key_name = "hector"
  cidr_block = "10.0.0.0/16"
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  bastion_ami = "ami-6869aa05"
  bastion_ebs_optimized = true
  bastion_instance_type = "t3.micro"

  project = "Something"
  environment = "Staging"
}
```

### Configuring security rules

By default, this module adds no security rules to the bastion instance, meaning
that all traffic will be blocked.

In order to configure security rules for the bastion, use the
`bastion_security_group_id` output. For example:

```hcl
resource "aws_security_group_rule" "ssh_ingress" {
  security_group_id = module.vpc.bastion_security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.bastion_inbound_cidr_block]
}
```

There is a limit to the number of rules you can add to a security group. If you
have exceeded this limit, you can add additional security groups to the bastion
using the `bastion_network_interface_id` output and an
`aws_network_interface_sg_attachment` resource. For example:

```hcl
resource "aws_security_group" "ssh_ingress" {
  vpc_id = module.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_inbound_cidr_block]
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.ssh_ingress.id
  network_interface_id = module.vpc.bastion_network_interface_id
}
```

## Variables

- `name` - Name of the VPC (default: `Default`)
- `project` - Name of project this VPC is meant to house (default: `Unknown`)
- `environment` - Name of environment this VPC is targeting (default: `Unknown`)
- `region` - Region of the VPC (default: `us-east-1`)
- `key_name` - EC2 Key pair name for the bastion
- `cidr_block` - CIDR block for the VPC (default: `10.0.0.0/16`)
- `public_subnet_cidr_blocks` - List of public subnet CIDR blocks (default: `["10.0.0.0/24","10.0.2.0/24"]`)
- `private_subnet_cidr_blocks` - List of private subnet CIDR blocks (default: `["10.0.1.0/24", "10.0.3.0/24"]`)
- `availability_zones` - List of availability zones (default: `["us-east-1a", "us-east-1b"]`)
- `bastion_ami` - Bastion Amazon Machine Image (AMI) ID
- `bastion_ebs_optimized` - If true, the bastion instance will be EBS-optimized (default: `false`)
- `bastion_instance_type` - Instance type for bastion instance (default: `t3.nano`)
- `tags` - Extra tags to attach to the VPC resources (default: `{}`)

## Outputs

- `id` - VPC ID
- `public_subnet_ids` - List of public subnet IDs
- `private_subnets_ids` - List of private subnet IDs
- `bastion_hostname` - Public DNS name for bastion instance
- `bastion_security_group_id` - Security group ID tied to bastion instance
- `bastion_network_interface_id` - Elastic Network Interface (ENI) ID of the Bastion instance's primary network interface
- `cidr_block` - The CIDR block associated with the VPC
- `nat_gateway_ips` - List of Elastic IPs associated with NAT gateways
