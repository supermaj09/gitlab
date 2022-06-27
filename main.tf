terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "Public1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Public-Subnet 1"
  }
}
resource "aws_subnet" "Public2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Public-Subnet 2"
  }
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix = "demo"
  image_id = var.ami
  instance_type = var.instance_type
}
resource "aws_autoscaling_group" "aws_asg_config" {
  name = "demo_autoscaling_group"
  min_size = 2
  max_size = 3
  health_check_type = "EC2"
  launch_configuration = aws_launch_configuration.launch_configuration.name
  availability_zones = [ "us-east-1a", "us-east-1b" ]
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = "gitawsdemobucket"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "app-state"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
© 2022 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
