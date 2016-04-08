class openstack_base::profile::compute::emc_xtremio (
  $volume_backend_name = 'xtremio',
  $san_ip,
  $extra_options = {},
) {

  openstack_base::profile::cinder::emc_xtremio { $volume_backend_name:
    san_ip => $san_ip,
    extra_options    => $extra_options,
  }

}
