resource "oci_core_virtual_network" "vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = var.project_name
  dns_label      = replace(var.project_name, "-", "")
}

resource "oci_core_subnet" "subnet01" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "${var.project_name}-subnet-01"
  dns_label         = "subnet01"
  security_list_ids = [oci_core_security_list.internet_permissive_sl.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  route_table_id    = oci_core_route_table.route_table.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.project_name}-igw"
  vcn_id         = oci_core_virtual_network.vcn.id
}

resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.project_name}-rtb"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_security_list" "internet_permissive_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.project_name}-permissive-sl"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "443"
      min = "443"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = oci_core_virtual_network.vcn.cidr_block

    tcp_options {
      max = "0"
      min = "0"
    }
  }

}