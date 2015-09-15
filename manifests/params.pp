class openstack_base::params {

  $mysql_root_password = 'passw0rd'
  $mysql_ip = $ipaddress
  $keystone_enabled = true
  $keystone_ip = $ipaddress
  $keystone_mysql_password = $mysql_root_password
  $region = 'RegionOne'
  # generate admin_token with echo "`openssl rand -hex 4`-`openssl rand -hex 2`-`openssl rand -hex 2`-`openssl rand -hex 2`-`openssl rand -hex 6`"
  $admin_token = '5c703e80-c4b5-3916-e3c7-9b498d6f37a5'
  $admin_password = 'passw0rd'

}