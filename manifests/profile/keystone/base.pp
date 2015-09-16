class openstack_base::profile::keystone::base {

  include openstack_base

  class { 'keystone':
    verbose               => True,
    package_ensure        => latest,
    client_package_ensure => latest,
    catalog_type          => 'sql',
    admin_token           => $openstack_base::admin_token,
    database_connection   => "mysql://keystone:${openstack_base::keystone_mysql_password}@${openstack_base::mysql_ip}/keystone",
  }

  # Installs the service user endpoint.
  class { 'keystone::endpoint':
    public_url   => "http://${openstack_base::keystone_ip}:5000",
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
      public_url   => "http://${openstack_base::glance_ip}:9292",
      admin_url    => "http://${openstack_base::glance_ip}:9292",
      internal_url => "http://${openstack_base::glance_ip}:9292",
      region       => $openstack_base::region,
    }

    keystone_user_role { 'glance@services':
      ensure => present,
      roles  => ['admin'],
    }

  }

}
