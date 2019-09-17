variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
    type        = string
    default     = "us-east-2"
    description = "AWS region in which to provision the AWS resources"
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
    default     = "standard"  
}