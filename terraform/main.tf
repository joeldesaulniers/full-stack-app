# Terraform Configuration Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4.2"
}

# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "sandbox"
      Terraform   = "true"
      Project     = "infrastructure"
    }
  }
}
