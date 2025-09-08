terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 6.9.0, < 7.0.0"

    }
  }

  required_version = ">= 1.6.0"

  # use remote state file
  backend "s3" {
    bucket = "terraform-state-ridwan"
    key = "terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = var.vpc_region
  profile = "default"
}