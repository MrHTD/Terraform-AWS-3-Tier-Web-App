# -------------------
# Frontend Tier (EC2)
# -------------------
resource "aws_launch_template" "frontend_lt" {
  image_id      = var.ami_id
  name_prefix   = "${var.project_name}-frontend_lt"
  instance_type = var.frontend_instance_type
  user_data     = filebase64("modules/frontend_asg/config.sh")

  vpc_security_group_ids = var.aws_security_group
  # Ensure the frontend instance can communicate with the backend
  # and the backend can communicate with the database
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-FrontendInstance"
      Environment = "Production"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = "${var.project_name}-frontend_asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = var.public_subnet_ids
  health_check_type   = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.alb_target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-Frontend_ASG"
    propagate_at_launch = true
  }
}
