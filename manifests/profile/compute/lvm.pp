class openstack_base::profile::compute::lvm (
  $ephemeral_storage = true
) {

  class { 'cinder::volume::iscsi':
    iscsi_ip_address => $volume_ip,
    volume_driver    => 'cinder.volume.drivers.lvm.LVMVolumeDriver',
    volume_group     => 'vg0',
  }

  if $ephemeral_storage {
    nova_config {
      'libvirt/images_type':          value => 'lvm';
    }
  }

}
