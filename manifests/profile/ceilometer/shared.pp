class openstack_base::profile::ceilometer::shared (
  $verbose = false,
  $debug   = false,
) {

  include openstack_base

  class { '::ceilometer':
    rabbit_userid       => 'openstack',
    rabbit_password     => $openstack_base::rabbitmq_password,
    verbose             => $verbose,
    debug               => $debug,
    event_time_to_live	=> '1592000',
    metering_time_to_live => '1592000',
    rabbit_host         => $openstack_base::rabbitmq_ip,
    metering_secret => $openstack_base::ceilometer_metering_secret
  }

  class { '::ceilometer::agent::auth':
    auth_password => $openstack_base::admin_password,
    auth_url      => "http://${openstack_base::keystone_ip}:5000/v2.0",
  }

}
