terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }

  backend "s3" {
    bucket         = "dos14-tf-state"
    key            = "ivanoff/prd/aws/state.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf_state_ivanoff"
  }
}

provider "aws" {
  region = "eu-north-1"
}

locals {
  instances = {
    "instance1" = {
      name = "bank-1"
  dns_records = [
    {
        "zone_id" = "zone_id_1"
        "name"    = "ivan"
        "type"    = "A"
        "ttl"     = "300"
        "records" = ["192.168.1.1"]
    },
    {
        "zone_id" = "zone_id_2"
        "name"    = "ivan.durak"
        "type"    = "CNAME"
        "ttl"     = "3600"
        "records" =  ["192.168.1.2"]
    },
]
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
module "vpcs" {
  source       = "../../../modules/aws/vpc"
  name         = local.vpcs["ivanoff-tf"].name
  cidr         = local.vpcs["ivanoff-tf"].cidr
  internet_gws = local.vpcs["ivanoff-tf"].internet_gws
  nat_gws      = local.vpcs["ivanoff-tf"].nat_gws
  subnets      = local.vpcs["ivanoff-tf"].subnets
}

module "dns" {
  source   = "../../../modules/aws/rout53"
  domain_name  = var.domain_name
  records      = var.records
  record_type  = var.record_type
  
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
