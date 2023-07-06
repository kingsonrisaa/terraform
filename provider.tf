#provider AWS
terraform {
  backend "s3" {
    bucket = "mytfstatetestbucket020202"
    dynamodb_table = "statelock-dynamodb"
    key = "global/state/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "${var.aws_region}"
}
