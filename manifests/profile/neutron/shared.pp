class openstack_base::profile::neutron::shared {

  class { '::neutron':
    enabled               => true,
    bind_host             => '0.0.0.0',
    rabbit_host           => $openstack_base::rabbitmq_ip,
    rabbit_user           => 'openstack',
    rabbit_password       => $openstack_base::rabbitmq_password,
    verbose               => true,
    debug                 => false,
    core_plugin           => 'ml2',
    service_plugins       => ['router','firewall','lbaas','metering'],
    allow_overlapping_ips => true,
  }

  class { '::neutron::plugins::ml2':
    type_drivers         => ['vxlan', 'local', 'vlan', 'flat'],
    tenant_network_types => ['vxlan'],
    vxlan_group          => '239.1.1.1',
    mechanism_drivers    => ['openvswitch'],
    vni_ranges           => ['65537:69999'], #VXLAN
    tunnel_id_ranges     => ['65537:69999'], #GRE
    network_vlan_ranges  => ["vlannet:${openstack_base::neutron_network_vlan_ranges}"],
  }

}
