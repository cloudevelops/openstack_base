class openstack_base::environment::repository {

  ensure_packages('ubuntu-cloud-keyring')

  apt::source { 'ubuntu-cloud':
    location          =>  'http://ubuntu-cloud.archive.canonical.com/ubuntu',
    repos             =>  'main',
    release           =>  "trusty-updates/${openstack_base::version}"
  }


}