# -*- coding: utf-8 -*-
from fabric.api import *
from fabric.colors import *

packages = [
    'lsb',
    'python-pip',
    'build-essential',
    'libxml2-dev',
    'puppet-common',
]


def _copy_ssh_keys():
    print(yellow('Trying to copy SSH keys')) 
    local('ssh-copy-id {0.user}@{0.host_string}'.format(env))
    print(green('SSH keys copied')) 

def _update_packages(upgrade=False):
    print(green('Updating packages'))
    run('apt-get update')
    if upgrade:
        print(green('Upgrading packages'))
        run('apt-get upgrade -y')

def _install_packages():
    print(green('Installing packages'))
    run('apt-get -yq install {0}'.format(' '.join(packages)))
    

def setup_new():
    _copy_ssh_keys()
    with cd('/tmp'):
        run('wget http://apt.puppetlabs.com/puppetlabs-release_1.0-3_all.deb')
        run('dpkg -i puppetlabs-release_1.0-3_all.deb')
    _update_packages(True)
    _install_packages()
    put('./configs/puppet_default', '/etc/default/puppet')
    #with settings(warn_only=True):
    #    result = run('service puppet restart')
    #    if result.failed:
    #        run('service puppet start')
        
    print(green('Server ready for running Puppet manifests'))
    
    with settings(warn_only=True):
        run('mkdir -p /etc/puppet/modules')
    print(green('Uploading bootstrap modile to server'))
    put('./puppet_modules/uwsgi_node', '/etc/puppet/modules')
    print(green('Apply Puppet module'))
    run('puppet apply /etc/puppet/modules/uwsgi_node/manifests/init.pp')
