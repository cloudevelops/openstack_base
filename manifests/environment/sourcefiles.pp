class openstack_base::environment::sourcefiles {

  file { '/root/keystonerc_admin':
    ensure  => present,
    content =>
      "export OS_AUTH_URL=http://${local_ip}:35357/v2.0
export OS_USERNAME=admin
export OS_PASSWORD=${admin_password}
export OS_TENANT_NAME=admin
export OS_VOLUME_API_VERSION=2
",
  }

}