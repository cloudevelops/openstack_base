class openstack_base::profile::rabbitmq::base {

  include openstack_base

  class { '::rabbitmq_base':
    service_ensure    => 'running',
    port              => '5672',
    delete_guest_user => true,
  }

  rabbitmq_user { 'openstack':
    admin    => false,
    password => $openstack_base::rabbitmq_password,
    tags     => ['openstack'],
  }

  ensure_resource('rabbitmq_vhost','/',{
    ensure => present,
  })

  rabbitmq_user_permissions { 'openstack@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

}
