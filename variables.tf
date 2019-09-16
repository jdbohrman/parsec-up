variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "aws_region" {
    type        = string
    default     = "us-east-2"
    description = "AWS region in which to provision the AWS resources"
}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  type        = bool
  default     = false
}


variable "region" {
    description = "Region for resources"
    type        = string
    default     = "us-east-1"
}




variable "ami" {
  type        = string
  description = "The AMI to use for the instance"
  default     = "ami-0013cc8e269db9d05"
}

variable "ami_owner" {
  type        = string
  description = "Owner of the given AMI"
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