resource "aws_cloudwatch_event_rule" "scheduled_task" {
    name = "browser-scheduler"
    schedule_expression = "rate(2 hours)"
}