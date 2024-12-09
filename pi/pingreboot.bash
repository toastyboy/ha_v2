#!/bin/bash

url="http://varhost/varshare/"


isrunning=`ps -ef | grep "pingreboot" | wc -l`
if [ $isrunning -gt "3" ]
  then exit
fi

ping -c3 varhost > /dev/null

if [ $? != "0" ]
  then sleep 300 
  ping -c3 varhost > /dev/null
  if [ $? != "0" ]
    then echo "reboot" ; sleep 300 ; sudo reboot
  fi
fi


#check if you can find variable "varchecker" with value "999"

vars=`curl -s $url/varshownew.php?search="varchecker"`
echo $vars | grep "999" >/dev/null

if [ $? != "0" ]
  then sleep 300
  vars=`curl -s $url/varshownew.php?search="varchecker"`
  echo $vars | grep "999"
  if [ $? != "0" ]
    then echo "reboot" ; sleep 300 ; sudo reboot
  fi
fi


