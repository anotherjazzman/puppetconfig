class nginx-puppet {
  file { 'nginx_install_script':
      ensure => 'file',
      path  => '/tmp/puppetconfig/modules/nginx-puppet/files/install_nginx.sh',
      owner => 'root',
      group => 'root',
      mode  => '0755', 
      notify => Exec['run_install'],
  }
  exec { 'run_install':
      command => '/bin/bash -c /tmp/puppetconfig/nginx-puppet/files/install_nginx.sh',
      refreshonly => true
  }
}
