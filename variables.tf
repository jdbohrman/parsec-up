variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "aws_region" {
    type        = "string"
    default     = "us-east-2"
    description = "AWS region in which to provision the AWS resources"
}
variable "WIN_AMIS"{
    type = "map" default = {
        us-east-1 = "ami-034e1d78dd9d4a332"
        us-east-2 = "ami-0a6b96ce710e139e3"
        us-west-1 = "ami-0feab9ccd45037ddb"
        us-west-2 = " ami-06a0d33fc8d328de0"
        ca-central-1 = "ami-02d56b7af03bd2475"
        eu-west-1 = "ami-06074ca6cd286bf04"
        eu-west-2 = "ami-04d448003f4112a08"
    }
}

variable "PATH_TO_PRIVATE_KEY" {
    default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
    default = "mykey.pub"
}

variable "INSTANCE_USERNAME" {
    default = "admin"
}

variable "INSTANCE_PASSWORD" {}