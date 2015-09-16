class openstack_base::profile::nova::base {

  include openstack_base

  class { 'nova':
    database_connection => "mysql://nova:${openstack_base::nova_mysql_password}@${openstack_base::mysql_ip}/nova?charset=utf8",
    rabbit_userid       => 'openstack',
    rabbit_password     => $openstack_base::rabbitmq_password,
    image_service       => 'nova.image.glance.GlanceImageService',
    glance_api_servers  => "${openstack_base::glance_ip}:9292",
    verbose             => true,
    rabbit_host         => $openstack_base::rabbitmq_ip,
  }

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
