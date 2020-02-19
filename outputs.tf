# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "subnet" {
  value       = oci_core_subnet.this != null && length(oci_core_subnet.this) > 0 ? oci_core_subnet.this[0] : null
  description = "The subnet that was created."
}

output "nsg" {
  value       = length(module.network_security_policies.nsgs) > 0 ? values(module.network_security_policies.nsgs)[0] : null
  description = "The NSG that was created."
}

output "nsg_rules" {
  value       = module.network_security_policies.nsg_rules
  description = "The NSG Rules that have been created."
}

output "instances" {
  value       = module.oci_instances != null ? (module.oci_instances.instance != null ? (length(module.oci_instances.instance) > 0 ? module.oci_instances.instance : null) : null) : null
  description = "The compute instance that has been created."
}

output "cloud_init_data" {
  value = templatefile("${path.module}/scripts/dns.tpl", {
    dns_mappings     = var.dns_namespace_mappings != null ? var.dns_namespace_mappings : []
    rev_dns_mappings = var.reverse_dns_mappings != null ? var.reverse_dns_mappings : []
    vcn_cidr         = local.vcn_cidr
  })
  description = "The data that is passed to cloud-init on your behalf."
}
