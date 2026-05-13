data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "network/terraform.tfstate" 
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
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "iam/terraform.tfstate"
    region = var.region
  }
}