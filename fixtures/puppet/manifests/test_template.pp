class { 'test': }

class test {
  
  $variable = "BLAH"

  file { "/tmp/puppet_test_template":
	  ensure => present,
    mode  => '0666',
    content => template(template_test)
  }
}
