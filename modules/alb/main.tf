// Create ALB
resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups = var.security_groups_id
  subnets         = var.subnet_ids

  tags = {
    Name = var.alb_name
  }
}

// HTTP listener: redirect everything to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

// HTTPS listener: terminates TLS and carries the routing rules
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Default route - no specific service configured"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  count = length(var.routes)
  listener_arn = aws_lb_listener.https.arn
  priority     = 100 + count.index

  action {
    type             = "forward"
    target_group_arn = var.routes[count.index].target_group_arn
  }

  condition {
    path_pattern {
      values = [var.routes[count.index].path]
    }
  }
}
