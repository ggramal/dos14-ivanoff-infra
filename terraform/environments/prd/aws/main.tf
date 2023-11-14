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

module "asgs" {
  source = "../../../modules/aws/asg"
  asg_sg = local.asgs.asg_sg
  asg_services = local.asgs.asgs_services
  vpc_id = module.vpcs.vpc_id
}
###  !!!!!!   DON`T REMOVE "bank"  !!!!!!

#resource "aws_instance" "bank" {
#  ami                    = data.aws_ami.ubuntu.image_id
#  instance_type          = "t3.micro"
#  key_name               = "gae"
#  vpc_security_group_ids = ["sg-054db3afbc0cbfe19"]
#}

module "rds" {
  source              = "../../../modules/aws/rds"
  name                = local.rds["rds-ivanoff-tf"].name
  engine              = local.rds["rds-ivanoff-tf"].engine
  identifier          = local.rds["rds-ivanoff-tf"].identifier
  allocated_storage   = local.rds["rds-ivanoff-tf"].allocated_storage
  engine_version      = local.rds["rds-ivanoff-tf"].engine_version
  instance_class      = local.rds["rds-ivanoff-tf"].instance_class
  username            = local.rds["rds-ivanoff-tf"].username
  skip_final_snapshot = local.rds["rds-ivanoff-tf"].skip_final_snapshot
  rds-subnet          = local.rds["rds-ivanoff-tf"].rds-subnet
  rds-sg              = local.rds["rds-ivanoff-tf"].rds-sg
  vpc_id              = module.vpcs.vpc_id
}

