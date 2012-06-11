class uwsgi_node::uwsgi {
    
    exec { 'add_uwsgi_ppa':
        command => '/usr/bin/add-apt-repository ppa:uwsgi/release',
        refreshonly => true,
        require => Package['python-software-properties'],
        notify => Exec['apt_update'],
    }
    
    package { 'uwsgi':
        provider => 'pip',
        ensure => latest,
        require => [Exec['add_uwsgi_ppa'], Package['python-dev', 'gcc']],
        notify => File['/etc/init/uwsgi.conf']
    }
    
    file { '/var/log/uwsgi':
        ensure  => directory,
        require => Package['uwsgi'],
        owner => 'www-data',
        group => 'www-data'
    }
    
    file { '/etc/init/uwsgi.conf':
        ensure  => file,
        require => Package['uwsgi'],
        content => template('uwsgi_node/uwsgi_init.conf.erb'),
    }
    
    file { '/etc/uwsgi':
        ensure => directory,
        require => Package['uwsgi'],
    }
    
    file { '/etc/uwsgi/apps-enabled':
        ensure => directory,
        require => File['/etc/uwsgi'],
    }

    #service { 'uwsgi':
    #    provider => upstart,
    #    ensure => running,
    #    enable    => true,
    #    subscribe => File['/etc/init/uwsgi.conf'],
    #    require => [File['/etc/init/uwsgi.conf', '/var/log/uwsgi']]
    #}
    
    exec { '/sbin/start uwsgi':
        path => '/usr/local/bin',
        require => [Package['uwsgi'], File['/etc/init/uwsgi.conf', '/var/log/uwsgi']]
    }
}
