class openstack_base::profile::client::base (
  $username,
  $password,
  $auth_url = undef,
  $tenant_name = 'admin',
  $api_version = 2,
) {

  include openstack_base

  if empty($auth_url) {
    $auth_url_link = "http://${openstack_base::public_api_ip}:5000/v2.0"
  } else {
    $auth_url_link = $auth_url
  }

  file { "/home/${username}/.bashrc":
    ensure => present,
    source => 'puppet:///modules/openstack_base/profile/client/bashrc',
    owner  => $username,
    mode   => 544
  }

  file { "/home/${username}/.profile":
    ensure => present,
    source => 'puppet:///modules/openstack_base/profile/client/profile',
    owner  => $username,
    mode   => 544
  }

  file {"/home/${username}/keystonerc_admin":
    ensure  => present,
    owner   => $username,
    mode    => 500,
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
