# only environments listed in env_with_own_dns_zone have their own dns zone.
# other environment share dns zone, so they need other subdomains (env_in_url) in their URL.
# Ex: Lagraulet environment does not have its own dns zone (eimis.incubateur.net)
#   so its base_url is "lagraulet.eimis.incubateur.net" with "*.lagraulet" subdomain
# Ex: Develop environment have its own dns zone (develop.eimis.incubateur.net)
#   so its base_url is "develop.eimis.incubateur.net" with "*" subdomain
locals {
  subdomain = contains(var.env_with_own_dns_zone, var.env_name) ? "*" : "*.${var.env_in_url}"
  base_url  = contains(var.env_with_own_dns_zone, var.env_name) ? var.dns_zone : "${var.env_in_url}.${var.dns_zone}"
}

# Add a record with wildcard to the DNS zone
resource "ovh_domain_zone_record" "dns_record_update" {
#   count     = var.env_name != "production" ? 1 : 0
  zone      = var.dns_zone
  subdomain = local.subdomain
  fieldtype = "A"
  ttl       = 3600
  target    = local.external_lb_ip
}
