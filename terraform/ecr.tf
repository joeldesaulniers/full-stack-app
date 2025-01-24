# ECR Repository for web application
resource "aws_ecr_repository" "ecr" {
  name                 = "sandbox-namespace/web"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "sandbox-namespace/web"
    Environment = "sandbox"
  }
}
