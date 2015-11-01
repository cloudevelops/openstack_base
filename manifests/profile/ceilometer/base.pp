class openstack_base::profile::ceilometer::base {

  include openstack_base
  include mongodb_base::server

  class { '::ceilometer::db':
    database_connection => 'mongodb://localhost:27017/ceilometer',
    require             => Class['mongodb_base::server'],
  }

  class { '::ceilometer':
    metering_secret => $openstack_base::ceilometer_metering_secret
  }

  class { '::ceilometer::api':
    keystone_password => $openstack_base::admin_password
  }

  class { '::ceilometer::agent::auth':
    auth_password => $openstack_base::admin_password,
    auth_url      => "http://${openstack_base::keystone_ip}:5000/v2.0",
  }

  class { '::ceilometer::agent::polling':
    central_namespace => true,
    compute_namespace => true,
    ipmi_namespace    => false,
  }

  class { '::ceilometer::alarm::notifier': }

  class { '::ceilometer::alarm::evaluator': }

  class { '::ceilometer::expirer':
    time_to_live => '2592000'
  }

  class { '::ceilometer::agent::notification': }

}
