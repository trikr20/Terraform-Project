terraform {
  required_version = ">=1.5.6"
}
provider "aws" {
  region = "us-east-1"

}
resource "aws_s3_bucket" "example" {
  bucket = "poc-121-141"
  force_destroy = true
#   logging {
#     target_bucket = "ghh"
#     target_prefix=""

#   }
  versioning {
    enabled = true
  }
  tags = {
    "owner" : "Tribhuwan"
  }

}