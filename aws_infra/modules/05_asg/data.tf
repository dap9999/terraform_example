# 1. 태그로 AMI 찾기
data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "ec2/terraform.tfstate" 
    region = var.region
  }
}

# 2. VPC 및 서브넷 정보
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "network/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "iam/terraform.tfstate"
    region = var.region
  }
}
data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "alb/terraform.tfstate"
    region = var.region
  }
}