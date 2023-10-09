domain_name = "ivanoff.smodata.net"
record_type = "A"

records = [
  {
    zone_id     = "zone_id_1"
    name        = "ivan"
    type        = "A"
    ttl         = "300"
    records     = ["192.168.1.1"]
  },
  {
    zone_id     = "zone_id_2"
    name        = "ivan.durak"
    type        = "CNAME"
    ttl         = "3600"
    records     = ["192.168.1.2"]
  }
]
