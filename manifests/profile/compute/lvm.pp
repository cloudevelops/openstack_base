class openstack_base::profile::compute::lvm (
  $ephemeral_storage = true,
  $volume_backend_name = 'DEFAULT',
  $volume = {},
  $rbd_lvm_migration_patch = false,
  $vg = 'vg0',
  $init_vg = false,
  $cinder_lv = false,
  $cinder_lv_size = '25G',
  $cinder_lv_fs = 'ext4',
) {

  include openstack_base::profile::compute::base

  ensure_packages('thin-provisioning-tools')

  $volume_ip = $openstack_base::profile::compute::base::volume_ip

  cinder::backend::iscsi { $volume_backend_name:
    iscsi_ip_address => $volume_ip,
    volume_group     => $vg,
    extra_options    => {
      "${volume_backend_name}/lvm_type" => {
        value => 'thin'
      },
      "${volume_backend_name}/max_over_subscription_ratio" => {
        value => '1'
      }
    }
  }

  if $ephemeral_storage {
    nova_config {
      'libvirt/images_type':
        value => 'lvm';
      'libvirt/images_volume_group':
        value => $vg;
    }
  }

  include repository_base::profile::apt::ubuntu_backports

  file {'/etc/init/tgt.conf':
    ensure => present,
    content => template('openstack_base/profile/compute/tgt.conf.erb'),
    notify => Service['tgt']
  }

  create_resources('openstack_base::profile::compute::lvm_volume',$volume)

  if $rbd_lvm_migration_patch {
    file {
      '/usr/lib/python2.7/dist-packages/cinder/volume/drivers/lvm.py':
        ensure => present,
        source => 'puppet:///modules/openstack_base/profile/cinder/rbd_lvm_migration_patch/lvm.py',
        notify => Service['cinder-volume'];
      '/usr/lib/python2.7/dist-packages/cinder/volume/drivers/lvm.pyc':
        ensure => present,
        source => 'puppet:///modules/openstack_base/profile/cinder/rbd_lvm_migration_patch/lvm.pyc',
        notify => Service['cinder-volume'];
    }
  }

  if $cinder_lv {

    logical_volume { 'cinder':
      ensure       => present,
      volume_group => $vg,
      size         => $cinder_lv_size,
    }

    filesystem { "/dev/${vg}/cinder":
      ensure  => present,
      fs_type => $cinder_lv_fs,
      require => Logical_Volume['cinder'],
    }

    file {
      '/srv/cinder':
        ensure => directory;
      '/srv/cinder/conversion':
        ensure => directory,
        owner => 'cinder',
        group => 'cinder',
        require => Mount['/srv/cinder'];
      '/var/lib/cinder/conversion':
        ensure => link,
        target => '/srv/cinder/conversion',
        force => true,
        require => [ Mount['/srv/cinder'], File['/srv/cinder/conversion' ] ];
    }

    mount {
      '/srv/cinder':
        device  => "/dev/${vg}/cinder",
        fstype  => $cinder_lv_fs,
        ensure  => 'mounted',
        atboot  => true,
        options => 'defaults',
        require => [ File['/srv/cinder'], Filesystem["/dev/${vg}/cinder"] ];
    }

  }

}
