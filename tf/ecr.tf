resource "aws_ecr_lifecycle_policy" "browser" {
  repository = "data.aws_ecr_repository.browser_repo.name"
 
  policy = jsonencode({
    rules = [{
        rulePriority = 1
        description  = "keep last 10 images"
        action       = {
            type = "expire"
        }
        selection     = {
            tagStatus   = "any"
            countType   = "imageCountMoreThan"
            countNumber = 10
        }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "controller" {
  repository = "data.aws_ecr_repository.controller_repo.name"
 
  policy = jsonencode({
    rules = [{
        rulePriority = 1
        description  = "keep last 10 images"
        action       = {
            type = "expire"
        }
        selection     = {
            tagStatus   = "any"
            countType   = "imageCountMoreThan"
            countNumber = 10
        }
    }]
  })
}