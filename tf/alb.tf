resource "aws_alb" "main" {
  name            = "refresher-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb_sg.id]
}

resource "aws_alb_target_group" "browser_tg" {
  name        = "refresher-browser-target-group"
  port        = var.browser_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "browser" {
  load_balancer_arn = aws_alb.main.id
  port              = var.browser_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.browser_tg.id
    type             = "forward"
  }
}