data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] #Canonical
}

resource "aws_launch_template" "lt" {
    for_each = var.asg.asgs_services
    name = each.value.name
    ami = data.aws_ami.ubuntu.image_id
    instance_type = "t3.micro"
    key_name = "esa"
    vpc_security_group_ids = ["${aws_security_group.asg_sg.id}"]
    
}

resource "aws_autoscaling_group" "asg" {
    for_each = var.asg.asgs_services
    name = each.value.name
    availability_zones = each.value.availability_zones
    desired_capacity = each.value.desired_capacity
    min_size = each.value.min_size
    max_size = each.value.max_size
    launch_template {
      id = each.value.value.lt.name.id
      version = "$Latest"
    }
}

resource "aws_security_group" "asg-sg" {
  vpc_id = var.vpc_id
  ingress {
    for_each    = var.asgs.asg_sg.ingress
    from_port   = var.rds-sg.ingress.from_port
    to_port     = var.rds-sg.ingress.to_port
    protocol    = var.rds-sg.ingress.protocol
    cidr_blocks = var.rds-sg.ingress.cidr_blocks
  }
  egress {
    from_port   = var.rds-sg.egress.from_port
    to_port     = var.rds-sg.egress.to_port
    protocol    = var.rds-sg.egress.protocol
    cidr_blocks = var.rds-sg.egress.cidr_blocks
  }
  tags = {
    Name = "asg-sg-ivanoff-tf"
  }
}