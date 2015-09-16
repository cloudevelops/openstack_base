class openstack_base::profile::neutron::base {

  include openstack_base

  class { '::neutron':
    enabled               => true,
    bind_host             => '0.0.0.0',
    rabbit_host           => $openstack_base::rabbitmq_ip,
    rabbit_user           => 'openstack',
    rabbit_password       => $openstack_base::rabbitmq_password,
    verbose               => true,
    debug                 => false,
    core_plugin           => 'ml2',
    service_plugins       => ['router', 'metering'],
    allow_overlapping_ips => true,
  }

  class { 'neutron::server':
    auth_user           => 'neutron',
    auth_password       => $openstack_base::admin_password,
    auth_tenant         => 'services',
    auth_uri            => "http://${openstack_base::keystone_ip}:5000/v2.0",
    identity_uri        => "http://${openstack_base::keystone_ip}:35357",
    database_connection => "mysql://neutron:${openstack_base::neutron_mysql_password}@${openstack_base::mysql_ip}/neutron?charset=utf8",
    sync_db             => true,
  }

  class { '::neutron::server::notifications':
    nova_admin_tenant_name => 'services',
    nova_admin_password    => $openstack_base::admin_password,
  }


  class { '::neutron::plugins::ml2':
    type_drivers         => ['flat', 'vlan', 'gre', 'vxlan'],
    tenant_network_types => ['flat', 'vlan', 'gre', 'vxlan'],
    vxlan_group          => '239.1.1.1',
    mechanism_drivers    => ['openvswitch'],
    flat_networks        => ['physnet1'],
    vni_ranges           => ['1001:2000'], #VXLAN
    tunnel_id_ranges     => ['1001:2000'], #GRE
    network_vlan_ranges  => ['physnet1:3001:4000'],
  }


}
