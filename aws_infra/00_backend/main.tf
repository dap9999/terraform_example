# Terraform state를 저장할 S3 버킷 생성
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.prefix}-terraform-state-bucket"
  # S3 버킷 삭제 허용
  lifecycle {
    prevent_destroy = false
  }
  force_destroy = true
  tags = {
    Name = "${var.prefix}-terraform-state-bucket"
  }
}
# 상태 파일의 전체 리비전 기록을 볼 수 있도록 버전 지정
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
# 서버측 암호화 활성화
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# S3 버킷에 대한 공용 액세스 차단
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# DynamoDB 테이블 생성
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.prefix}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "${var.prefix}-terraform-locks"
  }
}