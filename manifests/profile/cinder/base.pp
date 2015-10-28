# Example to add multiple backends
# cinder type-create lvm_ssd
# cinder type-create ceph_hdd
# cinder type-key lvm_ssd set volume_backend_name=lvm_ssd
# cinder type-key ceph_hdd set volume_backend_name=ceph_hdd
#
class openstack_base::profile::cinder::base (
  $scheduler_driver = 'cinder.scheduler.simple.SimpleScheduler',
  $filter_patches = true,
) {

  include openstack_base
  include openstack_base::profile::cinder::shared

  class { 'cinder::api':
    enabled           => true,
    keystone_user     => 'cinder',
    keystone_password => $openstack_base::admin_password,
    auth_uri          => "http://${openstack_base::keystone_ip}:5000/v2.0",
    identity_uri      => "http://${openstack_base::keystone_ip}:35357",
    sync_db           => true,
    service_workers   => $api_workers,
    validate          => true, # Fails with a V2 API endpoint
    default_volume_type => $openstack_base::profile::cinder::shared::default_volume_type
  }

  cinder_config {
    'keymgr/encryption_auth_url': value => "http://${openstack_base::keystone_ip}:5000/v3",;
  }

  class { 'cinder::scheduler':
    enabled          => true,
    scheduler_driver => $scheduler_driver,
  }

  cinder_config {
    'DEFAULT/scheduler_default_filters': value => 'CapacityFilter,CapabilitiesFilter,AvailabilityZoneFilter';
  }

  class {'cinder::client':
  }

  if $filter_patches {
    file {
      '/usr/lib/python2.7/dist-packages/cinder/openstack/common/scheduler/filters/availability_zone_filter.py':
        ensure => present,
        source => 'puppet:///modules/openstack_base/profile/cinder/filter_patches/availability_zone_filter.py',
        notify => Service['cinder-volume'];
      '/usr/lib/python2.7/dist-packages/cinder/openstack/common/scheduler/filters/availability_zone_filter.pyc':
        ensure => present,
        source => 'puppet:///modules/openstack_base/profile/cinder/filter_patches/availability_zone_filter.pyc',
        notify => Service['cinder-volume'];
      '/usr/lib/python2.7/dist-packages/cinder/openstack/common/scheduler/filters/capabilities_filter.py':
        ensure => present,
        source => 'puppet:///modules/openstack_base/profile/cinder/filter_patches/capabilities_filter.py',
        notify => Service['cinder-volume'];
      '/usr/lib/python2.7/dist-packages/cinder/openstack/common/scheduler/filters/capabilities_filter.pyc':
        ensure => present,
        source => 'puppet:///modules/openstack_base/profile/cinder/filter_patches/capabilities_filter.pyc',
        notify => Service['cinder-volume'];
    }
  }

}
