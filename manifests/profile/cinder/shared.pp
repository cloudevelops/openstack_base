class openstack_base::profile::cinder::shared (
  $verbose = false,
  $debug   = false,
  $storage_availability_zone = 'nova',
  $default_volume_type = undef,
) {

  class { 'cinder':
    database_connection       => "mysql://cinder:${openstack_base::cinder_mysql_password}@${openstack_base::mysql_ip}/cinder",
    rabbit_userid             => 'openstack',
    rabbit_password           => $openstack_base::rabbitmq_password,
    rabbit_host               => $openstack_base::rabbitmq_ip,
    verbose                   => $verbose,
    debug                     => $debug,
    storage_availability_zone => $storage_availability_zone,
  }

  cinder_config {
    'DEFAULT/glance_host':                   value => $openstack_base::glance_ip;
  }

  if $openstack_base::ceilometer_enabled {
    class {'cinder::ceilometer': }
  }

}