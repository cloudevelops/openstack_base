class openstack_base::profile::heat::base {

  include openstack_base

  class { '::heat':
    rabbit_userid       => 'openstack',
    rabbit_password     => $openstack_base::rabbitmq_password,
    rabbit_host         => $openstack_base::rabbitmq_ip,
    identity_uri        => "http://${openstack_base::keystone_ip}:35357",
    keystone_ec2_uri    => "http://${openstack_base::keystone_ip}:5000/v2.0/ec2tokens",
    keystone_password   => $openstack_base::admin_password,
    database_connection => "mysql://heat:${openstack_base::heat_mysql_password}@${openstack_base::mysql_ip}/heat?charset=utf8",
  }

  class { '::heat::engine':
    auth_encryption_key => $openstack_base::heat_auth_encryption_key,
    configure_delegated_roles => false,
  }

  class { '::heat::api': }

}
