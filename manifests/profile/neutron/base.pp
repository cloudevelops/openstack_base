class openstack_base::profile::neutron::base {

  include openstack_base
  include openstack_base::profile::neutron::shared

  class { 'neutron::server':
    auth_user                        => 'neutron',
    auth_password                    => $openstack_base::admin_password,
    auth_tenant                      => 'services',
    auth_uri                         => "http://${openstack_base::keystone_ip}:5000/v2.0",
    identity_uri                     => "http://${openstack_base::keystone_ip}:35357",
    database_connection              => "mysql://neutron:${openstack_base::neutron_mysql_password}@${openstack_base::mysql_ip}/neutron?charset=utf8",
    sync_db                          => true,
    allow_automatic_l3agent_failover => true,
  }

  class { '::neutron::server::notifications':
    nova_admin_tenant_name => 'services',
    nova_admin_password    => $openstack_base::admin_password,
    nova_url               => "http://${openstack_base::nova_ip}:8774/v2",
    nova_admin_auth_url    => "http://${openstack_base::keystone_ip}:35357/v2.0"
  }

}
