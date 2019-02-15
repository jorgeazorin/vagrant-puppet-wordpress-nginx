include apt

exec { 'apt-update':
  command => '/usr/bin/apt-get update'
}
Exec["apt-update"] -> Package <| |>

#Basic packages
package { [ 'unzip','software-properties-common' ] :
  ensure => installed,
}


#PHP
apt::ppa { 'ppa:ondrej/php': }
Exec["apt-update"] -> Package <| |>


package { [ 'php', 'php-fpm','php-mysql', 'php-xml' ] :
  ensure => installed,
}
package { 'apache2' :
  ensure => absent,
}


# MySQL
include '::mysql::server'

mysql::db { 'wordpress':
  user     => 'wordpress',
  password => 'banana',
  host     => 'localhost',
  sql      => '/vagrant/modules/wordpress/files/wp-database.sql',
  grant    => ['ALL'],
}

# Nginx
package { 'nginx' :
  ensure => installed,
}

service { 'nginx':
  ensure => running,
  enable => true,
  hasstatus => true,
  restart => "/usr/sbin/service nginx reload"
}

file { "/etc/nginx/sites-available/default":
  ensure => present,
  source => 'puppet:///modules/nginx/default',
  notify => Service['nginx'],
}

# Wordpress

file { "/tmp/wordpress.zip":
  ensure => present,
  source => 'puppet:///modules/wordpress/wordpress.zip'
}

archive { '/var/www/wordpress/wp-config-sample.php':
  path => '/tmp/wordpress.zip',
  extract      => true,
  extract_path => '/var/www',
  creates       => "/var/www/wordpress"
}

file { "/var/www/wordpress/wp-config.php":
  ensure => present,
  source => 'puppet:///modules/wordpress/wp-config.php'
}
