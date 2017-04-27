# packer-proxmoxbeta

[![CircleCI](https://img.shields.io/circleci/project/pwasiewi/packer-proxmoxbeta.svg?maxAge=2592000)](https://circleci.com/gh/pwasiewi/packer-proxmoxbeta)

packer template to build Ubuntu Server images

vagrant images are available at [42n4/proxmoxbeta](https://atlas.hashicorp.com/42n4/boxes/proxmoxbeta).

## Building Images

To build images, simply run:

```
git clone https://github.com/pwasiewi/packer-proxmoxbeta
cd packer-proxmoxbeta
export ATLAS_TOKEN=the token string taken from Atlas https://atlas.hashicorp.com/settings/tokens
packer build -only=virtualbox-iso template.json
```

If you want to build only virtualbox, vmware or qemu, but now only virtualbox one works with ceph.

```
packer build -only=virtualbox-iso template.json
packer build -only=vmware-iso template.json
packer build -only=qemu template.json
```

Next, try to execute it in a new directory:  

```
#vagrant destroy -f #remove ALL previous instances
vagrant box update  #update this box in order to make 3 hosts
wget https://raw.githubusercontent.com/pwasiewi/packer-proxmoxbeta/master/Vagrantfile.3hosts -O Vagrantfile
sed -i 's/192.168.0/192.168.<your local net number>/g' Vagrantfile
sed -i 's/enp0s31f6/eth0/g' Vagrantfile # you change the host bridge name if it is not 'enp0s31f6'
#in MSWin it gives you names: VBoxManage.exe list bridgedifs
#:bridge => "Intel(R) Ethernet Connection (2) I219-V",
vagrant up
vagrant ssh server1
#in windows: https://www.sitepoint.com/getting-started-vagrant-windows/
#you use putty after converting with puttygen a vagrant openssh key to a putty key
```

Login to the server1 root account 

```
sudo su -
```

and execute:

```
va_hosts4ssh server
pvecm create kluster
ssh server2 "pvecm add server1" 
ssh server3 "pvecm add server1"
ssh server2 "reboot" 
ssh server3 "reboot"
reboot
ae "apt-get update"
ae "apt-get install -y ceph"
ae "apt-get dist-upgrade -y"
pveceph init --network 192.168.2.0/24 #CHANGE TO YOUR NET
for i in server1 server2 server3; do ssh $i "pveceph createmon"; done
for i in server1 server2 server3; do ssh $i "ceph-disk zap /dev/sdb" && ssh $i "pveceph createosd /dev/sdb" && ssh $i "partprobe /dev/sdb1"; done
cd /etc/pve/priv/
mkdir ceph
cp /etc/ceph/ceph.client.admin.keyring ceph/rbd.keyring
cp /etc/ceph/ceph.client.admin.keyring ceph/ceph4vm.keyring
ceph osd pool set rbd size 2     #replica number
ceph osd pool set rbd min_size 1 #min replica number after e.g. server failure
#add in GUI rdb storage named ceph4vm with monitor hosts: 192.168.2.71 192.168.2.72 192.168.2.73 #CHANGE TO YOUR NET 
cd
ae "rm -f ~/interfaces && cp /usr/local/bin/va_interfaces ~/interfaces"
for i in server1 server2 server3; do ssh $i "sed -i 's/192.168.2.71/'`grep $i /etc/hosts | awk  '{ print $1}'`'/g' ~/interfaces && cat ~/interfaces"; done && \
ae "rm -f /etc/network/interfaces && cp ~/interfaces /etc/network/interfaces" && \
ae "cat /etc/network/interfaces"
```

`vagrant halt -f && vagrant up`

## Release setup

Vagrant images at [Atlas](https://atlas.hashicorp.com) are released by [Circle CI](https://circleci.com/).
setup instructions are the following:

1. Sign up
  - [Atlas](https://atlas.hashicorp.com/account/new)
  - [Circle CI](https://circleci.com/signup).
2. Get API token
  - [Atlas](https://atlas.hashicorp.com/settings/tokens)
  - [Circle CI](https://circleci.com/account/api)
3. Create new build configuration at [Atlas](https://atlas.hashicorp.com/builds/new)
  and [generate token](https://atlas.hashicorp.com/settings/tokens).
4. Create project at [Circle CI](https://circleci.com/add-projects)
5. Add Atlas environment variables to Circle CI project:
  
  ```console
  $ ATLAS_TOKEN={{ your atlas api token here }}
  $ CIRCLE_USERNAME={{ your circle ci username here }}
  $ CIRCLE_PROJECT={{ your circle ci project here }}
  $ CIRCLE_TOKEN={{ your circle ci token here }}
  $ CIRCLE_ENVVARENDPOINT="https://circleci.com/api/v1/project/$CIRCLE_USERNAME/$CIRCLE_PROJECT/envvar?circle-token=$CIRCLE_TOKEN"
  $ json="{\"name\":\"ATLAS_TOKEN\",\"value\":\"$ATLAS_TOKEN\"}"
  $ curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d "$json" "$CIRCLE_ENVVARENDPOINT"
  ```
  
6. Edit circle.yml

## License

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed)

dedicated to public domain, no rights reserved.

