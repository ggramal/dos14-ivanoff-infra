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
    Name = "${var.name}-${each.value.name}"
  }
}
# Create nat anf elastic ip
resource "aws_nat_gateway" "nats" {
  for_each      = var.nat_gws
  allocation_id = aws_eip.nats[each.key].id
  subnet_id     = aws_subnet.subnet[each.value.subnet].id
  tags = {
    Name = "${var.name}-${each.value.name}"
  }
}
resource "aws_eip" "nats" {
  for_each = var.nat_gws
  domain   = "vpc"
}
# Create subnet
resource "aws_subnet" "subnet" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.public_ip_on_launch
  availability_zone       = each.value.availability_zone
  tags = {
    Name = "${var.name}-${each.value.name}"
  }
}
#resource "aws_route_table" "routes" {
#  for_each = var.subnets
#  vpc_id   = aws_vpc.main.id
#  route {
#    cidr_block = var.cidr
#    gateway_id = "local"
#  }
#    tags = {
#        Name = "rtb-ivanoff"
#      }
# }
# Create private route table and the route to the nat
resource "aws_route_table" "private_route" {
  for_each = aws_nat_gateway.nats
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nats[each.key].id
  }
  tags = {
    Name = "rt-private-ivanoff"
  }
  route {
    cidr_block = var.cidr
    gateway_id = "local"
  }
}
# Create public route table and the route to the internet
resource "aws_route_table" "public_route" {
  vpc_id   = aws_vpc.vpc.id
  for_each = var.internet_gws
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igws[each.key].id
  }
  tags = {
    Name = "rt-public-ivanoff"
  }
  route {
    cidr_block = var.cidr
    gateway_id = "local"
  }
}
# Route Table Associations
# private
resource "aws_route_table_association" "route_table_association_private" {
  #  depends_on = [aws_subnet.subnet]
  for_each       = aws_subnet.subnet
  subnet_id      = aws_subnet.subnet[each.value].id
  route_table_id = aws_route_table.private_route.id
}
# public
resource "aws_route_table_association" "route_table_association_public" {
  #  depends_on = [aws_subnet.subnet]
  for_each       = aws_subnet.subnet
  route_table_id = aws_route_table.public_route[each.value.id]
  subnet_id      = each.value.id
}

#resource "aws_route_table_association" "subnets" {
#  for_each       = var.subnets
#  subnet_id      = aws_subnet.main[each.key].id
#  route_table_id = aws_route_table.route[each.key].id
#}