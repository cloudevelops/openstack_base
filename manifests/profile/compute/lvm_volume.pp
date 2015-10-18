define openstack_base::profile::compute::lvm_volume (
  $ephemeral_storage = false,
  $volume_backend_name,
  $volume_group,
) {

  include openstack_base::profile::compute::base

  ensure_packages('thin-provisioning-tools')

  $volume_ip = $openstack_base::profile::compute::base::volume_ip

  cinder::backend::iscsi { $name:
    iscsi_ip_address => $volume_ip,
    volume_group     => $volume_group,
    extra_options    => {
      "${name}/lvm_type" => {
        value => 'thin'
      },
      "${name}/max_over_subscription_ratio" => {
        value => '1'
      }
    }
  }

  if $ephemeral_storage {
    nova_config {
      'libvirt/images_type':
        value => 'lvm';
      'libvirt/images_volume_group':
        value => $volume_group;
    }
  }
}
