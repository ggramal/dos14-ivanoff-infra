provider "aws" {
  region = "eu-north-1"
}

resource "aws_route53_zone" "zone" {
  name = var.domain_name
}


resource "aws_route53_record" "record" {
  for_each = { for idx, record in var.records : idx => record }

  zone_id = aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = "300"
  records = each.value.records
}
