# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# in this example, TF isn't smart enough to handle the multiple dependencies... you need to run terraform apply -target=oci_core_network_security_group.test first, then terraform apply
module "oci_network" {
  source                = "github.com/oracle/terraform-oci-tdf-network.git?ref=v0.9.7"

  default_compartment_id = var.default_compartment_id

  vcn_options = {
    display_name   = "dns_example"
    cidr           = "192.168.0.0/19"
    enable_dns     = true
    dns_label      = "dns"
    compartment_id = null
    defined_tags   = null
    freeform_tags  = null
  }
}

module "dns" {
  source                = "../../"

  default_compartment_id = var.default_compartment_id
  default_ssh_auth_keys  = var.default_ssh_auth_keys
  default_img_name       = var.default_img_name

  vcn_id   = module.oci_network.vcn.id
  vcn_cidr = module.oci_network.vcn.cidr_block

  dns_src_cidrs = [
    module.oci_network.vcn.cidr_block
  ]
  dns_dst_cidrs = [
    "10.1.2.3/32",
    "172.16.3.2/32"
  ]

  compute_options = {
    compartment_id     = null
    shape              = "VM.Standard2.1"
    public_ip          = false
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
