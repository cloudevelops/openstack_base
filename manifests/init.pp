# == Class: openstack_base
#
# Full description of class openstack_base here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { openstack_base:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class openstack_base (
  $mysql_ip                     = $openstack_base::params::mysql_ip,
  $mysql_root_password          = $openstack_base::params::mysql_root_password,
  $keystone_enabled             = $openstack_base::params::keystone_enabled,
  $keystone_ip                  = $openstack_base::params::keystone_ip,
  $keystone_mysql_password      = $openstack_base::params::keystone_mysql_password,
  $region                       = $openstack_base::params::region,
  $admin_token                  = $openstack_base::params::admin_token,
  $admin_password               = $openstack_base::params::admin_password,
  $glance_enabled               = $openstack_base::params::glance_enabled,
  $glance_ip                    = $openstack_base::params::glance_ip,
  $glance_mysql_password        = $openstack_base::params::glance_mysql_password,
  $rabbitmq_password            = $openstack_base::params::rabbitmq_password,
  $rabbitmq_ip                  = $openstack_base::params::rabbitmq_ip,
  $nova_enabled                 = $openstack_base::params::nova_enabled,
  $nova_ip                      = $openstack_base::params::nova_ip,
  $nova_mysql_password          = $openstack_base::params::nova_mysql_password,
  $metadata_proxy_shared_secret = $openstack_base::params::metadata_proxy_shared_secret,
  $neutron_enabled              = $openstack_base::params::neutron_enabled,
  $neutron_ip                   = $openstack_base::params::neutron_ip,
  $neutron_mysql_password       = $openstack_base::params::neutron_mysql_password,
  $memcache_ip                  = $openstack_base::params::memcache_ip,
  $horizon_ip                   = $openstack_base::params::horizon_ip,
  $horizon_fqdn                 = $openstack_base::params::horizon_fqdn,
  $horizon_secret               = $openstack_base::params::horizon_secret,
  $cinder_enabled               = $openstack_base::params::cinder_enabled,
  $cinder_ip                    = $openstack_base::params::cinder_ip,
  $cinder_mysql_password        = $openstack_base::params::cinder_mysql_password,

) inherits openstack_base::params {

  include openstack_base::environment::repository
  include openstack_base::environment::sourcefiles

}
