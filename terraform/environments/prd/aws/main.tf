terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

locals {
  instances = {
    "instance1" = {
      name = "bank-1"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "bank" {
  for_each               = local.instances
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = "t3.micro"
  key_name               = "esa"
  vpc_security_group_ids = ["sg-054db3afbc0cbfe19"]
  tags = {
    Name = each.value.name
  }

  provisioner "local-exec" {
    working_dir = "/home/tima/git-flow/dos14-Labzeev_Timofey-git-flow/"
    command     = "sleep 100 && echo $(self.public_ip) > inventory.ini && ansible-playbook -i inventory.ini playbook.yaml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}
