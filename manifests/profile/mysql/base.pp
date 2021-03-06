class openstack_base::profile::mysql::base {

  include openstack_base

  class { '::mysql_base::server':
    package_name      => 'mariadb-server',
    root_password     => $openstack_base::mysql_root_password,
    restart           => true,
    override_options => {
      'mysqld' => {
        'skip-name-resolve' => true,
        'bind-address'  => '0.0.0.0',
        'max_connections' => '1024',
      }
    }
  }

  if $openstack_base::keystone_enabled {

    class { 'keystone::db::mysql':
      password      => $openstack_base::keystone_mysql_password,
      allowed_hosts => '%',
    }

  }

  if $openstack_base::glance_enabled {

    class { 'glance::db::mysql':
      password      => $openstack_base::glance_mysql_password,
      allowed_hosts => '%',
    }

  }

  if $openstack_base::nova_enabled {

    class { 'nova::db::mysql':
      password      => $openstack_base::nova_mysql_password,
      allowed_hosts => '%',
    }

  }

  if $openstack_base::neutron_enabled {

    class { 'neutron::db::mysql':
      password      => $openstack_base::nova_mysql_password,
      allowed_hosts => '%',
    }

  }

  if $openstack_base::cinder_enabled {

    class { 'cinder::db::mysql':
      password      => $openstack_base::cinder_mysql_password,
      allowed_hosts => '%',
    }

  }

  if $openstack_base::heat_enabled {

    class { 'heat::db::mysql':
      password      => $openstack_base::heat_mysql_password,
      allowed_hosts => '%',
    }

  }



}
