#!/bin/sh

set -x

CONNECTION_STRING="$1"
PACKAGES="lsb python-pip build-essential libxml2-dev puppet-common"

remote_cmd() {
    ssh -t $CONNECTION_STRING "$1"
}

ssh-copy-id $CONNECTION_STRING

remote_cmd "
apt-get update;
cd /tmp; 
wget http://apt.puppetlabs.com/puppetlabs-release_1.0-3_all.deb;
dpkg -i puppetlabs-release_1.0-3_all.deb"

scp "`pwd`/configs/puppet_default" "$CONNECTION_STRING:/etc/default/puppet"

remote_cmd "
apt-get upgrade;
mkdir -p /etc/puppet/modules
"

scp "`pwd`/puppet_modules/uwsgi_node" "$CONNECTION_STRING:/etc/puppet/modules"

remote_cmd "puppet apply /etc/puppet/modules/uwsgi_node/manifests/init.pp"
