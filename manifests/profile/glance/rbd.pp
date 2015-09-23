# create images
# glance image-create --name Ubuntu-14.04 --is-public true --disk-format qcow2 --container-format bare --file /tmp/trusty-server-cloudimg-amd64-disk1.img
# optimize images for ceph
# glance image-update --property hw_scsi_model=virtio-scsi --property hw_disk_bus=scsi --property hw_qemu_guest_agent=yes --property os_require_quiesce=yes Ubuntu-14.04

class openstack_base::profile::glance::rbd (
  $rbd_user = 'client.glance',
  $rbd_pool = 'images'
) {

  include openstack_base
  include ceph_base

  class { 'glance::api':
    identity_uri          => "http://${openstack_base::keystone_ip}:35357",
    verbose               => true,
    keystone_tenant       => 'services',
    keystone_user         => 'glance',
    keystone_password     => $openstack_base::admin_password,
    database_connection   => "mysql://glance:${openstack_base::glance_mysql_password}@${openstack_base::mysql_ip}/glance",
    known_stores          => ['rbd'],
    show_image_direct_url => true,
  }

  class { 'glance::registry':
    identity_uri        => "http://${openstack_base::keystone_ip}:35357",
    verbose             => true,
    keystone_tenant     => 'services',
    keystone_user       => 'glance',
    keystone_password   => $openstack_base::admin_password,
    database_connection => "mysql://glance:${openstack_base::glance_mysql_password}@${openstack_base::mysql_ip}/glance",
  }

#  class { 'glance::backend::file': }

  class { 'glance::backend::rbd':
    rbd_store_user => $rbd_user,
    rbd_store_pool=> $rbd_pool,
  }


  class { 'glance::notify::rabbitmq':
    rabbit_password => $openstack_base::rabbitmq_password,
    rabbit_userid   => 'openstack',
    rabbit_hosts    => ["${openstack_base::rabbitmq_ip}:5672"],
    rabbit_use_ssl  => false,
  }

#
#  exec { 'retrieve_cirros_image':
#    command => 'wget -q http://download.cirros-cloud.net/0.3.4/\
#cirros-0.3.4-x86_64-disk.img -O /tmp/cirros-0.3.4-x86_64-disk.img',
#    unless  => [ "glance --os-username admin --os-tenant-name admin \
#--os-password ${openstack_base::admin_password} --os-auth-url http://${openstack_base::keystone_ip}:35357/v2.0 \
#image-show cirros-0.3.4-x86_64" ],
#    path    => [ '/usr/bin/', '/bin' ],
#    require => [ Class['glance::api'], Class['glance::registry'] ]
#  }->
#  exec { 'add_cirros_image':
#    command => "glance --os-username admin --os-tenant-name admin --os-password \
#${openstack_base::admin_password} --os-auth-url http://${openstack_base::keystone_ip}:35357/v2.0 image-create \
#--name cirros-0.3.4-x86_64 --file /tmp/cirros-0.3.4-x86_64-disk.img \
#--disk-format qcow2 --container-format bare --is-public True",
#    # Avoid dependency warning
#    onlyif  => [ 'test -f /tmp/cirros-0.3.4-x86_64-disk.img' ],
#    path    => [ '/usr/bin/', '/bin' ],
#  }->
#  file { '/tmp/cirros-0.3.4-x86_64-disk.img':
#    ensure => absent,
#  }
#
}
