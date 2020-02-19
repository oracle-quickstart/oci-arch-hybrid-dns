# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# in this example, TF isn't smart enough to handle the multiple dependencies... you need to run terraform apply -target=oci_core_network_security_group.test first, then terraform apply
resource "oci_core_network_security_group" "test" {
  compartment_id = var.default_compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "test"
}

resource "oci_core_vcn" "this" {
  dns_label      = "dns"
  cidr_block     = "192.168.0.0/16"
  compartment_id = var.default_compartment_id
  display_name   = "dns_example"
}

module "dns" {
  source = "../../"

  default_compartment_id = var.default_compartment_id
  vcn_id                 = oci_core_vcn.this.id
  vcn_cidr               = oci_core_vcn.this.cidr_block
  default_ssh_auth_keys  = var.default_ssh_auth_keys
  default_img_name       = var.default_img_name

  dns_src_cidrs = [
    oci_core_vcn.this.cidr_block
  ]
  dns_dst_cidrs = [
    "10.1.2.3/32",
    "172.16.3.2/32"
  ]

  create_nsg      = false
  existing_nsg_id = oci_core_network_security_group.test.id
}
