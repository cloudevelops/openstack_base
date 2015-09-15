class openstack_base::params {

  $mysql_root_password = 'changeme'
  $keystone_enabled = true
  $keystone_mysql_password = $mysql_root_password

}