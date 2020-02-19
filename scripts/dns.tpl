# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# cloud-config
write_files:
  # create dnsmasq config
  - path: /etc/dnsmasq.conf
    content: |
%{ for i in dns_mappings ~}
      server=/${i["namespace"]}/${i["server"]}
%{ endfor ~}
%{ for i in rev_dns_mappings ~}
      rev-server=${ i["cidr"] },${ i["server"] }
%{ endfor ~}
      rev-server=${vcn_cidr},169.254.169.254
      cache-size=0

runcmd:
  # Run firewall commands to open DNS (udp/53)
  - firewall-offline-cmd --zone=public --add-port=53/udp
  # install dnsmasq package
  - yum install dnsmasq -y
  # enable dnsmasq process
  - systemctl enable dnsmasq
  # restart dnsmasq process
  - systemctl restart dnsmasq
  # restart firewalld
  - systemctl restart firewalld
