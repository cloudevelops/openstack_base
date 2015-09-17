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

}