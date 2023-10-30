# create a RDS subnet
resource "aws_subnet" "rds-subnet" {
  for_each          = var.rds-subnet
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone
  tags = {
    Name = "${each.value.name}"
  }
}
# create a RDS subnet group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = values(aws_subnet.rds-subnet)[*].id

  tags = {
    Name = "DB subnet group ivanoff tf"
  }
}
# create a RDS security group
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id
  ingress {
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
    Name = "rds-sg-ivanoff-tf"
  }
}
# generate random RDS password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


# create a RDS Database Instance
resource "aws_db_instance" "postgres" {
  engine                 = var.engine
  identifier             = var.identifier
  allocated_storage      = var.allocated_storage
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = random_password.password.result
  parameter_group_name   = var.parameter_group_name
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  skip_final_snapshot    = var.skip_final_snapshot
}





