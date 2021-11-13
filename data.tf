data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ecr_repository" "controller_repo" {
    name = "refresher-controller"
}

data "aws_alb_target_group" "browser_tg" {
    name = "refresher-browser-target-group"
    arn = var.browser_tg_arn
}