#!/bin/bash

####
#Description
#
#This code connects to an arduino uno via http to pull status messages from it
#The messages are:
# 1) temperature in the garden
# 2) humidity 
# 3) light level
# 4) a fire/smoke sensor
#
# The arduino is running arduino/arduino_garden.ino (which is a small webserver really)
####

###########################
#FUNCTIONS
#########

#Variable Initialisation
function inits {
  varhost="varhost" ;
  varstore="varshare/varstore.php" ;
}

######################

while true
  do

  inits
  wget -q 192.168.100.113
  smoke=`cat index.html | grep "put 0" | awk -F" "  '{ print $5 }' | tr -cd [0-9.]`
  light=`cat index.html | grep "put 1" | awk -F" "  '{ print $5 }' | tr -cd [0-9.]`
  rhumi=`cat index.html | grep "RH"    | awk -F"is" '{ print $2 }' | tr -cd [0-9.]`
  temps=`cat index.html | grep "Temp"  | awk -F"is" '{ print $2 }' | tr -cd [0-9.]`

   
  curl -sd "varname=darkval &value=$light&action=Send" http://$varhost/$varstore
  curl -sd "varname=relhumid&value=$rhumi&action=Send" http://$varhost/$varstore
  curl -sd "varname=temp72  &value=$temps&action=Send" http://$varhost/$varstore
  curl -sd "varname=garfire &value=$smoke&action=Send" http://$varhost/$varstore

  rm index.html

  sleep 300
done
