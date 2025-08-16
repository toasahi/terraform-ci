# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = "development"
      Project     = "terraform-iam-example"
      ManagedBy   = "terraform"
    }
  }
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "ec2-instance-role"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "ec2-instance-role"
    Description = "IAM role for EC2 instances"
  }
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "ec2-instance-profile"
    Description = "Instance profile for EC2 instances"
  }
}

# Example IAM policy for the role (optional)
resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2-basic-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

