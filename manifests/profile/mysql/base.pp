class openstack_base::profile::mysql::base {

  include openstack_base

  class { '::mysql_base::server':
    package_name      => 'mariadb-server',
    root_password     => $openstack_base::mysql_root_password,
    restart           => true,
    override_options => {
      'mysqld' => {
        'skip-name-resolve' => true,
        'bind-address'  => '0.0.0.0'
      }
    }
  }


}
