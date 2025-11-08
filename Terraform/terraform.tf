terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
  }
  backend "s3" {         #remote backend
    bucket = "tera-code-bucket"
    key = "terraform.tfstate"
    region = var.aws_region
    dynamodb_table = "tera-code-bucket-table"
  }
}

provider "aws" {
  region = var.aws_region #variable used
}