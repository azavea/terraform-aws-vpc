# terraform-aws-vpc

A Terraform module to create an Amazon Web Services (AWS) Virtual Private Cloud (VPC).

## Usage

```javascript
module "vpc" {
  source = "github.com/azavea/terraform-aws-vpc"

  name = "Default"
  region = "us-east-1"
  key_name = "hector"
  cidr_block = "10.0.0.0/16"
  external_access_cidr_block = "0.0.0.0/0"
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  bastion_ami = "ami-ff02509a"
  bastion_instance_type = "t2.micro"

  project = "Something"
  environment = "Staging"
}
```

## Variables

- `name` - Name of the VPC (default: `Default`)
- `project` - Name of project this VPC is meant to house (default: `Unknown`)
- `environment` - Name of environment this VPC is targeting (default: `Unknown`)
- `region` - Region of the VPC (default: `us-east-1`)
- `key_name` - EC2 Key pair name
- `cidr_block` - CIDR block to allocate for the VPC (default: `10.0.0.0/16`)
- `external_access_cidr_block` - CIDR block for inbound clients to VPC bastion
  (default: `0.0.0.0/0`)
- `public_subnet_cidr_blocks` - List of public subnet CIDR blocks (default: `["10.0.0.0/24","10.0.2.0/24"]`)
- `private_subnet_cidr_blocks` - List of private subnet CIDR blocks (default: `["10.0.1.0/24", "10.0.3.0/24"]`)
- `availability_zones` - List of availability zones (default: `["us-east-1a", "us-east-1b"]`)
- `bastion_ami` - Bastion Amazon Machine Image (AMI) ID
- `bastion_instance_type` - Instance type for bastion instance (default: `t2.micro`))

## Outputs

- `id` - VPC ID
- `public_subnet_ids` - List of public subnet IDs
- `private_subnets_ids` - List of private subnet IDs
- `bastion_hostname` - Public DNS name for bastion instance
- `bastion_security_group_id` - Security group ID tied to bastion instance
- `cidr_block` - The CIDR block associated with the VPC
