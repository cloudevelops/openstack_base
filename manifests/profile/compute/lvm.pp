class openstack_base::profile::compute::lvm (
  $ephemeral_storage = true,
  $volume_backend_name = 'DEFAULT',
  $volume = {},
) {

  include openstack_base::profile::compute::base

  ensure_packages('thin-provisioning-tools')

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

  include repository_base::profile::apt::ubuntu_backports

  file {'/etc/init/tgt.conf':
    ensure => present,
    content => template('openstack_base/profile/compute/tgt.conf.erb'),
    notify => Service['tgt']
  }

  create_resources('openstack_base::profile::compute::lvm_volume',$volume)

}
