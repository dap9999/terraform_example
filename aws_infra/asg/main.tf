# aws_infra/asg/main.tf
# 시작 템플릿
resource "aws_launch_template" "aws07_launch_template" {
  name_prefix   = "${var.prefix}-launch-template-"
  image_id      = data.aws.ami.aws07_instance_ami.id
  instance_type = var.instance_type
  key_name     = var.key_name

  iam_instance_profile {
    name = data.aws.iam_instance_profile.aws07_ec2_instance_profile.name
  }
  network_interfaces {
    associate_public_ip_address = "false"
    security_groups = [
      data.aws_security_group.aws07_ssh_sg.id,
      data.aws_security_group.aws07_http_sg.id,
    ]
    subnet_id = element(data.aws_subnets.aws07_private_subnets.ids, count.index)
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.prefix}-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 오토 스케일링 그룹

# 대상 그룹 연결