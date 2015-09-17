class openstack_base::profile::cinder::base {

  include openstack_base
  include openstack_base::profile::cinder::shared

  class { 'cinder::api':
    enabled           => true,
    keystone_user     => 'cinder',
    keystone_password => $openstack_base::admin_password,
    auth_uri          => "http://${openstack_base::keystone_ip}:5000/v2.0",
    identity_uri      => "http://${openstack_base::keystone_ip}:35357",
    sync_db           => true,
    service_workers   => $api_workers,
    validate          => true, # Fails with a V2 API endpoint
  }

  class { 'cinder::scheduler':
    enabled          => true,
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
  }

  class {'cinder::client':
  }

}
