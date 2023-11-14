# Create vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  tags = {
    Name = var.name
  }
}
# Create internet gateway
resource "aws_internet_gateway" "igws" {
  for_each = var.internet_gws
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = "${each.value.name}-${var.name}"
  }
}
# Create nat and elastic ip
resource "aws_nat_gateway" "nats" {
  for_each      = var.nat_gws
  allocation_id = aws_eip.nats[each.key].id
  subnet_id     = aws_subnet.subnet[each.value.subnet].id
  tags = {
    Name = "${each.value.name}-${var.name}"
  }
}
resource "aws_eip" "nats" {
  for_each = var.nat_gws
}
# Create subnet
resource "aws_subnet" "subnet" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.public_ip_on_launch
  availability_zone       = each.value.availability_zone
  tags = {
    Name = "${each.value.name}-${var.name}"
  }
}
# Create route table
resource "aws_route_table" "routes" {
  for_each = var.subnets
  vpc_id   = aws_vpc.vpc.id
  dynamic "route" {
    for_each = [
      for route in each.value.routes :
      route
      if route.internet_gw != null
    ]
    content {
      cidr_block = route.value.cidr
      gateway_id = aws_internet_gateway.igws[route.value.internet_gw].id
    }
  }
  dynamic "route" {
    for_each = [
      for route in each.value.routes :
      route
      if route.nat_gw != null
    ]
    content {
      cidr_block = route.value.cidr
      nat_gateway_id = aws_nat_gateway.nats[route.value.nat_gw].id
    }
  }
  route {
    cidr_block = var.cidr
    gateway_id = "local"
  }
  tags = {
    Name = "rtb-${each.value.name}-${var.name}"
  }
}
# Create route table association
resource "aws_route_table_association" "subnets" {
  for_each       = aws_subnet.subnet
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.routes[each.key].id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [for key, subnet in aws_subnet.subnet : subnet.id if contains(keys(var.subnets), key)]
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [for subnet in aws_subnet.subnet : subnet.id if subnet.map_public_ip_on_launch]
}
