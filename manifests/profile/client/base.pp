class openstack_base::profile::client::base (
  $username,
  $password,
  $auth_url = "http://${openstack_base::public_api_ip}:5000/v2.0",
  $tenant_name = 'admin',
  $api_version = 2,
) {

  include openstack_base

  shellvar { "bashrc_keystone":
    ensure   => present,
    target   => "/home/${username}/.bashrc",
    variable => 'source ~/keystonerc_admin',
  }

  file {"/home/${username}/keystonerc_admin":
    ensure => present,
    mode => 500,
    content => template('openstack_base/profile/client/keystonerc_admin.erb')
  }

  ensure_packages([
    'python-novaclient',
    'python-cinderclient',
    'python-heatclient',
    'python-keystoneclient',
    'python-neutronclient'
  ])

}
