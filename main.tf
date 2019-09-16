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
    ami = "${lookup(var.WIN_AMIS, var.AWS_REGION)}"
    instance_type = "G2.2xLarge"
}

# -- Figure out how to run https://github.com/jamesstringerparsec/Parsec-Cloud-Preparation-Tool
  provisioner "remote-exec" {
    command = "",
    interpreter = ["PowerShell"]
  }