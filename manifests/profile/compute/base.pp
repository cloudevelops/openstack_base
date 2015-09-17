class openstack_base::profile::compute::base {

  include openstack_base
  include openstack_base::profile::neutron::shared

  class { '::neutron::agents::ml2::ovs':
    local_ip         => $ipaddress_l3vxlan,
    enable_tunneling => true,
    tunnel_types     => ['vxlan'],
    bridge_mappings  => ['vlannet:br-vlan'],
  }

  class { 'nova::compute':
    enabled           => true,
    vnc_enabled       => true,
    vncproxy_host     => $openstack_base::nova_ip,
    vncproxy_protocol => 'http',
    vncproxy_port     => '6080',
  }

  class { 'nova::compute::libvirt':
    migration_support => true,
    # Narrow down listening if not needed for troubleshooting
    vncserver_listen  => '0.0.0.0',
    libvirt_virt_type => 'kvm',
  }

}
