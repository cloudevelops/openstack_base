class openstack_base::profile::horizon::base {

  include openstack_base

  class { '::horizon':
    cache_server_ip       => $openstack_base::memcache_ip,
    cache_server_port     => '11211',
    secret_key            => $openstack_base::horizon_secret,
    keystone_url          => "http://${openstack_base::keystone_ip}:5000/v2.0",
    swift                 => false,
    django_debug          => 'True',
    api_result_limit      => '2000',
    neutron_options       => {
      enable_lb => true,
      enable_firewall => true
    }
  }

}
