terraform {
  required_version = ">= 0.12"
}

provider "aws" {
    region = var.aws_region
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
}

data "template_file" "user_data" {
    template = "/scripts/user_data.ps1"
}

resource "aws_iam_instance_profile" "parsec_profile" {
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "assume_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# -- Cloud Posse SSH keypair Module -- #
module "ssh_key_pair" {
    source = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
    namespace = "example"
    stage = "dev"
    name = "${var.key_name}"
    ssh_public_key_path = "${path.module}/secret"
    generate_ssh_key = "true"
    private_key_extension = ".pem"
    public_key_extension = ".pub"
}

# -- VPC -- #
module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "eg"
  stage      = "dev"
  name       = "parsec"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  namespace           = "eg"
  stage               = "prod"
  name                = "app"
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  cidr_block          = "10.0.0.0/16"
  nat_gateway_enabled = false
  availability_zones  = [var.aws_az]
}

# --Security Groups -- #
module "rdp_security_group" {
    source  = "terraform-aws-modules/security-group/aws//modules/rdp"
    version = "~> 3.0"
    description = "Allow RDP access to EC2 instance"
    vpc_id  = module.vpc.vpc_id
    name    = "parsec-sg"
    ingress_cidr_blocks = ["10.0.0.0/16"]
}

module "ssh_security_group" {
    source  = "terraform-aws-modules/security-group/aws//modules/ssh"
    version = "~> 3.0" 
    description = "Allow SSH access to EC2 instance"
    vpc_id  = "${module.vpc.vpc_id}"
    name    = "parsec-sg"
}

module "http_80_security_group" {
    source  = "terraform-aws-modules/security-group/aws//modules/http-80"
    version = "~> 3.0"
    description = "Allow HTTP access to EC2 instance"
    vpc_id  = "${module.vpc.vpc_id}"
    name    = "parsec-sg"
    ingress_cidr_blocks = ["10.0.0.0/16"]
}

# -- AMI -- #
resource "aws_instance" "this" {
    ami                  = "({var.ami, var.AWS_REGION)}"
    instance_type        = "G3.4xLarge"
    key_name             = "${module.ssh_key_pair.key_name}"
    subnet_id            = ["${module.subnets.private_subnet_ids}", "${module.subnets.public_subnet_ids}"]
    security_groups      = ["${module.rdp_security_group}", "${module.ssh_security_group}", "${module.http_80_security_group}"] 
    user_data            = "${data.template_file.user_data.rendered}"
    iam_instance_profile = "${data.template_file.iam-profile}"
    get_password_data    = "true"

    root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "true"
  }
    tags = {
    "Name"    = "parsec"
    "Role"    = "Dev"
  }

  #--- Copy ssh keys to S3 Bucket
  provisioner "local-exec" {
    command = "aws s3 cp ${path.module}/secret s3://PATHTOKEYPAIR/ --recursive"
  }

  #--- Deletes keys on destroy
  provisioner "local-exec" {
    when    = "destroy"
    command = "aws s3 rm 3://PATHTOKEYPAIR/${module.ssh_key_pair.key_name}.pem"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "aws s3 rm s3://PATHTOKEYPAIR/${module.ssh_key_pair.key_name}.pub"
  }
}