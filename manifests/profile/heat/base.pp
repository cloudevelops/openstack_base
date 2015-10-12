class openstack_base::profile::heat::base {

  include openstack_base

  class { '::heat':
    keystone_password => $openstack_base::admin_password,
    database_connection => "mysql://heat:${openstack_base::heat_mysql_password}@${openstack_base::mysql_ip}/heat?charset=utf8",
  }

  class { '::heat::engine':
    auth_encryption_key => $openstack_base::heat_auth_encryption_key,
  }

  class { '::heat::api': }

}
