class openstack_base::profile::keystone::base {

  include openstack_base

  class { 'keystone':
    verbose               => True,
    package_ensure        => latest,
    client_package_ensure => latest,
    catalog_type          => 'sql',
    admin_token           => $openstack_base::admin_token,
    database_connection   => "mysql://keystone:${openstack_base::keystone_mysql_password}@${openstack_base::mysql_ip}/keystone",
    token_expiration      => $openstack_base::keystone_token_expiration,
  }

  # Installs the service user endpoint.
  class { 'keystone::endpoint':
    public_url   => "http://${openstack_base::public_api_ip}:5000",
    admin_url    => "http://${openstack_base::keystone_ip}:35357",
    internal_url => "http://${openstack_base::keystone_ip}:5000",
    region       => $openstack_base::region,
  }

  keystone_tenant { 'admin':
    ensure  => present,
    enabled => True,
  }

  keystone_tenant { 'services':
    ensure  => present,
    enabled => True,
  }

  keystone_user { 'admin':
    ensure   => present,
    enabled  => True,
    password => $openstack_base::admin_password,
    email    => 'admin@openstack',
  }

  keystone_role { 'admin':
    ensure => present,
  }

  keystone_user_role { 'admin@admin':
    ensure => present,
    roles  => ['admin'],
  }

  keystone_user_role { 'admin@services':
    ensure => present,
    roles  => ['admin'],
  }

  if $openstack_base::glance_enabled {

    class { 'glance::keystone::auth':
      password     => $openstack_base::admin_password,
      email        => 'glance@openstack',
      public_url   => "http://${openstack_base::public_api_ip}:9292",
      admin_url    => "http://${openstack_base::glance_ip}:9292",
      internal_url => "http://${openstack_base::glance_ip}:9292",
      region       => $openstack_base::region,
    }

    keystone_user_role { 'glance@services':
      ensure => present,
      roles  => ['admin'],
    }

  }

  if $openstack_base::nova_enabled {

    class { 'nova::keystone::auth':
      password         => $openstack_base::admin_password,
      email            => 'glance@openstack',
      public_url       => "http://${openstack_base::public_api_ip}:8774/v2/%(tenant_id)s",
      internal_url     => "http://${openstack_base::nova_ip}:8774/v2/%(tenant_id)s",
      admin_url        => "http://${openstack_base::nova_ip}:8774/v2/%(tenant_id)s",
      public_url_v3    => "http://${openstack_base::public_api_ip}:8774/v3",
      internal_url_v3  => "http://${openstack_base::nova_ip}:8774/v3",
      admin_url_v3     => "http://${openstack_base::nova_ip}:8774/v3",
      ec2_public_url   => "http://${openstack_base::public_api_ip}:8773/services/Cloud",
      ec2_internal_url => "http://${openstack_base::nova_ip}:8773/services/Cloud",
      ec2_admin_url    => "http://${openstack_base::nova_ip}:8773/services/Admin",
      region           => $openstack_base::region,
    }

  }

  if $openstack_base::neutron_enabled {

    class { 'neutron::keystone::auth':
      password            => $openstack_base::admin_password,
      email               => 'neutron@openstack',
      region              => $openstack_base::region,
      public_url          => "http://${openstack_base::public_api_ip}:9696",
      admin_url           => "http://${openstack_base::neutron_ip}:9696",
      internal_url        => "http://${openstack_base::neutron_ip}:9696",
    }

  }

  if $openstack_base::cinder_enabled {

    class { 'cinder::keystone::auth':
      password            => $openstack_base::admin_password,
      email               => 'cinder@openstack',
      region              => $openstack_base::region,
      public_url          => "http://${openstack_base::public_api_ip}:8776/v1/%(tenant_id)s",
      internal_url        => "http://${openstack_base::cinder_ip}:8776/v1/%(tenant_id)s",
      admin_url           => "http://${openstack_base::cinder_ip}:8776/v1/%(tenant_id)s",
      public_url_v2       => "http://${openstack_base::public_api_ip}:8776/v2/%(tenant_id)s",
      internal_url_v2     => "http://${openstack_base::cinder_ip}:8776/v2/%(tenant_id)s",
      admin_url_v2        => "http://${openstack_base::cinder_ip}:8776/v2/%(tenant_id)s",
    }

  }

  if $openstack_base::heat_enabled {

    class { 'heat::keystone::auth':
      password            => $openstack_base::admin_password,
      email               => 'heat@openstack',
      region              => $openstack_base::region,
      public_url          => "http://${openstack_base::public_api_ip}:8004/v1/%(tenant_id)s",
      admin_url           => "http://${openstack_base::heat_ip}:8004/v1/%(tenant_id)s",
      internal_url        => "http://${openstack_base::heat_ip}:8004/v1/%(tenant_id)s"
    }

    keystone_role { 'heat_stack_owner':
      ensure => present,
    }

  }

  if $openstack_base::ceilometer_enabled {

    class { 'ceilometer::keystone::auth':
      password            => $openstack_base::admin_password,
      email               => 'ceilometer@openstack',
      region              => $openstack_base::region,
      public_url          => "http://${openstack_base::public_api_ip}:8777",
      admin_url           => "http://${openstack_base::ceilometer_ip}:8777",
      internal_url        => "http://${openstack_base::ceilometer_ip}:8777",
    }

  }

}
