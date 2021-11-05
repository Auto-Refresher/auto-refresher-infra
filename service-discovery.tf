resource "aws_service_discovery_private_dns_namespace" "refresher-stack" {
  name        = "local"
  description = "refresher"
  vpc         = aws_vpc.main.id
}

resource "aws_service_discovery_service" "refresher-stack-controller" {
  name = "controller"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.refresher-stack.id

    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "refresher-stack-browser" {
  name = "browser"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.refresher-stack.id

    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}