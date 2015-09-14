class openstack_base::environment::repository {

  apt::source { 'ubuntu-cloud':
    location          =>  'http://ubuntu-cloud.archive.canonical.com/ubuntu',
    repos             =>  'main',
    release           =>  'trusty-updates/kilo',
    required_packages =>  'ubuntu-cloud-keyring',
  }


}