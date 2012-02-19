class { 'test': }

class test {
  package { "bind": ensure => installed }

  service { "named":
    enable  => true,
    ensure  => running,
    require => Package["bind"],
   } 
}
