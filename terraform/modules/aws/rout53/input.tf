variable "domain_name" {
  description = "The domain name for Route53"
  type        = string
}

variable "records" {
  description = "A address of DNS records"
  type        = list(string)
}

variable "record_type" {
  description = "Type of DNS"
  type        = string
}



