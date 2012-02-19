class test_module {

  file { "/tmp/puppet_test_module":
	  ensure => present,
    mode  => '0666',
  }

}
