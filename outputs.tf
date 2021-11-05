output "alb_browser_dns_name" {
  value = aws_alb.main.dns_name
}

output "alb_browser_arn" {
    value = aws_alb.main.arn
}