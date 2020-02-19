# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "dns" {
  source                = "../../"

  default_compartment_id = var.default_compartment_id
  default_ssh_auth_keys  = var.default_ssh_auth_keys
  vcn_id                 = oci_core_vcn.this.id
  vcn_cidr               = oci_core_vcn.this.cidr_block
  default_img_name       = var.default_img_name

  create_subnet      = false
  existing_subnet_id = oci_core_subnet.test.id

  dns_src_cidrs = [
    oci_core_vcn.this.cidr_block
  ]
  dns_dst_cidrs = [
    "10.1.2.3/32",
    "172.16.3.2/32"
  ]

  compute_options = {
    compartment_id     = null
    shape              = "VM.Standard2.1"
    public_ip          = true
    defined_tags       = null
    freeform_tags      = null
    vnic_defined_tags  = null
    vnic_freeform_tags = null
    ssh_auth_keys      = null
    user_data          = null
    boot_vol_img_name  = null
    boot_vol_img_id    = null
    boot_vol_size      = null
  }
}

resource "oci_core_subnet" "test" {
  cidr_block                 = "192.168.100.0/24"
  compartment_id             = var.default_compartment_id
  vcn_id                     = oci_core_vcn.this.id
  display_name               = "test"
  dns_label                  = "test"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_vcn" "this" {
  dns_label      = "dns"
  cidr_block     = "192.168.0.0/16"
  compartment_id = var.default_compartment_id
  display_name   = "dns_example"
}
