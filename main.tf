provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
}

variable "instance_ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The key pair name for SSH access"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
}

resource "aws_security_group" "default" {
  name        = var.security_group_name
  description = "Default security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami               = var.instance_ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  vpc_security_group_ids = [aws_security_group.default.id]

  tags = {
    Name = "terraform-ec2"
  }
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}
