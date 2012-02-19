node /^correct.*/ inherits default_node {
  
  file { "/tmp/puppet_test_correct":
	  ensure => present,
    mode  => '0666',
  }

}

node /^incorrect.*/ inherits default_node {

  file { "/tmp/puppet_test_incorrect":
	  ensure => present,
    mode  => '0666',
  }

}

node default_node {

  file { "/tmp/puppet_test_default":
	  ensure => present,
    mode  => '0666',
  }

}
