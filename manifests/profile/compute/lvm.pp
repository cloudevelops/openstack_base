class openstack_base::profile::compute::lvm (
  $ephemeral_storage = true,
  $volume_backend_name = 'DEFAULT',
) {

  include openstack_base::profile::compute::base

  package { 'thin-provisioning-tools':
    ensure => present
  }

  $volume_ip = $openstack_base::profile::compute::base::volume_ip

  cinder::backend::iscsi { $volume_backend_name:
    iscsi_ip_address => $volume_ip,
    volume_group     => 'vg0',
    extra_options    => {
      "${volume_backend_name}/lvm_type" => {
        value => 'thin'
      },
      "${volume_backend_name}/max_over_subscription_ratio" => {
        value => '1'
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

}
