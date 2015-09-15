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

  keystone_tenant { 'demo':
    ensure => present,
  }

}
