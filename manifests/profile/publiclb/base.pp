class openstack_base::profile::publiclb::base {

  include openstack_base

  include nginx_base

  nginx::resource::vhost { 'openstack':
    ssl => true,
    ssl_cert => "/var/lib/puppet/ssl/certs/${fqdn}.pem",
    ssl_key => "/var/lib/puppet/ssl/private_keys/${fqdn}.pem",
    server_name => [$openstack_base::horizon_fqdn],
    vhost_cfg_append => $vhost_cfg_append,
    proxy => "http://${openstack_base::horizon_ip}",
    proxy_read_timeout => 1000,
  }

  nginx::resource::vhost { 'openstack-httpsredirect':
    server_name => [$openstack_base::horizon_fqdn],
    location_custom_cfg => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
  }

  sysctl::value {
    'net.ipv4.ip_forward':
      value => '1';
  }

  firewall {
    '101_dnat_for_keystone':
      ensure => 'present',
      table => 'nat',
      chain => 'PREROUTING',
      destination => $openstack_base::public_api_ip,
      proto => 'tcp',
      dport => '5000',
      jump => 'DNAT',
      todest => "${openstack_base::keystone_ip}:5000";
    '101_dnat_for_glance':
      ensure => 'present',
      table => 'nat',
      chain => 'PREROUTING',
      destination => $openstack_base::public_api_ip,
      proto => 'tcp',
      dport => '9292',
      jump => 'DNAT',
      todest => "${openstack_base::glance_ip}:9292";
    '101_dnat_for_nova':
      ensure => 'present',
      table => 'nat',
      chain => 'PREROUTING',
      destination => $openstack_base::public_api_ip,
      proto => 'tcp',
      dport => '8774',
      jump => 'DNAT',
      todest => "${openstack_base::nova_ip}:8774";
    '101_dnat_for_nova_ec2':
      ensure => 'present',
      table => 'nat',
      chain => 'PREROUTING',
      destination => $openstack_base::public_api_ip,
      proto => 'tcp',
      dport => '8773',
      jump => 'DNAT',
      todest => "${openstack_base::nova_ip}:8773";
    '101_dnat_for_neutron':
      ensure => 'present',
      table => 'nat',
      chain => 'PREROUTING',
      destination => $openstack_base::public_api_ip,
      proto => 'tcp',
      dport => '9696',
      jump => 'DNAT',
      todest => "${openstack_base::neutron_ip}:9696";
    '101_dnat_for_cinder':
      ensure => 'present',
      table => 'nat',
      chain => 'PREROUTING',
      destination => $openstack_base::public_api_ip,
      proto => 'tcp',
      dport => '8776',
      jump => 'DNAT',
      todest => "${openstack_base::cinder_ip}:8776";
    '102_masq_for_management':
      ensure => 'present',
      table => 'nat',
      chain    => 'POSTROUTING',
      jump     => 'MASQUERADE',
      proto    => 'all',
      outiface => 'eth1';
  }

}
