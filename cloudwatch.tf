resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = "browser-scheduler"
  schedule_expression = "rate(2 hours)"
}

resource "aws_iam_role" "ecs_events" {
  name = "ecs_events"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = aws_iam_role.ecs_events.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ecs:RunTask",
        "Resource" : "${replace(aws_ecs_task_definition.refresher_controller.arn, "/:\\d+$/", ":*")}"
      }
    ]
  })
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "run_refresh"
  arn       = aws_ecs_cluster.refref_cluster.arn
  rule      = aws_cloudwatch_event_rule.scheduled_task.name
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.refresher_controller.arn
  }
}
