resource "aws_lb" "application_load_balancer" {
  name               = "frontend-lb"
  load_balancer_type = "application"
  security_groups    = [var.aws_security_group_id]
  subnets            = var.public_subnets
  enable_deletion_protection = true

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name = "frontend-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    path = "/"
    interval = 300
    timeout = 60
    matcher = "200"
    healthy_threshold = 2
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
