class uwsgi_node ($home_path) {

    user { 'www-data':
        ensure => present,
        shell => '/bin/bash',
    }

    file { 'home':
        path => "${home_path}",
        ensure => directory,
        owner => 'www-data',
        group => 'www-data'
    }

    file { 'projects':
        path => "${home_path}/projects",
        ensure => directory,
        owner => 'www-data',
        group => 'www-data',
        require => File['home'],
    }

    include uwsgi_node::apps
    include uwsgi_node::uwsgi
    include uwsgi_node::nginx

}

class { 'uwsgi_node': 
    home_path => "/var/www",
}

