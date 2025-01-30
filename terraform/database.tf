# Amazon Machine Image for Database
variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = "ami-0c614dee691cbbf37"
}


# Security Group for Database
resource "aws_security_group" "database-sg" {
  name        = "Database Security Group"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = aws_vpc.main.*.cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                    = var.ami
  subnet_id              = aws_subnet.public_subnet1.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.profile.name
# Ensure this key pair name exists in the account
  key_name               = "[key-name]"

  tags = {
    Name = "Database"
  }
}

# Elastic IP
resource "aws_eip" "ec2_eip" {
  domain = "vpc"
  instance = aws_instance.ec2_instance.id
}

# IAM Role
resource "aws_iam_role" "role" {
  name = "role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

# EC2 IAM Policy
resource "aws_iam_role_policy" "policy-ec2" {
  name = "policy-ec2"
  role = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# S3 IAM Policy
resource "aws_iam_role_policy" "policy-s3" {
  name = "policy-s3"
  role = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.my_s3_bucket.bucket}/DB-backups/*"
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "profile" {
  name = "profile"
  role = aws_iam_role.role.name
}
