class openstack_base::profile::network::base {

  include openstack_base

  sysctl::value {
    'net.ipv4.ip_forward':
      value => '1';
    'net.ipv4.conf.all.rp_filter':
      value => '0';
    'net.ipv4.conf.default.rp_filter':
      value => '0';
  }

  class { '::neutron':
    enabled               => true,
    bind_host             => '0.0.0.0',
    rabbit_host           => $openstack_base::rabbitmq_ip,
    rabbit_user           => 'openstack',
    rabbit_password       => $openstack_base::rabbitmq_password,
    verbose               => true,
    debug                 => false,
    core_plugin           => 'ml2',
    service_plugins       => ['router','firewall','lbaas','vpnaas','metering'],
    allow_overlapping_ips => true,
  }

  class { '::neutron::plugins::ml2':
    type_drivers         => ['vxlan', 'local', 'vlan', 'flat'],
    tenant_network_types => ['vxlan'],
    vxlan_group          => '239.1.1.1',
    mechanism_drivers    => ['openvswitch'],
    vni_ranges           => ['65537:69999'], #VXLAN
    tunnel_id_ranges     => ['65537:69999'], #GRE
    network_vlan_ranges  => ['vlannet:802:826'],
  }

  class { '::neutron::agents::l3':
    external_network_bridge      => '',
    gateway_external_network_id  => '',
    router_delete_namespaces     => true,
  }

  neutron_l3_agent_config {
    'DEFAULT/enable_isolated_metadata': value => true;
  }

  class { '::neutron::agents::metadata':
    enabled       => true,
    shared_secret => $openstack_base::metadata_proxy_shared_secret,
    auth_user     => 'neutron',
    auth_password => $openstack_base::admin_password,
    auth_tenant   => 'services',
    auth_url      => "http://${openstack_base::keystone_ip}:35357/v2.0",
    auth_region   => $openstack_base::region_name,
    metadata_ip   => $openstack_base::neutron_ip,
  }

  class { '::neutron::agents::dhcp':
    enabled                => true,
    dhcp_delete_namespaces => true,
  }

  class { '::neutron::agents::lbaas':
    enabled => true,
  }

  class { '::neutron::agents::vpnaas':
    enabled => true,
  }

  class { '::neutron::agents::metering':
    enabled => true,
  }

  class { '::neutron::agents::ml2::ovs':
    local_ip         => '172.27.8.5',
    enable_tunneling => true,
    tunnel_types     => ['vxlan'],
    bridge_mappings  => ['vlannet:br-vlan'],
  }
#->
#vs_port { 'eth0':
#  ensure => present,
#  bridge => 'br-ex',
#}

}
