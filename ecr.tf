#
# ECR
#
resource "aws_ecr_repository" "ems-frontend" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "ems-frontend"
}

resource "aws_ecr_lifecycle_policy" "ems-frontend" {
  repository = aws_ecr_repository.ems-frontend.name
  policy     = jsonencode(local.ecr-lifecycle-policy)
}

resource "aws_ecr_repository" "ems-backend" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "ems-backend"
}

resource "aws_ecr_lifecycle_policy" "ems-backend" {
  repository = aws_ecr_repository.ems-backend.name
  policy     = jsonencode(local.ecr-lifecycle-policy)
}

locals {
  ecr-lifecycle-policy = {
    rules = [
      {
        action = {
          type = "expire"
        }
        description  = "最新のイメージを5つだけ残す"
        rulePriority = 1
        selection = {
          countNumber = 5
          countType   = "imageCountMoreThan"
          tagStatus   = "any"
        }
      },
    ]
  }
}