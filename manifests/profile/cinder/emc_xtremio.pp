define openstack_base::profile::cinder::emc_xtremio (
#  $iscsi_ip_address,
  $san_ip,
#  $san_password,
#  $storage_vnx_pool_name,
#  $default_timeout            = '10',
#  $max_luns_per_storage_group = '256',
#  $package_ensure             = 'present',
#  $san_login                  = 'admin',
  $volume_backend_name        = $name,
  $extra_options              = {},
) {

  include ::cinder::params

  cinder_config {
    "${name}/san_ip":                     value => $san_ip;
    "${name}/volume_backend_name":        value => $volume_backend_name;
    "${name}/volume_driver":              value => 'cinder.volume.drivers.emc.xtremio.XtremIOIscsiDriver';
  }

  create_resources('cinder_config', $extra_options)

}
