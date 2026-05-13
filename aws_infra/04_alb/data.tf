# aws_infra/alb/data.tf

# 대상 그룹
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "network/terraform.tfstate"
    region = var.region
  }
}