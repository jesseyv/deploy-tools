class uwsgi_node::apps {
    
    exec { 'apt_update':
        command => '/usr/bin/apt-get update',
        refreshonly => true,
    }

    package { 'gcc':
        ensure => installed
    }

    package { 'python-dev':
        ensure => installed,
        require => Package['gcc']
    }

    package { 'python-software-properties':
        ensure => installed,
        notify => Exec['apt_update']
    }

    package { 'git-core':
        ensure => installed,
    }
    
    package { 'virtualenvwrapper':
        provider => 'pip',
        require => Package['python-dev'],
        ensure => installed
    }
    
}
