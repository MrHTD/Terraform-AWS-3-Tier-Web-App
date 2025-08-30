# -------------------
# Frontend Tier (EC2)
# -------------------
resource "aws_launch_template" "frontend" {
  image_id      = var.ubuntu_24_04_ami
  name_prefix   = "frontend-"
  instance_type = var.frontend_instance_type
  user_data = filebase64("modules/frontend_asg/config.sh")

  vpc_security_group_ids = var.aws_security_group
  # Ensure the frontend instance can communicate with the backend
  # and the backend can communicate with the database
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "FrontendInstance"
      Environment = "Production"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name     = var.asg_name
  desired_capacity = 2
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  health_check_type = "EC2"
  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id = aws_launch_template.frontend.id
    version = aws_launch_template.frontend.latest_version
  }

  tag {
    key = "Name"
    value = "FrontendASG"
    propagate_at_launch = true
  }
}