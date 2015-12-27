class openstack_base::profile::network::base (
  $mgmt_ip,
  $vxlan_ip,
  $ovs_template = 'openstack_base/profile/neutron/ovs.erb',
) {

  include openstack_base
  include openstack_base::profile::neutron::shared

  file {'/etc/network/ovs':
    content => template($ovs_template),
    mode => 555,
  }

  sysctl::value {
    'net.ipv4.ip_forward':
      value => '0';
    'net.ipv4.conf.all.rp_filter':
      value => '0';
    'net.ipv4.conf.default.rp_filter':
      value => '0';
  }

  class { '::neutron::agents::l3':
    external_network_bridge      => '',
    gateway_external_network_id  => '',
    router_delete_namespaces     => true,
  }

  neutron_l3_agent_config {
    'DEFAULT/enable_isolated_metadata': value => true;
  }

  file {'/etc/neutron/fwaas_driver.ini':
    ensure => present,
    source => 'puppet:///modules/openstack_base/profile/neutron/fwaas_driver.ini',
  }

  class { '::neutron::agents::metadata':
    enabled       => true,
    shared_secret => $openstack_base::metadata_proxy_shared_secret,
    auth_user     => 'neutron',
    auth_password => $openstack_base::admin_password,
    auth_tenant   => 'services',
    auth_url      => "http://${openstack_base::keystone_ip}:35357/v2.0",
    auth_region   => $openstack_base::region_name,
    metadata_ip   => $openstack_base::nova_ip,
  }

  class { '::neutron::agents::dhcp':
    enabled                => true,
    dhcp_delete_namespaces => true,
  }

  class { '::neutron::agents::lbaas':
    enabled => true,
  }

  class { '::neutron::agents::metering':
    enabled => true,
  }

  class { '::neutron::agents::ml2::ovs':
    local_ip         => $vxlan_ip,
    enable_tunneling => true,
    tunnel_types     => ['vxlan'],
    bridge_mappings  => ['vlannet:br-vlan'],
  }

}
