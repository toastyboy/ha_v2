#!/bin/bash

# general update

sudo apt-get update
sudo apt-get upgrade


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


#dns utils
sudo apt-get install dnsutils





#install git
sudo apt-get install git

#dnstools
sudo apt-get install dnsutils

#install apache and php
sudo apt-get install apache2
sudo apt-get install php

#stuff
sudo apt-get install python-smbus

sudo apt-get install i2c-tools
sudo adduser pi i2c

sudo apt-get install libssl-dev

#perl stuff

mkdir perl_modules
cd perl_modules

#Might seem odd to install like this, but doesn't work from cpanm for some reason...
wget http://search.cpan.org/CPAN/authors/id/C/CO/COOK/Device-SerialPort-1.04.tar.gz

wget http://search.cpan.org/CPAN/authors/id/G/GB/GBARR/IO-1.25.tar.gz

tar -xvzf Device-SerialPort-1.04.tar.gz
tar -xvzf IO-1.25.tar.gz

cd Device-SerialPort-1.04/

perl Makefile.PL
make
make test
sudo make install

cd ..

cd IO-1.25

perl Makefile.PL
make test
sudo make install

sudo cpan App::cpanminus
sudo cpanm Device::SerialPort  # Note need to install from tar first (as above)
sudo cpanm IO
sudo cpanm --force IO::Socket::SSL
sudo cpanm --force Net::SSLeay
sudo cpanm Email::Send::SMTP::Gmail
sudo cpanm IO::Socket::SSL


sudo modprobe w1-gpio
sudo modprobe w1-therm


#residual stuff
sudo apt-get install python3-pip
sudo pip3 install adafruit-circuitpython-ads1x15
sudo pip3 install --upgrade setuptools
sudo pip3 install RPI.GPIO
sudo pip3 install adafruit-blinka

sudo apt-get install bc
sudo apt-get install ntp
sudo apt-get install wiringpi
sudo apt-get install minicom
sudo apt-get install expect

sudo apt-get install python-urllib3

sudo apt-get install telnet
exit

#dont forget

add this to rsyslogd.conf

#Remote TCP logging
*.*     @@192.168.100.69

then sudo service syslog restart
