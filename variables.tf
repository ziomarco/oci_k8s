variable "private_key_path" {
  default = "~/.oci/ziomarco.pem"
}

variable "instance_shape" {
  default = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" { default = 1 }

variable "instance_shape_config_memory_in_gbs" { default = 6 }

variable "node_ami_ocid" {}

variable "compartment_ocid" {}

variable "region" {}

variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "ssh_public_key" {}

variable "project_name" {}

variable "lb_domain_hostname" {}

variable "key_fingerprint" {}

variable "route53_zone_name" {}

variable "aws_profile" {}