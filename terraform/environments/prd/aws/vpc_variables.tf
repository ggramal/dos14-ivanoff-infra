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
  rds = {
    rds-ivanoff-tf = {
      name                = "rds-ivanoff-tf"
      engine              = "postgres"
      identifier          = "rds-ivanoff-tf"
      allocated_storage   = 5
      engine_version      = "15.3"
      instance_class      = "db.t3.micro"
      username            = "Ivanoff"
      skip_final_snapshot = true
      rds-subnet = {
        rds-subnet-1a = {
          name              = "rds-subnet-1a-ivanoff-tf"
          cidr              = "10.0.7.0/24"
          availability_zone = "eu-north-1a"
        }
        rds-subnet-1b = {
          name              = "rds-subnet-1b-ivanoff-tf"
          cidr              = "10.0.8.0/24"
          availability_zone = "eu-north-1b"
        }
      }
      rds-sg = {
        ingress = {
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
        }
        egress = {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
        }
      }
    }
  }

  asgs = {
    asg_sg = {
      ingress_443 = {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
        }
      ingress_80 = {
        from_port  = 80
        to_port    = 80
        protocol   = "tcp"
        cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
      }
      ingress_jump = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
      }
      egress = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    asgs_services = {
      asg_ivanoff_authn_tf = {
        lt = {
          name = "lt-authn-tf"
          path = "./files/cloud-configs/authn.yaml"
          instance_type = "t3.micro"
          git_branch = "features-hw-24-26"
          secret = var.secrets.authn
        }
        asg = {
          name = "asg-authn-tf"
          vpc_zone_identifier = [module.vpcs.private_1b[0], module.vpcs.private_1c[0]]
          desired_capacity = 2
          min_size = 2
          max_size = 4
        }
      }

      asg_ivanoff_authz_tf = {
        lt = {
          name = "lt-authz-tf"
          path = "./files/cloud-configs/authz.yaml"
          instance_type = "t3.micro"
          git_branch = "feature-hw-26"
          secret = var.secrets.authz
        }
        asg = {
          name = "asg-authz-tf"
          vpc_zone_identifier = [module.vpcs.private_1a[0], module.vpcs.private_1c[0]]
          desired_capacity = 2
          min_size = 2
          max_size = 4
        }
      }

      asg_ivanoff_bank_tf = {
        lt = {
          name = "lt-bank-tf"
          path = "./files/cloud-configs/bank.yaml"
          instance_type = "t3.micro"
          git_branch = "feature-hw-26"
          secret = var.secrets.bank
        }
        asg = {
          name = "asg-bank-tf"
          vpc_zone_identifier = [module.vpcs.private_1a[0], module.vpcs.private_1b[0]]
          desired_capacity = 2
          min_size = 2
          max_size = 4
        }
      }
    }  
  }
}
