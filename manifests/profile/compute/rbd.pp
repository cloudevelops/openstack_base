class openstack_base::profile::compute::rbd (
  $rbd_user = 'compute',
  $rbd_pool = 'volumes',
  $rbd_keyring = 'client.compute',
  $rbd_secret_key,
  $rbd_secret_uuid,
) {

  include openstack_base
  include ceph_base

  class {'nova::compute::rbd':
    libvirt_rbd_user             => $rbd_user,
    libvirt_rbd_secret_uuid      => $rbd_secret_uuid,
    libvirt_rbd_secret_key       => $rbd_secret_key,
    libvirt_images_rbd_pool      => $rbd_pool,
    rbd_keyring                  => $rbd_keyring,
  }

}
