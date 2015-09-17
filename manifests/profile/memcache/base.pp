class openstack_base::profile::memcache::base {

  include openstack_base

  class {'memcached_base':
    listen_ip => '0.0.0.0',
    tcp_port  => '11211',
    udp_port  => '11211',
  }

}
