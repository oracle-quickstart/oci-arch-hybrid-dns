# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


locals {
  # subnet-specific stuff
  subnet_name = var.subnet_options != null ? (var.subnet_options.name != null ? var.subnet_options.name : "dns") : "dns"
  subnet_id = var.create_subnet == true ? oci_core_subnet.this[0].id : var.existing_subnet_id
  subnet_options_defaults = {
    compartment_id = var.default_compartment_id
    defined_tags   = var.default_defined_tags
    freeform_tags  = var.default_freeform_tags
    dynamic_cidr   = false
    cidr           = "192.168.0.0/29"
    cidr_len       = null
    cidr_num       = null
    enable_dns     = true
    dns_label      = "dns"
    private        = true
    ad             = null
    dhcp_options_id   = null
    route_table_id    = null
    security_list_ids = null
  }

  vcn_id   = var.vcn_id
  vcn_cidr = var.vcn_cidr
}

resource "oci_core_subnet" "this" {
  count = var.create_subnet == true ? 1 : 0

  vcn_id                     = local.vcn_id
  cidr_block                 = var.subnet_options != null ? (var.subnet_options.cidr != null ? var.subnet_options.cidr : local.subnet_options_defaults.cidr) : local.subnet_options_defaults.cidr
  compartment_id             = var.subnet_options != null ? (var.subnet_options.compartment_id != null ? var.subnet_options.compartment_id : local.subnet_options_defaults.compartment_id) : local.subnet_options_defaults.compartment_id
  defined_tags               = var.subnet_options != null ? (var.subnet_options.defined_tags != null ? var.subnet_options.defined_tags : local.subnet_options_defaults.defined_tags) : local.subnet_options_defaults.defined_tags
  freeform_tags              = var.subnet_options != null ? (var.subnet_options.freeform_tags != null ? var.subnet_options.freeform_tags : local.subnet_options_defaults.freeform_tags) : local.subnet_options_defaults.freeform_tags
  display_name               = local.subnet_name
  prohibit_public_ip_on_vnic = var.subnet_options != null ? (var.subnet_options.private != null ? var.subnet_options.private : local.subnet_options_defaults.private) : local.subnet_options_defaults.private
  dns_label                  = var.subnet_options != null ? (var.subnet_options.dns_label != null ? var.subnet_options.dns_label : local.subnet_options_defaults.dns_label) : local.subnet_options_defaults.dns_label
  availability_domain        = var.subnet_options != null ? (var.subnet_options.ad != null ? var.subnet_options.ad : local.subnet_options_defaults.ad) : local.subnet_options_defaults.ad
  dhcp_options_id            = var.subnet_options != null ? (var.subnet_options.dhcp_options_id != null ? var.subnet_options.dhcp_options_id : local.subnet_options_defaults.dhcp_options_id) : local.subnet_options_defaults.dhcp_options_id
  route_table_id             = var.subnet_options != null ? (var.subnet_options.route_table_id != null ? var.subnet_options.route_table_id : local.subnet_options_defaults.route_table_id) : local.subnet_options_defaults.route_table_id
  security_list_ids          = var.subnet_options != null ? (var.subnet_options.security_list_ids != null ? var.subnet_options.security_list_ids : local.subnet_options_defaults.security_list_ids) : local.subnet_options_defaults.security_list_ids
}
/*
module "oci_subnets" {
  source                = "../../core/sdf-oci-core-subnet"
  
  default_compartment_id  = var.default_compartment_id
  vcn_id                = local.vcn_id
  vcn_cidr              = local.vcn_cidr
  
  subnets = var.create_subnet != true ? {} : {
    "${local.subnet_name}" = {
      compartment_id    = var.subnet_options != null ? ( var.subnet_options.compartment_id != null ? var.subnet_options.compartment_id : local.subnet_options_defaults.compartment_id ) : local.subnet_options_defaults.compartment_id
      defined_tags      = var.subnet_options != null ? ( var.subnet_options.defined_tags != null ? var.subnet_options.defined_tags : local.subnet_options_defaults.defined_tags ) : local.subnet_options_defaults.defined_tags
      freeform_tags     = var.subnet_options != null ? ( var.subnet_options.freeform_tags != null ? var.subnet_options.freeform_tags : local.subnet_options_defaults.freeform_tags ) : local.subnet_options_defaults.freeform_tags
      dynamic_cidr      = var.subnet_options != null ? ( var.subnet_options.dynamic_cidr != null ? var.subnet_options.dynamic_cidr : local.subnet_options_defaults.dynamic_cidr ) : local.subnet_options_defaults.dynamic_cidr
      cidr              = var.subnet_options != null ? ( var.subnet_options.cidr != null ? var.subnet_options.cidr : local.subnet_options_defaults.cidr ) : local.subnet_options_defaults.cidr
      cidr_len          = var.subnet_options != null ? ( var.subnet_options.cidr_len != null ? var.subnet_options.cidr_len : local.subnet_options_defaults.cidr_len ) : local.subnet_options_defaults.cidr_len
      cidr_num          = var.subnet_options != null ? ( var.subnet_options.cidr_num != null ? var.subnet_options.cidr_num : local.subnet_options_defaults.cidr_num ) : local.subnet_options_defaults.cidr_num
      enable_dns        = var.subnet_options != null ? ( var.subnet_options.enable_dns != null ? var.subnet_options.enable_dns : local.subnet_options_defaults.enable_dns ) : local.subnet_options_defaults.enable_dns
      dns_label         = var.subnet_options != null ? ( var.subnet_options.dns_label != null ? var.subnet_options.dns_label : local.subnet_options_defaults.dns_label ) : local.subnet_options_defaults.dns_label
      private           = var.subnet_options != null ? ( var.subnet_options.private != null ? var.subnet_options.private : local.subnet_options_defaults.private ) : local.subnet_options_defaults.private
      ad                = var.subnet_options != null ? ( var.subnet_options.ad != null ? var.subnet_options.ad : local.subnet_options_defaults.ad ) : local.subnet_options_defaults.ad
      dhcp_options_id   = var.subnet_options != null ? ( var.subnet_options.dhcp_options_id != null ? var.subnet_options.dhcp_options_id : local.subnet_options_defaults.dhcp_options_id ) : local.subnet_options_defaults.dhcp_options_id
      route_table_id    = var.subnet_options != null ? ( var.subnet_options.route_table_id != null ? var.subnet_options.route_table_id : local.subnet_options_defaults.route_table_id ) : local.subnet_options_defaults.route_table_id
      security_list_ids = var.subnet_options != null ? ( var.subnet_options.security_list_ids != null ? var.subnet_options.security_list_ids : local.subnet_options_defaults.security_list_ids ) : local.subnet_options_defaults.security_list_ids
    }
  }
}
*/

