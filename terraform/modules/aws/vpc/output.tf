output "vpc_id" {
  value       = aws_vpc.vpc.id
}

output "private_1a" {
  value = [
    for subnet_key, subnet_obj in aws_subnet.subnet :
    subnet_obj.id
    if length(regexall("private", subnet_key)) > 0 && length(regexall("1a", subnet_key)) > 0
  ]
}

output "private_1b" {
  value = [
    for subnet_key, subnet_obj in aws_subnet.subnet :
    subnet_obj.id
    if length(regexall("private", subnet_key)) > 0 && length(regexall("1b", subnet_key)) > 0
  ]
}

output "private_1c" {
  value = [
    for subnet_key, subnet_obj in aws_subnet.subnet :
    subnet_obj.id
    if length(regexall("private", subnet_key)) > 0 && length(regexall("1c", subnet_key)) > 0
  ]
}

output "private_subnet_ids" {
  value = [
    for subnet_key, subnet_obj in aws_subnet.subnet :
    subnet_obj.id
    if length(regexall("private", subnet_key)) > 0
  ]
}
