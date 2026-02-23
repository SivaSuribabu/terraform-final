variable "application_name" {}
variable "environment_name" {}
variable "version_label" {}

variable "instance_type" {}
# variable "custom_ami_id" {}
variable "ec2_key_name" {}

variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "security_groups" { type = list(string) }

variable "certificate_arn" {}
variable "domain_name" {}
variable "hosted_zone_id" {}