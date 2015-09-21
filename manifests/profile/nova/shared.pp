class openstack_base::profile::nova::shared {

  class { 'nova':
    database_connection => "mysql://nova:${openstack_base::nova_mysql_password}@${openstack_base::mysql_ip}/nova?charset=utf8",
    rabbit_userid       => 'openstack',
    rabbit_password     => $openstack_base::rabbitmq_password,
    image_service       => 'nova.image.glance.GlanceImageService',
    glance_api_servers  => "${openstack_base::glance_ip}:9292",
    verbose             => true,
    rabbit_host         => $openstack_base::rabbitmq_ip,
  }

  class { 'nova::network::neutron':
    neutron_admin_password  => $openstack_base::admin_password,
    neutron_admin_auth_url => "http://${openstack_base::keystone_ip}:35357/v2.0",
    neutron_url => "http://${openstack_base::neutron_ip}:9696",
  }

}