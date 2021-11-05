data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ecr_repository" "controller_repo" {
    name = "refresher-controller"
}

data "aws_ecr_repository" "browser_repo" {
    name = "refresher-browser"
}