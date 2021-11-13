resource "aws_ecs_cluster" "refref_cluster" {
    name = "refref-cluster"
}

resource "aws_ecs_task_definition" "refresher_controller" {
    family                   = "refresher-controller-task"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 512
    memory                   = 1024
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
    container_definitions = jsonencode([{
        name        = "refresher-controller-container"
        image       = "${var.refresher_controller_container_image}:latest"
        essential   = true
        environment = []
        logConfiguration = {
            logDriver = "awslogs"
            options = {
                awslogs-group = "/ecs/refresher-controller"
                awslogs-region = "eu-west-2"
                awslogs-stream-prefix = "ecs"
            }
        }
    }])
}

resource "aws_ecs_service" "controller_service" {
    name            = "refresher-controller-service"
    cluster         = aws_ecs_cluster.refref_cluster.id
    task_definition = aws_ecs_task_definition.refresher_controller.arn
    desired_count   = 0
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.controller_sg.id]
        subnets          = aws_subnet.private.*.id
        assign_public_ip = false
    }

    service_registries {
        registry_arn = aws_service_discovery_service.refresher-stack-controller.arn
        container_name = "refresher_controller"
    }

    depends_on = [ aws_ecs_cluster.refref_cluster, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_security_group.controller_sg ]
}

resource "aws_ecs_task_definition" "refresher_browser" {
    family                   = "refresher-browser-task"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = 1024
    memory                   = 2048
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
    container_definitions = jsonencode([{
        name        = "refresher-browser-container"
        image       = "${var.refresher_browser_container_image}:latest"
        essential   = true
        environment = []
        logConfiguration = {
            logDriver = "awslogs"
                options = {
                    awslogs-group = "/ecs/refresher-browser"
                    awslogs-region = "eu-west-2"
                    awslogs-stream-prefix = "ecs"
                }
        }
        portMappings = [{
            containerPort = var.browser_port
            hostPort = var.browser_port
        }]
    }])
}

resource "aws_ecs_service" "browser_service" {
    name            = "refresher-browser-service"
    cluster         = aws_ecs_cluster.refref_cluster.id
    task_definition = aws_ecs_task_definition.refresher_browser.arn
    desired_count   = 0
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.browser_sg.id]
        subnets          = aws_subnet.private.*.id
        assign_public_ip = true
    }

    service_registries {
        registry_arn = aws_service_discovery_service.refresher-stack-browser.arn
        container_name = "refresher_browser"
    }

    load_balancer {
        target_group_arn = aws_alb_target_group.browser_tg.id
        container_name   = "refresher_browser"
        container_port   = var.browser_port
    }

    depends_on = [ aws_ecs_cluster.refref_cluster, aws_alb_listener.browser, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_security_group.browser_sg ]
}