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

  class { '::neutron::agents::l3':
    external_network_bridge  => 'br-ex',
    router_delete_namespaces => true,
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
    tunnel_types     => ['gre', 'vxlan'],
    bridge_mappings  => ['physnet1:br-ex'],
  }
#->
#vs_port { 'eth0':
#  ensure => present,
#  bridge => 'br-ex',
#}

}
