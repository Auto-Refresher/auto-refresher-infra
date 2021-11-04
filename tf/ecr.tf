resource "aws_ecr_repository" "browser" {
    name = "refref-browser-repository"
    image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "controller" {
    name = "refref-controller-repository"
    image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = "aws_ecr_repository.browser.name"
 
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

resource "aws_ecr_lifecycle_policy" "main" {
  repository = "aws_ecr_repository.controller.name"
 
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