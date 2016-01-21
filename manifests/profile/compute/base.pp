# add host to independent AZ
# nova aggregate-create AG1 AZ1
# nova aggregate-add-host AG1 host1
class openstack_base::profile::compute::base (
  $mgmt_ip,
  $vxlan_ip,
  $volume_ip,
  $disable_apparmor = true,
  $default_availability_zone = 'nova',
  $cinder_backends = false,
  $ovs_template = 'openstack_base/profile/neutron/ovs.erb',
  $facter_patch = true,
) {

  include openstack_base
  include openstack_base::profile::neutron::shared
  include openstack_base::profile::neutron::sysctl
  include openstack_base::profile::nova::shared
  include openstack_base::profile::cinder::shared

  file {'/etc/network/ovs':
    content => template($ovs_template),
    mode => 555,
  }

  class { '::neutron::agents::ml2::ovs':
    local_ip         => $vxlan_ip,
    enable_tunneling => true,
    tunnel_types     => ['vxlan'],
    bridge_mappings  => ['vlannet:br-vlan'],
  }

  if $openstack_base::ceilometer_enabled {
    $instance_usage_audit        = true
    $instance_usage_audit_period = 'hour'
  } else {
    $instance_usage_audit        = false
    $instance_usage_audit_period = undef
  }

  class { 'nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncproxy_host                 => $openstack_base::nova_ip,
    vncproxy_protocol             => 'http',
    vncproxy_port                 => '6080',
    vncserver_proxyclient_address => $ipaddress_mgmt,
    default_availability_zone     => $default_availability_zone,
    instance_usage_audit          => $instance_usage_audit,
    instance_usage_audit_period   => $instance_usage_audit_period,
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

  if $cinder_backends {
    class {'cinder::backends':
      enabled_backends => $cinder_backends
    }

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

  if $openstack_base::ceilometer_enabled {

    include openstack_base::profile::ceilometer::shared

    class { '::ceilometer::agent::polling':
      central_namespace => false,
      compute_namespace => true,
      ipmi_namespace    => false,
    }

  }

  if $facter_patch {
    file {
      '/usr/lib/ruby/vendor_ruby/facter/util/ip.rb':
        ensure => present,
        source => 'puppet:///modules/openstack_base/profile/compute/ip.rb',
        notify => Service['puppet'];
    }
  }

}
