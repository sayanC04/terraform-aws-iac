resource "aws_s3_bucket" "hello_bucket" {
    bucket = var.aws_s3_bucket
    tags = {
      Name = var.aws_s3_bucket
    }
  
}

resource "aws_dynamodb_table" "dynamo_table" {
    name= var.aws_dynamodb_table
    billing_mode = "PAY_PER_REQUEST" #FOR MINIMUM BILLING ISSUE
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
     tags = {
        Name = var.aws_dynamodb_table
      }
}