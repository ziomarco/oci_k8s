data "aws_route53_zone" "dns_zone" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "record" {
  name    = var.lb_domain_hostname
  type    = "A"
  records = toset(oci_load_balancer_load_balancer.nodes_lb.ip_address_details)[*].ip_address
  zone_id = data.aws_route53_zone.dns_zone.id
  ttl     = 60
}

resource "aws_route53_record" "master" {
  name    = "console.${replace(var.lb_domain_hostname, "*.", "")}"
  type    = "A"
  records = [oci_core_instance.instance[0].public_ip]
  zone_id = data.aws_route53_zone.dns_zone.id
  ttl     = 60
}