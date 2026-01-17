# create public facing load balancer

resource "aws_lb" "main" {
  name               = "alb-test-test-${var.env_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg
  region = var.vpc_region
  subnets = var.public_subnet_ids
  drop_invalid_header_fields = true
  idle_timeout = 300
}

# create target group for blue tg / green tg

resource "aws_lb_target_group" "blue" {
  name     = "blue-target-group-${var.env_name}"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/healthz"
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group" "green" {
  name     = "green-target-group-${var.env_name}"
  port     = var.test_traffic_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/healthz"
    matcher             = "200-399"
  }
}

# HTTPS listener forwards to blue target group

resource "aws_lb_listener" "l_443" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

# test traffic port listener forwards traffic to green tg

resource "aws_lb_listener" "l_test" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.test_traffic_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}

# HTTP listener redirects traffic to HTTPS

resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
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