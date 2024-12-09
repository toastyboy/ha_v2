#!/bin/bash

#create ssh keys
ssh-keygen 

## add public keys to authorized_keys file
cat hp_ohpc_pubkey > /home/pi/.ssh/authorized_keys

# hostname stuff
hostname="notfound"

if  [ `hostname -I` == "192.168.100.100" ] ; then hostname="pink" ; fi
if  [ `hostname -I` == "192.168.100.102" ] ; then hostname="testpi" ; fi
if  [ `hostname -I` == "192.168.100.101" ] ; then hostname="black" ; fi
if  [ `hostname -I` == "192.168.100.104" ] ; then hostname="clear" ; fi
if  [ `hostname -I` == "192.168.100.105" ] ; then hostname="blue" ; fi
if  [ `hostname -I` == "192.168.100.108" ] ; then hostname="garagepink" ; fi
if  [ `hostname -I` == "192.168.100.109" ] ; then hostname="butler" ; fi
if  [ `hostname -I` == "192.168.100.110" ] ; then hostname="garagepi2" ; fi
if  [ `hostname -I` == "192.168.100.111" ] ; then hostname="shedpi" ; fi
if  [ `hostname -I` == "192.168.100.116" ] ; then hostname="pizero" ; fi
if  [ `hostname -I` == "192.168.100.117" ] ; then hostname="keypad" ; fi
if  [ `hostname -I` == "192.168.100.118" ] ; then hostname="solar" ; fi
if  [ `hostname -I` == "192.168.100.119" ] ; then hostname="boiler" ; fi
if  [ `hostname -I` == "192.168.100.120" ] ; then hostname="nas" ; fi

sudo bash -c "echo $hostname > /etc/hostname"

sudo bash -c "echo '127.0.0.1   localhost' > /etc/hosts"
sudo bash -c "echo '::1     localhost ip6-localhost ip6-loopback' >> /etc/hosts"
sudo bash -c "echo 'ff02::1             ip6-allnodes' >> /etc/hosts"
sudo bash -c "echo 'ff02::2             ip6-allrouters' >> /etc/hosts"
sudo bash -c "echo ' ' >> /etc/hosts"
sudo bash -c "echo '127.0.1.1   $hostname' >> /etc/hosts"

