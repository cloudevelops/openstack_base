class openstack_base::profile::neutron::sysctl {

  sysctl::value {
    'net.bridge.bridge-nf-call-arptables':
      value => '1';
    'net.bridge.bridge-nf-call-iptables':
      value => '1';
    'net.bridge.bridge-nf-call-ip6tables':
      value => '1';
    'net.bridge.bridge-nf-filter-vlan-tagged':
      value => '0';
    'net.bridge.bridge-nf-filter-pppoe-tagged':
      value => '0';
  }

}
