class openstack_base::profile::compute::lvm (
  $ephemeral_storage = true,
  $cinder_availability_zone_enabled = true,
  $cinder_availability_zone = $hostname,
) {

  include openstack_base::profile::compute::base

  package { 'thin-provisioning-tools':
    ensure => present
  }

  $volume_ip = $openstack_base::profile::compute::base::volume_ip

  class { 'cinder::volume::iscsi':
    iscsi_ip_address => $volume_ip,
    volume_driver    => 'cinder.volume.drivers.lvm.LVMVolumeDriver',
    volume_group     => 'vg0',
    extra_options    => {
      'DEFAULT/lvm_type' => {
        value => 'thin'
      }
    }
  }

  if $ephemeral_storage {
    nova_config {
      'libvirt/images_type':
        value => 'lvm';
      'libvirt/images_volume_group':
        value => 'vg0';
    }
  }

  file {'/etc/init/tgt.conf':
    ensure => present,
    content => template('openstack_base/profile/compute/tgt.conf.erb'),
    notify => Service['tgt']
  }

#  if $cinder_availability_zone {
#    cinder_config {
#      'DEFAULT/storage_availability_zone':
#        value => $cinder_availability_zone;
#    }
#  }
}
