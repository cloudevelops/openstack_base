class openstack_base::environment::sourcefiles (
  $deploy = true
) {

  if $deploy {
    file { '/root/keystonerc_admin':
      ensure  => present,
      content =>
        "export OS_AUTH_URL=http://${openstack_base::keystone_ip}:35357/v2.0
export OS_USERNAME=admin
export OS_PASSWORD=${openstack_base::admin_password}
export OS_TENANT_NAME=admin
export OS_VOLUME_API_VERSION=2
",
      mode => 400,
    }

    file_line { 'keystonerc':
      path => '/root/.bashrc',
      line => 'source ~/keystonerc_admin',
    }

  }

}
