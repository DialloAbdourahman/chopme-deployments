resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.mutability
  force_delete         = var.force_destroy

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "cleanup" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last builds to control storage costs"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.retention_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
