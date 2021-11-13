data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ecr_repository" "controller_repo" {
    name = "refresher-controller"
    repository_url = "818224701131.dkr.ecr.eu-west-2.amazonaws.com/refresher-controller"
}

data "aws_alb_target_group" "browser_tg" {
    name = "refresher-browser-target-group"
    arn = var.browser_tg_arn
}