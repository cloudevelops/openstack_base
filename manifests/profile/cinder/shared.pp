class openstack_base::profile::cinder::shared (
  $verbose = false,
  $debug   = false,
) {

  class { 'cinder':
    database_connection => "mysql://cinder:${openstack_base::cinder_mysql_password}@${openstack_base::mysql_ip}/cinder",
    rabbit_userid       => 'openstack',
    rabbit_password     => $openstack_base::rabbitmq_password,
    rabbit_host         => $openstack_base::rabbitmq_ip,
    verbose             => $verbose,
    debug               => $debug,
  }

  cinder_config {
    'DEFAULT/glance_host':                   value => $openstack_base::glance_ip;
  }

}