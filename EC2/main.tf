terraform {
  required_version = ">=1.5.6"
}
provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  type    = string
  default = "ami-0277155c3f0ab2930"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"

}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld"
  }
}

output "instance_id" {
  value = aws_instance.web.arn
}
output "status" {
  value = aws_instance.web.instance_state
}