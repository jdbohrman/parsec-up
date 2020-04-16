variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "aws_region" {
    type        = string
    default     = "us-east-2"
    description = "AWS region in which to provision the AWS resources"
}

variable "aws_az" {
    type        = string
    default     = "us-east-2a"
    description = "AWS AZ in which to provision the AWS resources"
}

variable "aws_instance_type" {
    type        = string
    default     = "g4dn.xlarge"
    description = "Valid inputs: g2.2xlarge, g3.4xlarge, g4dn.xlarge"
}

variable "key_name" {
    type        = string
    default     = "parsec"
}

variable "associate_public_ip_address" {
    type        = bool
    description = "If true, the EC2 instance will have associated public IP address"
    default     = false
}

variable "ami" {
    type        = string
    description = "The AMI to use for the instance"
    default     = "ami-0013cc8e269db9d05"
}

variable "volume_size" {
    type        = string
    description = "Size of the EBS root volume"
    default     = "100"
}

variable "volume_type" {
    type        = string
    description = "type of EBS volume"
    default     = "gp2"
}
