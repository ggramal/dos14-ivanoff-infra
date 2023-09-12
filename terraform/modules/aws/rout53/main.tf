provider "aws" {
  region = "eu-central-1"
}

resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "record" {
  count   = length(var.records)
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.domain_name
  type    = var.record_type
  ttl     = "300"
  records = [split(",", var.records)[count.index]]
}
