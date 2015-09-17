class openstack_base::profile::nova::base {

  include openstack_base
  include openstack_base::profile::nova::shared

  class { 'nova::api':
    enabled                              => true,
    auth_uri                             => "http://${openstack_base::keystone_ip}:5000/v2.0",
    identity_uri                         => "http://${openstack_base::keystone_ip}:35357",
    admin_user                           => 'nova',
    admin_password                       => $openstack_base::admin_password,
    admin_tenant_name                    => 'services',
    neutron_metadata_proxy_shared_secret => $openstack_base::metadata_proxy_shared_secret,
    #ratelimits                          =>
    #'(POST, "*", .*, 10, MINUTE);\
    #(POST, "*/servers", ^/servers, 50, DAY);\
    #(PUT, "*", .*, 10, MINUTE)',
    validate                             => true,
  }

  class { 'nova::network::neutron':
    neutron_admin_password  => $openstack_base::admin_password,
    neutron_admin_auth_url => "http://${openstack_base::keystone_ip}:35357/v2.0",
    neutron_url => "http://${openstack_base::neutron_ip}:9696",
  }

  class { 'nova::scheduler':
    enabled => true,
  }

  class { 'nova::conductor':
    enabled => true,
  }

  class { 'nova::consoleauth':
    enabled => true,
  }

  class { 'nova::cert':
    enabled => true,
  }

  class { 'nova::objectstore':
    enabled => true,
  }

  class { 'nova::vncproxy':
    enabled           => true,
    host              => '0.0.0.0',
    port              => '6080',
    vncproxy_protocol => 'http',
  }

  class {'nova::client': }

}
