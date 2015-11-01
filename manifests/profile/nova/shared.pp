class openstack_base::profile::nova::shared (
  $verbose = false,
  $debug   = false,
){

  if $openstack_base::ceilometer_enabled {
    $notification_driver = 'messagingv2'
    $notify_on_state_change = 'vm_and_task_state'
  } else {
    $notification_driver = undef
    $notify_on_state_change = undef
  }

  class { 'nova':
    database_connection    => "mysql://nova:${openstack_base::nova_mysql_password}@${openstack_base::mysql_ip}/nova?charset=utf8",
    rabbit_userid          => 'openstack',
    rabbit_password        => $openstack_base::rabbitmq_password,
    image_service          => 'nova.image.glance.GlanceImageService',
    glance_api_servers     => "${openstack_base::glance_ip}:9292",
    verbose                => $verbose,
    debug                  => $debug,
    rabbit_host            => $openstack_base::rabbitmq_ip,
    notification_driver    => $notification_driver,
    notify_on_state_change => $notify_on_state_change,
  }

  class { 'nova::network::neutron':
    neutron_admin_password  => $openstack_base::admin_password,
    neutron_admin_auth_url => "http://${openstack_base::keystone_ip}:35357/v2.0",
    neutron_url => "http://${openstack_base::neutron_ip}:9696",
  }

}