variable "domain_name" {
  description = "The domain name for Route53"
  type        = string
  default     = "ivanoff.smodata.net"
}

variable "records" {
  description = "A string of DNS records, example: 192.168.1.1,192.168.1.2"
  type        = string
}

variable "record_type" {
  description = "Type of DNS"
  type        = string
  default     = "A"
}



