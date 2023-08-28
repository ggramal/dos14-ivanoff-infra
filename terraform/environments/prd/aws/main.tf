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
resource "aws_instance" "bank" {
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = "t3.micro"
  key_name               = "gae"
  vpc_security_group_ids = ["sg-054db3afbc0cbfe19"]
}
