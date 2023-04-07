resource "oci_core_instance" "instance" {
  count               = 4
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.project_name}-instance-0${count.index}"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet01.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "instance-0${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = var.node_ami_ocid
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

output "master_node_ip" {
  value = oci_core_instance.instance[0].public_ip
}

output "other_nodes_ip" {
  value = slice(oci_core_instance.instance[*].public_ip, 1, length(oci_core_instance.instance))
}