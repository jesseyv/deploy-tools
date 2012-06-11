class uwsgi_node::nginx {
    
    exec { 'nginx_repository':
        command => 'add-apt-repository ppa:nginx/stable',
        path => '/usr/bin',
        refreshonly => true,
        require => Package['python-software-properties'],
        notify => Exec['apt_update']
    }

    package { 'nginx':
        ensure => installed,
        require => Exec['nginx_repository']
    }
    
}
