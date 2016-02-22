class openstack_base::profile::ceilometer::base {

  include openstack_base
  include mongodb_base::server
  include openstack_base::profile::ceilometer::shared

  class { '::ceilometer::db':
    database_connection => 'mongodb://localhost:27017/ceilometer',
    require             => Class['mongodb_base::server'],
  }

  class { '::ceilometer::api':
    keystone_password     => $openstack_base::admin_password,
    keystone_auth_uri     => "http://${openstack_base::keystone_ip}:5000/v2.0",
    keystone_identity_uri => "http://${openstack_base::keystone_ip}:35357",
  }

  class { '::ceilometer::agent::polling':
    central_namespace => true,
    compute_namespace => false,
    ipmi_namespace    => false,
  }

  class { '::ceilometer::alarm::notifier': }

  class { '::ceilometer::alarm::evaluator': }

  class { '::ceilometer::expirer':
    time_to_live => '1592000',
    enable_cron	=> true
  }

  class { '::ceilometer::agent::notification': }

  class { '::ceilometer::collector': }

}
