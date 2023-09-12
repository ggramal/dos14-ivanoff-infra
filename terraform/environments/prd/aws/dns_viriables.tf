variable "domain_name" {
  description = "The domain name for Route53"
  type        = string
}

variable "records" {
  description = "A string of DNS records, example: ["192.158.1.1"]"
  type        = list(string)
}

variable "record_type" {
  description = "Type of DNS"
  type        = string
}



