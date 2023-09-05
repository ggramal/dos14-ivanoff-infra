provider "aws" {
  region = "eu-central-1"
}

resource "aws_route53_zone" "zone" {
  name = "ivanoff.smodata.net"
}

resource "aws_route53_record" "record" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = aws_route53_zone.zone.name
  type    = "A"
  ttl     = "300"
  records = [""]
}