locals {
  # NSG rules (for when a bastion NSG is created)
  nsg_ingress_rules = concat([for i in var.dns_src_cidrs :
    {
      description = "Allow DNS queries from ${i}"
      stateless   = false
      protocol    = "17"
      src_type    = "CIDR_BLOCK"
      src         = i
      dst_port = {
        min = "53"
        max = "53"
      }
      src_port  = null
      icmp_type = null
      icmp_code = null
    }
    ], [for i in var.dns_src_nsg_ids :
    {
      description = "Allow DNS queries from NSG OCID ${i}"
      stateless   = false
      protocol    = "17"
      src_type    = "NETWORK_SECURITY_GROUP"
      src         = i
      dst_port = {
        min = "53"
        max = "53"
      }
      src_port  = null
      icmp_type = null
      icmp_code = null
    }
  ])
  nsg_egress_rules = concat([for i in var.dns_dst_cidrs :
    {
      description = "Allow DNS queries to ${i}"
      stateless   = false
      protocol    = "17"
      dst_type    = "CIDR_BLOCK"
      dst         = i
      dst_port = {
        min = "53"
        max = "53"
      }
      src_port  = null
      icmp_type = null
      icmp_code = null
    }
    ], [for i in var.dns_dst_nsg_ids :
    {
      description = "Allow DNS queries to NSG OCID ${i}"
      stateless   = false
      protocol    = "17"
      dst_type    = "NETWORK_SECURITY_GROUP"
      dst         = i
      dst_port = {
        min = "53"
        max = "53"
      }
      src_port  = null
      icmp_type = null
      icmp_code = null
    }
  ])

  # standalone NSG rules
  nsg_standalone_ingress_rules = var.existing_nsg_id == null ? [] : concat([for i in var.dns_src_cidrs :
    {
      description = "Allow DNS queries from ${i}"
      nsg_id      = var.existing_nsg_id
      stateless   = false
      protocol    = "17"
      src_type    = "CIDR_BLOCK"
      src         = i
      dst_port = {
        min = "53"
        max = "53"
      }
      src_port  = null
      icmp_type = null
      icmp_code = null
    }
    ], [for i in var.dns_src_nsg_ids :
    {
      description = "Allow DNS queries from NSG OCID ${i}"
      nsg_id      = var.existing_nsg_id
      stateless   = false
      protocol    = "17"
      src_type    = "NETWORK_SECURITY_GROUP"
      src         = i
      dst_port = {
        min = "53"
        max = "53"
      }
      src_port  = null
      icmp_type = null
      icmp_code = null
    }
  ])
  nsg_standalone_egress_rules = var.existing_nsg_id == null ? [] : concat([for i in var.dns_dst_cidrs :
    {
      description = "Allow DNS queries to ${i}"
      nsg_id      = var.existing_nsg_id
      stateless   = false
      protocol    = "17"
      dst_type    = "CIDR_BLOCK"
      dst         = i
      dst_port = {
        min = "53"
        max = "53"
      }
      src_port  = null
      icmp_type = null
      icmp_code = null
    }
    ], [for i in var.dns_dst_nsg_ids :
    {
      description = "Allow DNS queries to NSG OCID ${i}"
      nsg_id      = var.existing_nsg_id
      stateless   = false
      protocol    = "17"
      dst_type    = "NETWORK_SECURITY_GROUP"
      dst         = i
      dst_port = {
        min = "53"
        max = "53"
      }
      src_port  = null
      icmp_type = null
      icmp_code = null
    }
  ])

  nsg_options_defaults = {
    name           = "dns"
    compartment_id = null
    defined_tags   = null
    freeform_tags  = null
  }

  created_nsg_name = var.nsg_options != null ? (var.nsg_options.name != null ? var.nsg_options.name : local.nsg_options_defaults.name) : local.nsg_options_defaults.name
}

module "network_security_policies" {
  source                = "github.com/oracle/terraform-oci-tdf-network-security.git?ref=v0.9.7"

