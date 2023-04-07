resource "oci_load_balancer_load_balancer" "nodes_lb" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.project_name}-nodes-lb"
  shape          = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }

  subnet_ids = [
    oci_core_subnet.subnet01.id,
  ]
}

resource "oci_load_balancer_backend_set" "lb_nodes_set_http" {
  name             = "${var.project_name}-nodes-set-http"
  load_balancer_id = oci_load_balancer_load_balancer.nodes_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol          = "TCP"
    interval_ms       = 5000
    port              = "80"
    retries           = 3
    timeout_in_millis = 8000
  }
}

resource "oci_load_balancer_backend_set" "lb_nodes_set_https" {
  name             = "${var.project_name}-nodes-set-https"
  load_balancer_id = oci_load_balancer_load_balancer.nodes_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol          = "TCP"
    interval_ms       = 5000
    port              = "80"
    retries           = 3
    timeout_in_millis = 8000
  }
}

resource "oci_load_balancer_backend" "lb_nodes_backend_http" {
  count            = 3
  backendset_name  = oci_load_balancer_backend_set.lb_nodes_set_http.name
  ip_address       = oci_core_instance.instance[count.index+1].public_ip
  load_balancer_id = oci_load_balancer_load_balancer.nodes_lb.id
  port             = "80"
}

resource "oci_load_balancer_backend" "lb_nodes_backend_https" {
  count            = 3
  backendset_name  = oci_load_balancer_backend_set.lb_nodes_set_https.name
  ip_address       = oci_core_instance.instance[count.index+1].public_ip
  load_balancer_id = oci_load_balancer_load_balancer.nodes_lb.id
  port             = "443"
}

resource "oci_load_balancer_hostname" "lb_domain_hostname" {
  #Required
  hostname         = var.lb_domain_hostname
  load_balancer_id = oci_load_balancer_load_balancer.nodes_lb.id
  name             = "${var.project_name}-lb-hostname"
}

resource "oci_load_balancer_listener" "load_balancer_listener_http" {
  load_balancer_id         = oci_load_balancer_load_balancer.nodes_lb.id
  name                     = "${var.project_name}-lb-listener-http"
  default_backend_set_name = oci_load_balancer_backend_set.lb_nodes_set_http.name
  hostname_names           = [oci_load_balancer_hostname.lb_domain_hostname.name]
  port                     = 80
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "240"
  }
}

resource "oci_load_balancer_listener" "load_balancer_listener_https" {
  load_balancer_id         = oci_load_balancer_load_balancer.nodes_lb.id
  name                     = "${var.project_name}-lb-listener-https"
  default_backend_set_name = oci_load_balancer_backend_set.lb_nodes_set_https.name
  port                     = 443
  protocol                 = "HTTP"
}

output "lb_public_ip" {
  value = oci_load_balancer_load_balancer.nodes_lb.ip_address_details
}