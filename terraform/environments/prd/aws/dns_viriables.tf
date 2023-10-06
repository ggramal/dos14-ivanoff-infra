variable "domain_name" {
  description = "The domain name for Route53"
  type        = string
}

variable "records" {
  description = "A list of DNS records"
  type = list(object({
    zone_id = string
    name    = string
    type    = string
    ttl     = string
    records = list(string)
  }))
  default = []
}

variable "record_type" {
  description = "Type of DNS"
  type        = string
}

