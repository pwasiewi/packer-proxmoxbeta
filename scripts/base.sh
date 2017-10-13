#!/bin/bash
set -ex
#export HOME=/root
#echo "export HOME=/root" >> $HOME/.bashrc
#echo "export SHELL=/bin/bash" >> $HOME/.bashrc
sed -i 's/#\ You/export SHELL=\/bin\/bash #/g' $HOME/.bashrc
sed -i 's/# alias/alias/g' $HOME/.bashrc
sed -i 's/# export/export/g' $HOME/.bashrc
sed -i 's/# eval/eval/g' $HOME/.bashrc
sed -i 's/# PS1/PS1/g' $HOME/.bashrc
sed -i 's/# unmask/unmask/g' $HOME/.bashrc
. $HOME/.bashrc
echo 'gpg --keyserver pgpkeys.mit.edu --recv-key  "$1"' > /usr/local/bin/pgpkeyadd
echo 'gpg -a --export "$1" | apt-key add -' >> /usr/local/bin/pgpkeyadd
chmod 755 /usr/local/bin/pgpkeyadd
#pgpkey glusterfs
#pgpkeyadd "DAD761554A72C1DF"
echo "deb http://ftp.pl.debian.org/debian stretch main contrib" > /etc/apt/sources.list
echo "deb http://security.debian.org stretch/updates main contrib" >> /etc/apt/sources.list
echo "deb http://download.proxmox.com/debian stretch pve-no-subscription" >> /etc/apt/sources.list
echo "deb http://download.proxmox.com/debian stretch pvetest" >> /etc/apt/sources.list
sed -i 's/^deb/#deb/g' /etc/apt/sources.list.d/pve-enterprise.list
wget -O - http://download.gluster.org/pub/gluster/glusterfs/3.11/rsa.pub | apt-key add -
echo deb [arch=amd64] http://download.gluster.org/pub/gluster/glusterfs/3.11/LATEST/Debian/stretch/apt stretch main > /etc/apt/sources.list.d/gluster.list
apt-get update
apt-get install -y locales dirmngr
sed -i 's/^# pl_PL.UTF/pl_PL.UTF/g' /etc/locale.gen && locale-gen 
update-locale LANG=pl_PL.UTF-8
apt-get dist-upgrade -y
apt-get install -y sudo openssh-server curl iotop vim git lm-sensors sg3-utils mc ethtool wpagui wireless-tools bonnie++ iperf glusterfs-server ansible ntp ntpdate ntpstat rdate aptitude nano git bash-completion sysbench nmap arp-scan gdebi-core pssh traceroute debian-goodies wajig
#curl http://ix.io/nS5 > /etc/ntp.conf
#systemctl stop system-timesync.service;systemctl disable system-timesync.service;systemctl mask #system-timesync.service
#systemctl restart ntp
#systemctl enable ntp
apt-get install quota gdebi-core -y
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.831_all.deb
apt-get install libnet-ssleay-perl libauthen-pam-perl libpam-runtime libio-pty-perl  apt-show-versions -y  
gdebi webmin_1.831_all.deb -n
rm webmin_1.831_all.deb
sed -i 's/DEFAULT="quiet"/DEFAULT="quiet intel_iommu=on vfio_iommu_type1.allow_unsafe_interrupts=1 pci=realloc"/g' /etc/default/grub
update-grub
echo "#etc/modules: kernel modules to load at boot time" > /etc/modules
echo vfio              >> /etc/modules
echo vfio_iommu_type1  >> /etc/modules
echo vfio_pci          >> /etc/modules
echo vfio_virqfd       >> /etc/modules
echo "deb http://www.deb-multimedia.org stretch main non-free" > /etc/apt/sources.list.d/mint.list
apt-get update
apt-get install -y --force-yes deb-multimedia-keyring
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y
#apt-get install -y mate-desktop-environment xorg lightdm X11vnc
#apt-get install -y firefox-esr-l10n-pl
apt-get install -y openvswitch-switch
#https://serversforhackers.com/an-ansible-tutorial
#http://www.cyberciti.biz/faq/
[ ! -d /etc/ansible ] && mkdir /etc/ansible
[ -f /etc/ansible/hosts ] && mv /etc/ansible/hosts /etc/ansible/hosts.orig -f
echo "[web]" > /etc/ansible/hosts
#echo "192.168.11.5${host01}" >> /etc/ansible/hosts
echo 'ansible all -s -m shell -a "$1"' > /usr/local/bin/ae
chmod 700 /usr/local/bin/ae
[ ! -d /mnt/SambaShare ] && mkdir /mnt/SambaShare
echo "#!/bin/sh -e" > /etc/rc.local
echo "mount /mnt/SambaShare" >> /etc/rc.local
echo "mount -a" >> /etc/rc.local
echo "gluster volume start vol0" >> /etc/rc.local
sed -i 's/exit/\#exit/g' /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod 755 /etc/rc.local
#update-rc.d rc.local defaults
#update-rc.d rc.local enable
cat << __EOF__ >  /etc/systemd/system/rc-local.service
[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExists=/etc/rc.local
 After=network.target
[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
 SysVStartPriority=99
[Install]
 WantedBy=multi-user.target
__EOF__
systemctl enable rc-local
/etc/init.d/kmod start  
update-rc.d kmod enable
curl ix.io/client > /usr/local/bin/ix
chmod +x /usr/local/bin/ix
echo "T" | pveceph install -version luminous
[ ! -d /etc/ceph ] && mkdir /etc/ceph
ln -sfn /etc/pve/ceph.conf  /etc/ceph/ceph.conf  
cd
curl https://pastebin.com/raw/anHdueta | sed 's/\r//g' > VAskryptfunkcje.sh
sh VAskryptfunkcje.sh
curl https://pastebin.com/raw/Ey6qHu37 | sed 's/\r//g' > VAskryptglownyMiniUbuntu.txt 
