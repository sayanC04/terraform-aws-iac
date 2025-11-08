variable "aws_region" {
    description = "This is the region specified for AWS resources"
    default = "eu-west-1"
  
}
variable "aws_s3_bucket" {
  
  description = "AWS Backend Bucket name"
  default = "tera-code-bucket"
}

variable "aws_dynamodb_table" {
  
  description = "AWS Backend Dynamo Table name"
  default = "tera-code-bucket-table"
}