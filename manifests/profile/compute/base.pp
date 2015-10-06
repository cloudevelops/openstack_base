class openstack_base::profile::compute::base (
  $mgmt_ip,
  $vxlan_ip,
  $volume_ip,
  $disable_apparmor = true,
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

  # bugfix that nova-compute talks to cinder via public rul
  nova_config {
    'DEFAULT/cinder_catalog_info': value => 'volumev2:cinderv2:internalURL';
  }

  class { 'cinder::volume':
    enabled => true,
  }

  if $disable_apparmor {

    file {'/etc/apparmor.d/disable/usr.sbin.libvirtd':
      ensure => link,
      target => '/etc/apparmor.d/usr.sbin.libvirtd',
      notify => Exec['apparmor_parser_libvirtd']
    }

    file {'/etc/apparmor.d/disable/usr.lib.libvirt.virt-aa-helper':
      ensure => link,
      target => '/etc/apparmor.d/usr.lib.libvirt.virt-aa-helper',
      notify => Exec['apparmor_parser_libvirtd_aa_helper']
    }

    exec {'apparmor_parser_libvirtd':
      refreshonly => true,
      command => '/sbin/apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd',
      notify => Service['apparmor']
    }

    exec {'apparmor_parser_libvirtd_aa_helper':
      refreshonly => true,
      command => '/sbin/apparmor_parser -R /etc/apparmor.d/usr.lib.libvirt.virt-aa-helper',
      notify => Service['apparmor']
    }

    service {'apparmor': }

  }

  sysctl::value {
    'vm.swappiness':
      value => '0';
  }

}
