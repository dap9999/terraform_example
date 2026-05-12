data "aws_vpc" "aws07_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}

data "aws_subnets" "aws07_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.aws07_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-private-*"]
  }
}

data "aws_security_group" "aws07_ssh_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-ssh-sg"]
  }
}

data "aws_security_group" "aws07_http_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-http-sg"]
  }
}

data "aws_iam_instance_profile" "aws07_ec2_profile" {
  name = "${var.prefix}-ec2-instance-profile"
}

data "aws_lb_target_group" "aws07_jenkins_tg" {
  name = "${var.prefix}-alb-jenkins-group"
}