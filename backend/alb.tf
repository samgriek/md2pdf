resource "aws_lb" "alb" {
  name               = "api-md2pdf-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }
}

resource "aws_lb_target_group" "group" {
  name     = "api-md2pdf-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.http.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}
