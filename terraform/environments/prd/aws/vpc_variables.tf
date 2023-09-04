locals {
  vpcs = {
    ivanoff-tf = {
      name = "vpc-ivanoff-tf"
      cidr = "10.0.0.0/16"
      internet_gws = {
        igw1 = {
          name = "igw-ivanoff"
        }
      }
      nat_gws = {
        nat1 = {
          name   = "nat-ivanoff"
          subnet = "public-subnet-1a"
        }
      }
      subnets = {
        public-subnet-1a = {
          name                = "public-1a-ivanoff"
          cidr                = "10.0.1.0/24"
          public_ip_on_launch = true
          availability_zone   = "eu-north-1a"
          routes = [
            {
              cidr         = "0.0.0.0/0"
              internet_gws = "igw1"
            }
          ]
        }
        private-subnet-1a = {
          name              = "private-1a-ivanoff"
          cidr              = "10.0.4.0/24"
          availability_zone = "eu-north-1a"
          routes = [
            {
              cidr    = "0.0.0.0/0"
              nat_gws = "nat1"
            }
          ]
        }
      }
    }
  }
}