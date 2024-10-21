terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "eu-north-1"
  shared_credentials_files = ["C:\\Users\\omara\\.aws\\credentials"]
  profile                  = "default"
}