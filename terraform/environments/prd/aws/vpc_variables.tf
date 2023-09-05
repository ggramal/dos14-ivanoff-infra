locals {
  vpcs = {
    ivanoff-tf = {
      name = "vpc-ivanoff-tf"
      cidr = "10.0.0.0/16"
      internet_gws = {
        igw1 = {
          name = "igw"
        }
      }
      nat_gws = {
        nat1 = {
          name   = "nat"
          subnet = "public-subnet-1c"
        }
      }
      subnets = {
        public-subnet-1a = {
          name                = "public-1a"
          cidr                = "10.0.1.0/24"
          public_ip_on_launch = true
          availability_zone   = "eu-north-1a"
          routes = [
            {
              cidr        = "0.0.0.0/0"
              internet_gw = "igw1"
            }
          ]
        }
        public-subnet-1b = {
          name                = "public-1b"
          cidr                = "10.0.2.0/24"
          public_ip_on_launch = true
          availability_zone   = "eu-north-1b"
          routes = [
            {
              cidr        = "0.0.0.0/0"
              internet_gw = "igw1"
            }
          ]
        }
        public-subnet-1c = {
          name                = "public-1c"
          cidr                = "10.0.3.0/24"
          public_ip_on_launch = true
          availability_zone   = "eu-north-1c"
          routes = [
            {
              cidr        = "0.0.0.0/0"
              internet_gw = "igw1"
            }
          ]
        }
        private-subnet-1a = {
          name              = "private-1a"
          cidr              = "10.0.4.0/24"
          availability_zone = "eu-north-1a"
          routes = [
            {
              cidr   = "0.0.0.0/0"
              nat_gw = "nat1"
            }
          ]
        }
        private-subnet-1b = {
          name              = "private-1b"
          cidr              = "10.0.5.0/24"
          availability_zone = "eu-north-1b"
          routes = [
            {
              cidr   = "0.0.0.0/0"
              nat_gw = "nat1"
            }
          ]
        }
        private-subnet-1c = {
          name              = "private-1c"
          cidr              = "10.0.6.0/24"
          availability_zone = "eu-north-1c"
          routes = [
            {
              cidr   = "0.0.0.0/0"
              nat_gw = "nat1"
            }
          ]
        }
      }
    }
  }
}