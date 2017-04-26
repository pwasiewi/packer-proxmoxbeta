#!/bin/bash
set -ex
useradd vagrant -u 501 -g sudo -s /bin/bash
echo vagrant:vagrant | chpasswd
cat <<EOF > /etc/sudoers.d/vagrant
vagrant ALL=(ALL) NOPASSWD: ALL
Defaults:vagrant !requiretty
EOF
chmod 0440 /etc/sudoers.d/vagrant

mkdir -pm 700 ~vagrant/.ssh
wget 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O ~vagrant/.ssh/authorized_keys

chmod 0600 ~vagrant/.ssh/authorized_keys
chown -R vagrant:sudo ~vagrant

#passwd -l root
#echo root:vagrantkorzen | chpasswd
