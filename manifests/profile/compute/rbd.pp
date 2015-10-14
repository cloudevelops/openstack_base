class openstack_base::profile::compute::rbd (
  $rbd_user = 'compute',
  $rbd_pool = 'volumes',
  $rbd_keyring = 'client.compute',
  $rbd_secret_key,
  $rbd_secret_uuid,
  $volume_backend_name = 'DEFAULT',
  $rbd_host = undef,
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

  cinder::backend::rbd { $volume_backend_name:
    rbd_pool                         => $rbd_pool,
    rbd_user                         => $rbd_user,
    rbd_secret_uuid                  => $rbd_secret_uuid,
    extra_options                    => $extra_options,
    host                             => $rbd_host,
  }

}
