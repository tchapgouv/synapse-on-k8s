# Add a record with wildcard to the DNS zone for non production environment
resource "ovh_domain_zone_record" "dns_record_update" {
  count     = var.env_name != "production" ? 1 : 0
  zone      = var.dns_zone
  subdomain = "*.${var.env_in_url}"
  fieldtype = "A"
  ttl       = 3600
  target    = local.external_lb_ip
}