#!/bin/bash

###########################
#FUNCTIONS
#########

#Variable Initialisation
function inits {
  varhost="varhost" ;
  varstore="varshare/varstore.php" ;
  hname=`hostname` ;
  disk=$hname"sddisk" ;
  disk2=$hname"usbdisk1" ;
  disk3=$hname"usbdisk2" ;
  tx=$hname"tx" ;
  rx=$hname"rx" ;
  uptime=$hname"uptime" ;
  loadav=$hname"load" ;
  temps=$hname"temp" ;
  procs=$hname"procs" ;
  pings=$hname"ping" ;
}

#Main Disk (SDCARD)
function maindisk {
  var=`df -k | grep root | awk '{ print $5 }' | sed s/[^0-9]*//g` ;
  #echo $var
  logger "HAL - $hname - diskspace is $var" ;
  curl -sd "varname=$disk&value=$var&action=Send" http://$varhost/$varstore
  echo
}

#Secondary Disk (USB)
function usb1 {
  var=`df -k | grep sda1 | awk '{ print $5 }' | sed s/[^0-9]*//g` ;
  #echo $var
  logger "HAL - $hname - diskspace is $var" ;
  curl -sd "varname=$disk2&value=$var&action=Send" http://$varhost/$varstore
  echo
}

#Secondary Disk2 (USB)
function usb2 {
  var=`df -k | grep sdb1 | awk '{ print $5 }' | sed s/[^0-9]*//g` ;
  #echo $var
  logger "HAL - $hname - diskspace is $var" ;
  curl -sd "varname=$disk3&value=$var&action=Send" http://$varhost/$varstore
  echo
}

#Uptime
function uptimes {
  var=`uptime | sed s/^.*up// | \
  awk -F, '{ if ( $3 ~ /user/ ) { print $1 $2 } else { print $1 }}' | \
  sed -e 's/:/\ hours\ /' -e 's/ min//' -e 's/$/\ minutes/' | \
  sed 's/^ *//' | sed 's/ /_/g'`
  #echo $var
  logger "HAL - $hname - uptime is $var" ;
  curl -sd "varname=$uptime&value=$var&action=Send" http://$varhost/$varstore
  echo
}

#Load average
function loadav {
  var=`uptime | awk -F'average: ' '{ print $2 }' | sed 's/ //g'`
  #echo $var
  logger "HAL - $hname - load average is $var" ;
  curl -sd "varname=$loadav&value=$var&action=Send" http://$varhost/$varstore
  echo
}

#Network stats
function networks {
  varrx=`/sbin/ifconfig -a | grep packet | grep RX |  head -1 | sed s/"          "//g`
  vartx=`/sbin/ifconfig -a | grep packet | grep TX |  head -1 | sed s/"          "//g`
  #echo $varrx
  #echo $vartx
  varrx=`echo $varrx | awk '{ print $5 }' | sed 's/ //g'`
  vartx=`echo $vartx | awk '{ print $5 }' | sed 's/ //g'`
  logger "HAL - $hname - Ethernet RX is $varrx" ;
  logger "HAL - $hname - Ethernet TX is $vartx" ;
  curl -sd "varname=$tx&value=$vartx&action=Send" http://$varhost/$varstore
  echo
  curl -sd "varname=$rx&value=$varrx&action=Send" http://$varhost/$varstore
  echo
}

#Temperature
function temps {
  var=`/opt/vc/bin/vcgencmd measure_temp | sed s/[^0-9.]*//g`
  #echo $var
  logger "HAL - $hname - temperature is $var" ;
  curl -sd "varname=$temps&value=$var&action=Send" http://$varhost/$varstore
  echo
}

#Procs
function processes {
  var=`ps -ef | wc -l`
  #echo $var
  logger "HAL - $hname - number of procs is $var" ;
  curl -sd "varname=$procs&value=$var&action=Send" http://$varhost/$varstore
  echo
}

#Ping
function pings {
  var=`ping -c1 192.168.100.1 | grep rtt | awk -F'/' '{ print $6 }'`
  #echo $var
  logger "HAL - $hname - pingtime is $var" ;
  curl -sd "varname=$pings&value=$var&action=Send" http://$varhost/$varstore
  echo
}

######################

while true
do

  inits
  maindisk
  #usb1
  #usb2
  uptimes
  temps
  networks
  loadav
  processes
  pings

  sleep 300
done
