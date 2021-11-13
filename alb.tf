resource "aws_alb" "main" {
  name            = "refresher-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb_sg.id]
}

resource "aws_alb_listener" "browser" {
  load_balancer_arn = aws_alb.main.id
  port              = var.browser_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = var.browser_tg_arn
    type             = "forward"
  }
}