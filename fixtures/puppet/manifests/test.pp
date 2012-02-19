class { 'test': }

class test {
  file { "/tmp/puppet_test":
	  ensure => present,
    mode  => '0666',
  }
}
