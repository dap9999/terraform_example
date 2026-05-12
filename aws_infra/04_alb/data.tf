# aws_infra/alb/data.tf

# 대상 그룹
data "aws_vpc" "aws07_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}
data "aws_subnets" "aws07_public_subnets" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-public-subnet-*"]
  }
}
data "aws_security_group" "aws07_http_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-http-sg"]
  }
}
# 로드밸런스