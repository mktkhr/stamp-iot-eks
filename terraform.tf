terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
  region = var.provider_region

  default_tags {
    tags = var.aws_tags
  }

  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}