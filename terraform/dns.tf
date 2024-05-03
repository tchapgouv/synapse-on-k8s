# if the environment has its own dns_zone, then no subdomain is needed
# if not, then adding a subdomain in the base_url is required
# Ex: Lagraulet environment share its dns zone (eimis.incubateur.net)
#   so its base_url is "lagraulet.eimis.incubateur.net" with "*.lagraulet" as subdomain
# Ex: Develop environment have its own dns zone (develop.eimis.incubateur.net)
#   so its base_url is "develop.eimis.incubateur.net" with "*" subdomain
locals {
  subdomain = var.dns_zone_exclusive ? "*" : "*.${var.env_in_url}"
  base_url  = var.dns_zone_exclusive ? var.dns_zone : "${var.env_in_url}.${var.dns_zone}"
}

# Add a record with wildcard to the DNS zone
resource "ovh_domain_zone_record" "dns_record_update" {
  zone      = var.dns_zone
  subdomain = local.subdomain
  fieldtype = "A"
  ttl       = 3600
  target    = local.external_lb_ip
}
