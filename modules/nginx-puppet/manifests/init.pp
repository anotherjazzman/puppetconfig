class nginx-puppet {
  file { 'nginx_install_script':
      ensure => 'file',
      path  => '/tmp/puppetconfig/modules/nginx-puppet/files/nginx_install.sh',
      owner => 'root',
      group => 'root',
      mode  => '0755', 
      notify => Exec['run_install'],
  }
  exec { 'run_install':
      command => '/bin/bash -c /tmp/puppetconfig/modules/nginx-puppet/files/nginx_install.sh',
      refreshonly => true
  }
}
