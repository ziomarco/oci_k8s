terraform {
  cloud {
    organization = "palmitop"

    workspaces {
      name = "oci-k8s"
    }
  }
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.115.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }
  }
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.key_fingerprint
}

provider "aws" {
  profile = var.aws_profile
}