provider "aws" {
  region = "eu-north-1"
}

resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "record" {
  count   = length(var.records)
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.records[0].name
  type    = var.records[0].type
  ttl     = "300"
  records = var.records[0].records
}
