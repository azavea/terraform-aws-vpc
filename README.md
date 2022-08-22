# terraform-aws-vpc

**Warning**
Maintenance only. Not recommended to use for new projects (moving away from NAT Gateway's recommended).

A Terraform module to create an Amazon Web Services (AWS) Virtual Private Cloud (VPC).

Please run terraform fmt before trying to make a PR.

## Usage

This module creates a VPC alongside a variety of related resources, including:

- Public and private subnets
- Public and private route tables
- Elastic IPs
- Network Interfaces
- NAT Gateways
- An Internet Gateway
- A VPC Endpoint

Example usage:

```hcl
module "vpc" {
  source = "github.com/azavea/terraform-aws-vpc"

  name = "Default"
  region = "us-east-1"
  cidr_block = "10.0.0.0/16"
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  project = "Something"
  environment = "Staging"
}
```

## Variables

- `name` - Name of the VPC (default: `Default`)
- `project` - Name of project this VPC is meant to house (default: `Unknown`)
- `environment` - Name of environment this VPC is targeting (default: `Unknown`)
- `region` - Region of the VPC (default: `us-east-1`)
- `cidr_block` - CIDR block for the VPC (default: `10.0.0.0/16`)
- `public_subnet_cidr_blocks` - List of public subnet CIDR blocks (default: `["10.0.0.0/24","10.0.2.0/24"]`)
- `private_subnet_cidr_blocks` - List of private subnet CIDR blocks (default: `["10.0.1.0/24", "10.0.3.0/24"]`)
- `availability_zones` - List of availability zones (default: `["us-east-1a", "us-east-1b"]`)
- `tags` - Extra tags to attach to the VPC resources (default: `{}`)

## Outputs

- `id` - VPC ID
- `public_subnet_ids` - List of public subnet IDs
- `private_subnets_ids` - List of private subnet IDs
- `cidr_block` - The CIDR block associated with the VPC
- `nat_gateway_ips` - List of Elastic IPs associated with NAT gateways
