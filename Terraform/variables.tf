variable "aws_region" {
    description = "This is the region specified for AWS resources"
    default = "eu-west-1"
  
}

variable "_ec2_instance_type" {
    description = "this is the instance type for ec2"
    default = "t2.micro"
  
}

variable "aws_s3_bucket_name" {
    description = "This is the AWS S3 Bucket Name"
    default = "tera-biriyani-bucket"

}


variable "aws_ec2_instance_name" {
    description = "this is the instance name given to ec2 instance"
    default = "terraform server"
  
}

variable "aws_root_volume_size" {
    description = "this is the volume size for ec2"
    default = 10
  
}

variable "aws_instance_count" {
    description = "the count of ec2 instance"
    default = 2
  
}

locals {
  instances = {
  "key" : "my_instance_1",
  "key_1" : "my_instance_2"
}
  #OR WE CAN WRITE IN THIS WAY
#instances = ["instance_1","instance_2"]

}
