# aws_infra/asg/main.tf
# 시작 템플릿
resource "aws_launch_template" "aws07_was_lt" {
  name_prefix   = "${var.prefix}-was-lt-"

  # data에서 찾은 최신 AMI ID 사용
  image_id      = data.aws_ami.was_ami.id
  instance_type = var.instance_type
  key_name     = var.key_name

  network_interfaces {
      associate_public_ip_address = "false"
      security_groups = [data.aws_security_group.aws07_was_sg.id]
  }
  
  iam_instance_profile {
    name = data.aws_iam_instance_profile.aws07_ec2_profile.name
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.prefix}-was-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 오토 스케일링 그룹
resource "aws_autoscaling_group" "aws07_was_asg" {
  name                = "${var.prefix}-was-asg"
  vpc_zone_identifier = data.aws_subnets.aws07_private_subnets.ids
  
  launch_template {
    id      = aws_launch_template.aws07_was_lt.id
    version = "$Latest"
  }

  target_group_arns = [data.aws_lb_target_group.aws07_was_tg.arn]

  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  health_check_type         = "EC2"
  health_check_grace_period = 300 

  tag {
    key                 = "Name"
    value               = "${var.prefix}-was-asg-instance"
    propagate_at_launch = true
  }
}

# 대상 그룹 연결