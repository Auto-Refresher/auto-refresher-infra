terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "refref-state-bucket"
    key = "state"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
}
