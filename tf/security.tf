resource "aws_security_group" "lb_sg" {
    name = "refresher-load-balancer-security-group"
    description = "access control for ALB"
    vpc_id = aws_vpc.main.id

    ingress {
        protocol = "tcp"
        from_port = 0
        to_port = var.browser_port
        cidr_block = ["0.0.0.0/0"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_block = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "controller_sg" {
    name        = "refresher-controller-security-group"
    description = "allow inbound access to the controller task from the ALB only"
    vpc_id      = aws_vpc.main.id

    ingress {
        protocol        = "tcp"
        from_port       = 0
        to_port         = 0
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1" 
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "browser_sg" {
  name        = "refresher-browser-task-security-group"
  description = "allow inbound access to the browser task from controller"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = var.browser_port
    cidr_blocks = [ aws_vpc.main.cidr_block ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
