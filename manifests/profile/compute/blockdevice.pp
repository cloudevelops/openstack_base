class openstack_base::profile::compute::blockdevice (
  $volume_backend_name = 'blk',
  $available_devices,
  $extra_options = {},
) {

  include openstack_base::profile::compute::base

  cinder::backend::blockdevice { $volume_backend_name:
    available_devices => $available_devices,
    extra_options    => $extra_options,
  }

}
