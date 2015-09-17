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

}
