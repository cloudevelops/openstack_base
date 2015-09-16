class openstack_base::params {

  $mysql_root_password = 'passw0rd'
  $mysql_ip = $ipaddress
  $keystone_enabled = true
  $keystone_ip = $ipaddress
  # this is obviously buggy implementation, need globals propably
  $keystone_mysql_password = $mysql_root_password
  $region = 'RegionOne'
  # generate admin_token with echo "`openssl rand -hex 4`-`openssl rand -hex 2`-`openssl rand -hex 2`-`openssl rand -hex 2`-`openssl rand -hex 6`"
  $admin_token = '5c703e80-c4b5-3916-e3c7-9b498d6f37a5'
  $admin_password = 'passw0rd'
  $glance_enabled = true
  $glance_ip = $ipaddress
  $glance_mysql_password = $mysql_root_password
  $rabbitmq_password = 'passw0rd'
  $rabbitmq_ip = $ipaddress
  $nova_enabled = true
  $nova_ip = $ipaddress
  $nova_mysql_password = $mysql_root_password
}