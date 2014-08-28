class openstack_base::profile::cloudgw::sysctl {

  ::sysctl::value { 'net.ipv4.ip_forward': value => '1'}
#  ::sysctl::value { 'net.ipv6.conf.all.disable_ipv6': value => '1'}
#  ::sysctl::value { 'net.ipv6.conf.default.disable_ipv6': value => '1'}
#  ::sysctl::value { 'net.ipv6.conf.lo.disable_ipv6': value => '1'}

}