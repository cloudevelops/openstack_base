class openstack_base::profile::compute::base (
  $mgmt_ip,
  $vxlan_ip,
  $volume_ip,
) {

  include openstack_base
  include openstack_base::profile::neutron::shared
  include openstack_base::profile::nova::shared
  include openstack_base::profile::cinder::shared

  file {'/etc/network/ovs':
    content => template('openstack_base/profile/neutron/ovs.erb'),
    mode => 555,
  }

  class { '::neutron::agents::ml2::ovs':
    local_ip         => $vxlan_ip,
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
    vncserver_proxyclient_address => $ipaddress_mgmt,
  }

  class { 'nova::compute::libvirt':
    migration_support => true,
    # Narrow down listening if not needed for troubleshooting
    vncserver_listen  => '0.0.0.0',
    libvirt_virt_type => 'kvm',
  }

  class { 'cinder::volume':
    enabled => true,
  }

  class { 'cinder::volume::iscsi':
    iscsi_ip_address => $volume_ip,
    volume_driver    => 'cinder.volume.drivers.lvm.LVMVolumeDriver',
    volume_group     => 'vg0',
  }

}
