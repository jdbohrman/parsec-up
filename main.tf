provider "aws" {
    region = "${var.aws_region}"
    profile = "${var.aws_profile}"
}

# — — Get VPC ID — — -
data "aws_vpc” “selected" {
    tags = {
        Name = "${var.name_tag}"
    }
}
# — Get Public Subnet List
data "aws_subnet_ids” “selected" {
        vpc_id = "${data.aws_vpc.selected.id}"
        tags  = {
    Tier = "public"
    }
}

data "aws_security_group" "selected" {
    tags = {
    Name = "${var.name_tag}*"
    }
}

data "template_file” “user_data" {
    template = "/scripts/user_data.ps1"
}

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

# — — Copy ssh keys to S3 Bucket
provisioner "local-exec" {
    command = "aws s3 cp ${path.module}/secret s3://PATHTOKEYPAIR/ — recursive"
}
# — — Deletes keys on destroy
provisioner "local-exec" {
    when = "destroy"
    command = "aws s3 rm 3://PATHTOKEYPAIR/${module.ssh_key_pair.key_name}.pem"
}
provisioner "local-exec" {
when = "destroy"
command = "aws s3 rm s3://PATHTOKEYPAIR/${module.ssh_key_pair.key_name}.pub"
}

resource "aws_security_group" "allow-all" {
    name="allow-all"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 6556
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
    Name = "allow-RDP"
    }
}

resource "aws_instance" "this" {
    ami = "({var.ami, var.AWS_REGION)}"
    instance_type = "G3.4xLarge"
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 100

  tags = {
    Name = "parsec.$(id)"
  }
}