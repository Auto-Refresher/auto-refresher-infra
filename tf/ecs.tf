resource "aws_ecs_cluster" "refref_cluster" {
    name = "refref-cluster"
}

resource "aws_ecs_task_definition" "refresher_controller" {
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 512
    memory                   = 1024
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    container_definitions = jsonencode([{
        name        = "refresher-controller-container"
        image       = "${var.refresher_container_image}:latest"
        essential   = true
        environment = []
    }]
}