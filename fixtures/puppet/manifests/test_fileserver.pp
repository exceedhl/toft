class { 'test': }

class test {
  file { "test_fileserver":
		path => "/tmp/puppet_test_fileserver",
		owner => "root",
		group => "root",
		mode => 0440,
		source => "puppet:///conf/test_fileserver",
	}
}
  


