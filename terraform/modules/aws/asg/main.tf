data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516*"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] #Canonical
}

resource "aws_launch_template" "lt" {
    for_each = var.asg_services
    name = each.value.lt.name
    image_id = data.aws_ami.ubuntu.id
    instance_type = each.value.lt.instance_type
    key_name = "esa"
    vpc_security_group_ids = ["${aws_security_group.asg_sg.id}"]
    user_data = base64encode(templatefile(each.value.lt.path, {
      branch = each.value.lt.git_branch,
      secret = each.value.lt.secret
    }))
}

resource "aws_autoscaling_group" "asg" {
    for_each = var.asg_services
    name = each.value.asg.name
    vpc_zone_identifier = each.value.asg.vpc_zone_identifier
    desired_capacity = each.value.asg.desired_capacity
    min_size = each.value.asg.min_size
    max_size = each.value.asg.max_size
    launch_template {
      id = aws_launch_template.lt[each.key].id
      version = "$Latest"
    }
}

resource "aws_security_group" "asg_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = var.asg_sg.ingress_443.from_port
    to_port     = var.asg_sg.ingress_443.to_port
    protocol    = var.asg_sg.ingress_443.protocol
    cidr_blocks = var.asg_sg.ingress_443.cidr_blocks
  }

  ingress {
    from_port   = var.asg_sg.ingress_80.from_port
    to_port     = var.asg_sg.ingress_80.to_port
    protocol    = var.asg_sg.ingress_80.protocol
    cidr_blocks = var.asg_sg.ingress_80.cidr_blocks
  }

  egress {
    from_port   = var.asg_sg.egress.from_port
    to_port     = var.asg_sg.egress.to_port
    protocol    = var.asg_sg.egress.protocol
    cidr_blocks = var.asg_sg.egress.cidr_blocks
  }
  tags = {
    Name = "asg-sg-ivanoff-tf"
  }
}