  default_compartment_id = var.default_compartment_id
  vcn_id                 = local.vcn_id

  nsgs = var.create_nsg != true ? {} : {
    "${local.created_nsg_name}" = {
      compartment_id = var.nsg_options != null ? (var.nsg_options.compartment_id != null ? var.nsg_options.compartment_id : var.default_compartment_id) : var.default_compartment_id
      defined_tags   = var.nsg_options != null ? (var.nsg_options.defined_tags != null ? var.nsg_options.defined_tags : var.default_defined_tags) : var.default_defined_tags
      freeform_tags  = var.nsg_options != null ? (var.nsg_options.freeform_tags != null ? var.nsg_options.freeform_tags : var.default_freeform_tags) : var.default_freeform_tags
      ingress_rules  = local.nsg_ingress_rules
      egress_rules   = local.nsg_egress_rules
    }
  }

  standalone_nsg_rules = var.create_nsg == true ? {
    ingress_rules = []
    egress_rules  = []
    } : {
    ingress_rules = local.nsg_standalone_ingress_rules != null ? local.nsg_standalone_ingress_rules : []
    egress_rules  = local.nsg_standalone_egress_rules != null ? local.nsg_standalone_egress_rules : []
  }
}


locals {
  compute_options_defaults = {
    ad                 = 0
    fd                 = null
    compartment_id     = null
    shape              = "VM.Standard1.1"
    assign_public_ip   = false
    vnic_defined_tags  = {}
    vnic_freeform_tags = {}
    vnic_display_name  = "dns"
    nsg_ids            = [],
    private_ip         = null
    public_ip          = false
    defined_tags       = {}
    name               = "dns"
    fault_domain       = null
    freeform_tags      = {}
    hostname_label     = "dns"
    ssh_auth_keys      = var.default_ssh_auth_keys
    user_data = var.create_compute != true ? null : base64encode(templatefile("${path.module}/scripts/dns.tpl", {
      dns_mappings     = var.dns_namespace_mappings != null ? var.dns_namespace_mappings : [] # local.dns_mappings
      rev_dns_mappings = var.reverse_dns_mappings != null ? var.reverse_dns_mappings : []     # local.rev_dns_mappings
      vcn_cidr         = local.vcn_cidr
    }))
    boot_vol_img_id   = var.default_img_id
    boot_vol_img_name = var.default_img_name
    source_id         = var.default_img_id
    source_type       = null
    mkp_image_name         = null
    mkp_image_name_version = null
    boot_vol_size     = 60
    kms_key_id        = null
    sec_vnics         = {}
    block_volumes     = []
  }
  # compute_name          = var.compute_options != null ? ( var.compute_options.name != null ? var.compute_options.name : local.compute_options_defaults.name ) : local.compute_options_defaults.name
  # compute_dns_name      = var.compute_options != null ? ( var.compute_options.hostname_label != null ? var.compute_options.hostname_label : local.compute_options_defaults.hostname_label ) : local.compute_options_defaults.hostname_label
  compute_nsg_ids            = var.create_nsg == true ? (length(module.network_security_policies.nsgs) > 0 ? concat([module.network_security_policies.nsgs["${local.created_nsg_name}"].id], local.compute_associated_nsg_ids) : concat([var.existing_nsg_id], local.compute_associated_nsg_ids)) : concat([var.existing_nsg_id], local.compute_associated_nsg_ids)
  compute_associated_nsg_ids = var.nsg_ids_to_associate != null ? var.nsg_ids_to_associate : []

  # num_dns_forwarders    = var.dns_forwarder_1 != null && var.dns_forwarder_2 != null && var.dns_forwarder_3 != null ? 3 : ( var.dns_forwarder_1 != null && var.dns_forwarder_2 != null ? 2 : ( var.dns_forwarder_1 != null ? 1 : 0 ) )
  instances = var.create_compute != true ? {} : var.num_dns_forwarders == 3 ? {
    "${var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"}" = {
      compartment_id              = var.compute_options != null ? (var.compute_options.compartment_id != null ? var.compute_options.compartment_id : null) : null
      shape                       = var.compute_options != null ? (var.compute_options.shape != null ? var.compute_options.shape : local.compute_options_defaults.shape) : local.compute_options_defaults.shape
      subnet_id                   = local.subnet_id
      is_monitoring_disabled      = null
      assign_public_ip            = var.compute_options != null ? (var.compute_options.public_ip != null ? var.compute_options.public_ip : local.compute_options_defaults.public_ip) : local.compute_options_defaults.public_ip
      vnic_defined_tags           = var.compute_options != null ? (var.compute_options.vnic_defined_tags != null ? var.compute_options.vnic_defined_tags : local.compute_options_defaults.vnic_defined_tags) : local.compute_options_defaults.vnic_defined_tags
      vnic_freeform_tags          = var.compute_options != null ? (var.compute_options.vnic_freeform_tags != null ? var.compute_options.vnic_freeform_tags : local.compute_options_defaults.vnic_freeform_tags) : local.compute_options_defaults.vnic_freeform_tags
      nsg_ids                     = local.compute_nsg_ids
      skip_src_dest_check         = false
      defined_tags                = var.compute_options != null ? (var.compute_options.defined_tags != null ? var.compute_options.defined_tags : local.compute_options_defaults.defined_tags) : local.compute_options_defaults.defined_tags
      freeform_tags               = var.compute_options != null ? (var.compute_options.freeform_tags != null ? var.compute_options.freeform_tags : local.compute_options_defaults.freeform_tags) : local.compute_options_defaults.freeform_tags
      extended_metadata           = null
      ipxe_script                 = null
      pv_encr_trans_enabled       = null
      ssh_authorized_keys         = var.compute_options != null ? (var.compute_options.ssh_auth_keys != null ? var.compute_options.ssh_auth_keys : local.compute_options_defaults.ssh_auth_keys) : local.compute_options_defaults.ssh_auth_keys
      ssh_private_keys            = []
      // See https://docs.cloud.oracle.com/iaas/images/ for image OCIDs and names
      image_name              = var.compute_options != null ? (var.compute_options.boot_vol_img_name != null ? var.compute_options.boot_vol_img_name : local.compute_options_defaults.boot_vol_img_name) : local.compute_options_defaults.boot_vol_img_name
      source_id               = var.compute_options != null ? (var.compute_options.boot_vol_img_id != null ? var.compute_options.boot_vol_img_id : local.compute_options_defaults.boot_vol_img_id) : local.compute_options_defaults.boot_vol_img_id
      source_type             = null
      mkp_image_name         = null
      mkp_image_name_version = null
      boot_vol_size_gbs       = var.compute_options != null ? (var.compute_options.boot_vol_size != null ? var.compute_options.boot_vol_size : local.compute_options_defaults.boot_vol_size) : local.compute_options_defaults.boot_vol_size
      preserve_boot_volume    = null
      instance_timeout        = null
      sec_vnics               = {}
      block_volumes           = []
      mount_blk_vols          = false
      cons_conn_create        = false
      cons_conn_def_tags      = {}
      cons_conn_free_tags     = {}

      user_data               = var.compute_options != null ? (var.compute_options.user_data != null ? var.compute_options.user_data : local.compute_options_defaults.user_data) : local.compute_options_defaults.user_data

      # instance-specific settings
      ad                  = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.ad != null ? var.dns_forwarder_1.ad : local.compute_options_defaults.ad) : local.compute_options_defaults.ad
      vnic_display_name   = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      private_ip          = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.private_ip != null ? var.dns_forwarder_1.private_ip : local.compute_options_defaults.private_ip) : local.compute_options_defaults.private_ip
      display_name        = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      fault_domain        = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.fd != null ? var.dns_forwarder_1.fd : local.compute_options_defaults.fd) : local.compute_options_defaults.fd
      hostname_label      = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      kms_key_id          = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.kms_key_id != null ? var.dns_forwarder_1.kms_key_id : local.compute_options_defaults.kms_key_id) : local.compute_options_defaults.kms_key_id
      bastion_ip           = null
    },
    "${var.dns_forwarder_2 != null ? (var.dns_forwarder_2.name != null ? var.dns_forwarder_2.name : "${local.compute_options_defaults.name}-2") : "${local.compute_options_defaults.name}-2"}" = {
      compartment_id              = var.compute_options != null ? (var.compute_options.compartment_id != null ? var.compute_options.compartment_id : null) : null
      shape                       = var.compute_options != null ? (var.compute_options.shape != null ? var.compute_options.shape : local.compute_options_defaults.shape) : local.compute_options_defaults.shape
      subnet_id                   = local.subnet_id
      is_monitoring_disabled      = null
      assign_public_ip            = var.compute_options != null ? (var.compute_options.public_ip != null ? var.compute_options.public_ip : local.compute_options_defaults.public_ip) : local.compute_options_defaults.public_ip
      vnic_defined_tags           = var.compute_options != null ? (var.compute_options.vnic_defined_tags != null ? var.compute_options.vnic_defined_tags : local.compute_options_defaults.vnic_defined_tags) : local.compute_options_defaults.vnic_defined_tags
      vnic_freeform_tags          = var.compute_options != null ? (var.compute_options.vnic_freeform_tags != null ? var.compute_options.vnic_freeform_tags : local.compute_options_defaults.vnic_freeform_tags) : local.compute_options_defaults.vnic_freeform_tags
      nsg_ids                     = local.compute_nsg_ids
      skip_src_dest_check         = false
      defined_tags                = var.compute_options != null ? (var.compute_options.defined_tags != null ? var.compute_options.defined_tags : local.compute_options_defaults.defined_tags) : local.compute_options_defaults.defined_tags
      freeform_tags               = var.compute_options != null ? (var.compute_options.freeform_tags != null ? var.compute_options.freeform_tags : local.compute_options_defaults.freeform_tags) : local.compute_options_defaults.freeform_tags
      extended_metadata           = null
      ipxe_script                 = null
      pv_encr_trans_enabled       = null
      ssh_authorized_keys         = var.compute_options != null ? (var.compute_options.ssh_auth_keys != null ? var.compute_options.ssh_auth_keys : local.compute_options_defaults.ssh_auth_keys) : local.compute_options_defaults.ssh_auth_keys
      ssh_private_keys            = []
      // See https://docs.cloud.oracle.com/iaas/images/ for image OCIDs and names
      image_name              = var.compute_options != null ? (var.compute_options.boot_vol_img_name != null ? var.compute_options.boot_vol_img_name : local.compute_options_defaults.boot_vol_img_name) : local.compute_options_defaults.boot_vol_img_name
      source_id               = var.compute_options != null ? (var.compute_options.boot_vol_img_id != null ? var.compute_options.boot_vol_img_id : local.compute_options_defaults.boot_vol_img_id) : local.compute_options_defaults.boot_vol_img_id
      source_type             = null
      mkp_image_name          = null
      mkp_image_name_version  = null
      boot_vol_size_gbs       = var.compute_options != null ? (var.compute_options.boot_vol_size != null ? var.compute_options.boot_vol_size : local.compute_options_defaults.boot_vol_size) : local.compute_options_defaults.boot_vol_size
      preserve_boot_volume    = null
      instance_timeout        = null
      sec_vnics               = {}
      block_volumes           = []
      mount_blk_vols          = false
      cons_conn_create        = false
      cons_conn_def_tags      = {}
      cons_conn_free_tags     = {}

      user_data               = var.compute_options != null ? (var.compute_options.user_data != null ? var.compute_options.user_data : local.compute_options_defaults.user_data) : local.compute_options_defaults.user_data

      # instance-specific settings
      ad                  = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.ad != null ? var.dns_forwarder_2.ad : local.compute_options_defaults.ad) : local.compute_options_defaults.ad
      vnic_display_name   = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.name != null ? var.dns_forwarder_2.name : "${local.compute_options_defaults.name}-2") : "${local.compute_options_defaults.name}-2"
      private_ip          = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.private_ip != null ? var.dns_forwarder_2.private_ip : local.compute_options_defaults.private_ip) : local.compute_options_defaults.private_ip
      display_name        = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.name != null ? var.dns_forwarder_2.name : "${local.compute_options_defaults.name}-2") : "${local.compute_options_defaults.name}-2"
      fault_domain        = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.fd != null ? var.dns_forwarder_2.fd : local.compute_options_defaults.fd) : local.compute_options_defaults.fd
      hostname_label      = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.name != null ? var.dns_forwarder_2.name : "${local.compute_options_defaults.name}-2") : "${local.compute_options_defaults.name}-2"
      kms_key_id          = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.kms_key_id != null ? var.dns_forwarder_2.kms_key_id : local.compute_options_defaults.kms_key_id) : local.compute_options_defaults.kms_key_id
      bastion_ip           = null
    },
    "${var.dns_forwarder_3 != null ? (var.dns_forwarder_3.name != null ? var.dns_forwarder_3.name : "${local.compute_options_defaults.name}-3") : "${local.compute_options_defaults.name}-3"}" = {
      compartment_id              = var.compute_options != null ? (var.compute_options.compartment_id != null ? var.compute_options.compartment_id : null) : null
      shape                       = var.compute_options != null ? (var.compute_options.shape != null ? var.compute_options.shape : local.compute_options_defaults.shape) : local.compute_options_defaults.shape
      subnet_id                   = local.subnet_id
      is_monitoring_disabled      = null
      assign_public_ip            = var.compute_options != null ? (var.compute_options.public_ip != null ? var.compute_options.public_ip : local.compute_options_defaults.public_ip) : local.compute_options_defaults.public_ip
      vnic_defined_tags           = var.compute_options != null ? (var.compute_options.vnic_defined_tags != null ? var.compute_options.vnic_defined_tags : local.compute_options_defaults.vnic_defined_tags) : local.compute_options_defaults.vnic_defined_tags
      vnic_freeform_tags          = var.compute_options != null ? (var.compute_options.vnic_freeform_tags != null ? var.compute_options.vnic_freeform_tags : local.compute_options_defaults.vnic_freeform_tags) : local.compute_options_defaults.vnic_freeform_tags
      nsg_ids                     = local.compute_nsg_ids
      skip_src_dest_check         = false
      defined_tags                = var.compute_options != null ? (var.compute_options.defined_tags != null ? var.compute_options.defined_tags : local.compute_options_defaults.defined_tags) : local.compute_options_defaults.defined_tags
      freeform_tags               = var.compute_options != null ? (var.compute_options.freeform_tags != null ? var.compute_options.freeform_tags : local.compute_options_defaults.freeform_tags) : local.compute_options_defaults.freeform_tags
      extended_metadata           = null
      ipxe_script                 = null
      pv_encr_trans_enabled       = null
      ssh_authorized_keys         = var.compute_options != null ? (var.compute_options.ssh_auth_keys != null ? var.compute_options.ssh_auth_keys : local.compute_options_defaults.ssh_auth_keys) : local.compute_options_defaults.ssh_auth_keys
      ssh_private_keys            = []
      // See https://docs.cloud.oracle.com/iaas/images/ for image OCIDs and names
      image_name              = var.compute_options != null ? (var.compute_options.boot_vol_img_name != null ? var.compute_options.boot_vol_img_name : local.compute_options_defaults.boot_vol_img_name) : local.compute_options_defaults.boot_vol_img_name
      source_id               = var.compute_options != null ? (var.compute_options.boot_vol_img_id != null ? var.compute_options.boot_vol_img_id : local.compute_options_defaults.boot_vol_img_id) : local.compute_options_defaults.boot_vol_img_id
      source_type             = null
      mkp_image_name          = null
      mkp_image_name_version  = null
      boot_vol_size_gbs       = var.compute_options != null ? (var.compute_options.boot_vol_size != null ? var.compute_options.boot_vol_size : local.compute_options_defaults.boot_vol_size) : local.compute_options_defaults.boot_vol_size
      preserve_boot_volume    = null
      instance_timeout        = null
      sec_vnics               = {}
      block_volumes           = []
      mount_blk_vols          = false
      cons_conn_create        = false
      cons_conn_def_tags      = {}
      cons_conn_free_tags     = {}

      user_data = var.compute_options != null ? (var.compute_options.user_data != null ? var.compute_options.user_data : local.compute_options_defaults.user_data) : local.compute_options_defaults.user_data

      # instance-specific settings
      ad                  = var.dns_forwarder_3 != null ? (var.dns_forwarder_3.ad != null ? var.dns_forwarder_3.ad : local.compute_options_defaults.ad) : local.compute_options_defaults.ad
      vnic_display_name   = var.dns_forwarder_3 != null ? (var.dns_forwarder_3.name != null ? var.dns_forwarder_3.name : "${local.compute_options_defaults.name}-3") : "${local.compute_options_defaults.name}-3"
      private_ip          = var.dns_forwarder_3 != null ? (var.dns_forwarder_3.private_ip != null ? var.dns_forwarder_3.private_ip : local.compute_options_defaults.private_ip) : local.compute_options_defaults.private_ip
      display_name        = var.dns_forwarder_3 != null ? (var.dns_forwarder_3.name != null ? var.dns_forwarder_3.name : "${local.compute_options_defaults.name}-3") : "${local.compute_options_defaults.name}-3"
      fault_domain        = var.dns_forwarder_3 != null ? (var.dns_forwarder_3.fd != null ? var.dns_forwarder_3.fd : local.compute_options_defaults.fd) : local.compute_options_defaults.fd
      hostname_label      = var.dns_forwarder_3 != null ? (var.dns_forwarder_3.name != null ? var.dns_forwarder_3.name : "${local.compute_options_defaults.name}-3") : "${local.compute_options_defaults.name}-3"
      kms_key_id          = var.dns_forwarder_3 != null ? (var.dns_forwarder_3.kms_key_id != null ? var.dns_forwarder_3.kms_key_id : local.compute_options_defaults.kms_key_id) : local.compute_options_defaults.kms_key_id
      bastion_ip           = null
    }
    } : var.num_dns_forwarders == 2 ? {
    "${var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"}" = {
      compartment_id              = var.compute_options != null ? (var.compute_options.compartment_id != null ? var.compute_options.compartment_id : null) : null
      shape                       = var.compute_options != null ? (var.compute_options.shape != null ? var.compute_options.shape : local.compute_options_defaults.shape) : local.compute_options_defaults.shape
      subnet_id                   = local.subnet_id
      is_monitoring_disabled      = null
      assign_public_ip            = var.compute_options != null ? (var.compute_options.public_ip != null ? var.compute_options.public_ip : local.compute_options_defaults.public_ip) : local.compute_options_defaults.public_ip
      vnic_defined_tags           = var.compute_options != null ? (var.compute_options.vnic_defined_tags != null ? var.compute_options.vnic_defined_tags : local.compute_options_defaults.vnic_defined_tags) : local.compute_options_defaults.vnic_defined_tags
      vnic_freeform_tags          = var.compute_options != null ? (var.compute_options.vnic_freeform_tags != null ? var.compute_options.vnic_freeform_tags : local.compute_options_defaults.vnic_freeform_tags) : local.compute_options_defaults.vnic_freeform_tags
      nsg_ids                     = local.compute_nsg_ids
      skip_src_dest_check         = false
      defined_tags                = var.compute_options != null ? (var.compute_options.defined_tags != null ? var.compute_options.defined_tags : local.compute_options_defaults.defined_tags) : local.compute_options_defaults.defined_tags
      freeform_tags               = var.compute_options != null ? (var.compute_options.freeform_tags != null ? var.compute_options.freeform_tags : local.compute_options_defaults.freeform_tags) : local.compute_options_defaults.freeform_tags
      extended_metadata           = null
      ipxe_script                 = null
      pv_encr_trans_enabled       = null
      ssh_authorized_keys         = var.compute_options != null ? (var.compute_options.ssh_auth_keys != null ? var.compute_options.ssh_auth_keys : local.compute_options_defaults.ssh_auth_keys) : local.compute_options_defaults.ssh_auth_keys
      ssh_private_keys            = []
      // See https://docs.cloud.oracle.com/iaas/images/ for image OCIDs and names
      image_name              = var.compute_options != null ? (var.compute_options.boot_vol_img_name != null ? var.compute_options.boot_vol_img_name : local.compute_options_defaults.boot_vol_img_name) : local.compute_options_defaults.boot_vol_img_name
      source_id               = var.compute_options != null ? (var.compute_options.boot_vol_img_id != null ? var.compute_options.boot_vol_img_id : local.compute_options_defaults.boot_vol_img_id) : local.compute_options_defaults.boot_vol_img_id
      source_type             = null
      mkp_image_name          = null
      mkp_image_name_version  = null
      boot_vol_size_gbs       = var.compute_options != null ? (var.compute_options.boot_vol_size != null ? var.compute_options.boot_vol_size : local.compute_options_defaults.boot_vol_size) : local.compute_options_defaults.boot_vol_size
      preserve_boot_volume    = null
      instance_timeout        = null
      sec_vnics               = {}
      block_volumes           = []
      mount_blk_vols          = false
      cons_conn_create        = false
      cons_conn_def_tags      = {}
      cons_conn_free_tags     = {}

      user_data = var.compute_options != null ? (var.compute_options.user_data != null ? var.compute_options.user_data : local.compute_options_defaults.user_data) : local.compute_options_defaults.user_data

      # instance-specific settings
      ad                  = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.ad != null ? var.dns_forwarder_1.ad : local.compute_options_defaults.ad) : local.compute_options_defaults.ad
      vnic_display_name   = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      private_ip          = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.private_ip != null ? var.dns_forwarder_1.private_ip : local.compute_options_defaults.private_ip) : local.compute_options_defaults.private_ip
      display_name        = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      fault_domain        = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.fd != null ? var.dns_forwarder_1.fd : local.compute_options_defaults.fd) : local.compute_options_defaults.fd
      hostname_label      = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      kms_key_id          = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.kms_key_id != null ? var.dns_forwarder_1.kms_key_id : local.compute_options_defaults.kms_key_id) : local.compute_options_defaults.kms_key_id
      bastion_ip           = null
    },
    "${var.dns_forwarder_2 != null ? (var.dns_forwarder_2.name != null ? var.dns_forwarder_2.name : "${local.compute_options_defaults.name}-2") : "${local.compute_options_defaults.name}-2"}" = {
      compartment_id              = var.compute_options != null ? (var.compute_options.compartment_id != null ? var.compute_options.compartment_id : null) : null
      shape                       = var.compute_options != null ? (var.compute_options.shape != null ? var.compute_options.shape : local.compute_options_defaults.shape) : local.compute_options_defaults.shape
      subnet_id                   = local.subnet_id
      is_monitoring_disabled      = null
      assign_public_ip            = var.compute_options != null ? (var.compute_options.public_ip != null ? var.compute_options.public_ip : local.compute_options_defaults.public_ip) : local.compute_options_defaults.public_ip
      vnic_defined_tags           = var.compute_options != null ? (var.compute_options.vnic_defined_tags != null ? var.compute_options.vnic_defined_tags : local.compute_options_defaults.vnic_defined_tags) : local.compute_options_defaults.vnic_defined_tags
      vnic_freeform_tags          = var.compute_options != null ? (var.compute_options.vnic_freeform_tags != null ? var.compute_options.vnic_freeform_tags : local.compute_options_defaults.vnic_freeform_tags) : local.compute_options_defaults.vnic_freeform_tags
      nsg_ids                     = local.compute_nsg_ids
      skip_src_dest_check         = false
      defined_tags                = var.compute_options != null ? (var.compute_options.defined_tags != null ? var.compute_options.defined_tags : local.compute_options_defaults.defined_tags) : local.compute_options_defaults.defined_tags
      freeform_tags               = var.compute_options != null ? (var.compute_options.freeform_tags != null ? var.compute_options.freeform_tags : local.compute_options_defaults.freeform_tags) : local.compute_options_defaults.freeform_tags
      extended_metadata           = null
      ipxe_script                 = null
      pv_encr_trans_enabled       = null
      ssh_authorized_keys         = var.compute_options != null ? (var.compute_options.ssh_auth_keys != null ? var.compute_options.ssh_auth_keys : local.compute_options_defaults.ssh_auth_keys) : local.compute_options_defaults.ssh_auth_keys
      ssh_private_keys            = []
      // See https://docs.cloud.oracle.com/iaas/images/ for image OCIDs and names
      image_name              = var.compute_options != null ? (var.compute_options.boot_vol_img_name != null ? var.compute_options.boot_vol_img_name : local.compute_options_defaults.boot_vol_img_name) : local.compute_options_defaults.boot_vol_img_name
      source_id               = var.compute_options != null ? (var.compute_options.boot_vol_img_id != null ? var.compute_options.boot_vol_img_id : local.compute_options_defaults.boot_vol_img_id) : local.compute_options_defaults.boot_vol_img_id
      source_type             = null
      mkp_image_name          = null
      mkp_image_name_version  = null
      boot_vol_size_gbs       = var.compute_options != null ? (var.compute_options.boot_vol_size != null ? var.compute_options.boot_vol_size : local.compute_options_defaults.boot_vol_size) : local.compute_options_defaults.boot_vol_size
      preserve_boot_volume    = null
      instance_timeout        = null
      sec_vnics               = {}
      block_volumes           = []
      mount_blk_vols          = false
      cons_conn_create        = false
      cons_conn_def_tags      = {}
      cons_conn_free_tags     = {}

      user_data               = var.compute_options != null ? (var.compute_options.user_data != null ? var.compute_options.user_data : local.compute_options_defaults.user_data) : local.compute_options_defaults.user_data

      # instance-specific settings
      ad                  = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.ad != null ? var.dns_forwarder_2.ad : local.compute_options_defaults.ad) : local.compute_options_defaults.ad
      vnic_display_name   = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.name != null ? var.dns_forwarder_2.name : "${local.compute_options_defaults.name}-2") : "${local.compute_options_defaults.name}-2"
      private_ip          = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.private_ip != null ? var.dns_forwarder_2.private_ip : local.compute_options_defaults.private_ip) : local.compute_options_defaults.private_ip
      display_name        = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.name != null ? var.dns_forwarder_2.name : "${local.compute_options_defaults.name}-2") : "${local.compute_options_defaults.name}-2"
      fault_domain        = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.fd != null ? var.dns_forwarder_2.fd : local.compute_options_defaults.fd) : local.compute_options_defaults.fd
      hostname_label      = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.name != null ? var.dns_forwarder_2.name : "${local.compute_options_defaults.name}-2") : "${local.compute_options_defaults.name}-2"
      kms_key_id          = var.dns_forwarder_2 != null ? (var.dns_forwarder_2.kms_key_id != null ? var.dns_forwarder_2.kms_key_id : local.compute_options_defaults.kms_key_id) : local.compute_options_defaults.kms_key_id
      bastion_ip           = null
    }
    } : {
    "${var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"}" = {
      compartment_id              = var.compute_options != null ? (var.compute_options.compartment_id != null ? var.compute_options.compartment_id : null) : null
      shape                       = var.compute_options != null ? (var.compute_options.shape != null ? var.compute_options.shape : local.compute_options_defaults.shape) : local.compute_options_defaults.shape
      subnet_id                   = local.subnet_id
      is_monitoring_disabled      = null
      assign_public_ip            = var.compute_options != null ? (var.compute_options.public_ip != null ? var.compute_options.public_ip : local.compute_options_defaults.public_ip) : local.compute_options_defaults.public_ip
      vnic_defined_tags           = var.compute_options != null ? (var.compute_options.vnic_defined_tags != null ? var.compute_options.vnic_defined_tags : local.compute_options_defaults.vnic_defined_tags) : local.compute_options_defaults.vnic_defined_tags
      vnic_freeform_tags          = var.compute_options != null ? (var.compute_options.vnic_freeform_tags != null ? var.compute_options.vnic_freeform_tags : local.compute_options_defaults.vnic_freeform_tags) : local.compute_options_defaults.vnic_freeform_tags
      nsg_ids                     = local.compute_nsg_ids
      skip_src_dest_check         = false
      defined_tags                = var.compute_options != null ? (var.compute_options.defined_tags != null ? var.compute_options.defined_tags : local.compute_options_defaults.defined_tags) : local.compute_options_defaults.defined_tags
      freeform_tags               = var.compute_options != null ? (var.compute_options.freeform_tags != null ? var.compute_options.freeform_tags : local.compute_options_defaults.freeform_tags) : local.compute_options_defaults.freeform_tags
      extended_metadata           = null
      ipxe_script                 = null
      pv_encr_trans_enabled       = null
      ssh_authorized_keys         = var.compute_options != null ? (var.compute_options.ssh_auth_keys != null ? var.compute_options.ssh_auth_keys : local.compute_options_defaults.ssh_auth_keys) : local.compute_options_defaults.ssh_auth_keys
      ssh_private_keys            = []
      // See https://docs.cloud.oracle.com/iaas/images/ for image OCIDs and names
      image_name              = var.compute_options != null ? (var.compute_options.boot_vol_img_name != null ? var.compute_options.boot_vol_img_name : local.compute_options_defaults.boot_vol_img_name) : local.compute_options_defaults.boot_vol_img_name
      source_id               = var.compute_options != null ? (var.compute_options.boot_vol_img_id != null ? var.compute_options.boot_vol_img_id : local.compute_options_defaults.boot_vol_img_id) : local.compute_options_defaults.boot_vol_img_id
      source_type             = null
      mkp_image_name          = null
      mkp_image_name_version  = null
      boot_vol_size_gbs       = var.compute_options != null ? (var.compute_options.boot_vol_size != null ? var.compute_options.boot_vol_size : local.compute_options_defaults.boot_vol_size) : local.compute_options_defaults.boot_vol_size
      preserve_boot_volume    = null
      instance_timeout        = null
      sec_vnics               = {}
      block_volumes           = []
      mount_blk_vols          = false
      cons_conn_create        = false
      cons_conn_def_tags      = {}
      cons_conn_free_tags     = {}

      user_data               = var.compute_options != null ? (var.compute_options.user_data != null ? var.compute_options.user_data : local.compute_options_defaults.user_data) : local.compute_options_defaults.user_data

      # instance-specific settings
      ad                  = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.ad != null ? var.dns_forwarder_1.ad : local.compute_options_defaults.ad) : local.compute_options_defaults.ad
      vnic_display_name   = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      private_ip          = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.private_ip != null ? var.dns_forwarder_1.private_ip : local.compute_options_defaults.private_ip) : local.compute_options_defaults.private_ip
      display_name        = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      fault_domain        = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.fd != null ? var.dns_forwarder_1.fd : local.compute_options_defaults.fd) : local.compute_options_defaults.fd
      hostname_label      = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.name != null ? var.dns_forwarder_1.name : "${local.compute_options_defaults.name}-1") : "${local.compute_options_defaults.name}-1"
      kms_key_id          = var.dns_forwarder_1 != null ? (var.dns_forwarder_1.kms_key_id != null ? var.dns_forwarder_1.kms_key_id : local.compute_options_defaults.kms_key_id) : local.compute_options_defaults.kms_key_id
      bastion_ip           = null
    }
  }
}

module "oci_instances" {
   source = "github.com/oracle-terraform-modules/terraform-oci-tdf-compute-instance.git?ref=v0.10.2"

  default_compartment_id = var.default_compartment_id

  instances = var.create_compute != true ? {} : local.instances
}
