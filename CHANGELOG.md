## 6.0.1

- Fix deprecated use of quoted resource in `depends_on`.

## 6.0.0

- Add support for Terraform 0.12.
- Update the default for `bastion_instance_type` to `t3.nano`.
- Add a `tags` variable.
- Add continuous integration support via CircleCI.

## 5.0.1

- `element()` -> `listvar[idx]`

## 5.0.0

- Remove `external_access_cidr_block` variable. See the README for a guide on
  how to configure security groups for the bastion.
- Add `bastion_ebs_optimized` variable.

## 4.0.0

- Make use of standalone `aws_network_interface_sg_attachment` vs. the
  `vpc_security_group_ids` attribute of the `aws_instance` resource.
- Add output for `bastion_network_interface_id`, which is the ID of the primary
  network interface for the bastion instance.

## 3.1.1

- Make use of standalone `aws_route` vs. the `route` attributes of the
  `aws_route_table` resource.

## 3.1.0

- Add output for `nat_gateway_ips`, which are the Elastic IPs bound to NAT
  Gateways.

## 3.0.0

- Add support for Terraform 0.7.
- Convert comma-delimited variables with lists types.

## 2.0.1

- 2.0.0 release was botched; includes contents of that release.

## 2.0.0

- Remove security group rules from bastion security group.
- Add module attributes for `project` and `environment`.
- Remove `create_before_destroy` lifecycle resources from subnets.

## 1.1.0

- Associate route tables for private subnets to S3 VPC endpoint.

## 1.0.0

- Use the `aws_security_group_rule` resource to define security group rules
  internally.
- Output the `bastion_security_group_id`.

## 0.4.0

- Replace manual NAT setup for VPC with AWS managed NAT Gateways.

## 0.3.0

- Output `nat_security_group_id` so additional rules can be created
- Add `nat_egress_ports` parameter to set up NAT instance egress ports

## 0.2.0

- Add `create_before_destroy` behavior to VPC subnets.

## 0.1.1

- Remove hardcoded security group identifiers and let Terraform assign unique
  names.

## 0.1.0

- Initial release.
