class openstack_base::role::cloudgw {

  include openstack_base::profile::cloudgw
  include puppet_base::foremanproxy

}
