#!/bin/bash

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
fire=`cat index.html | grep "put 0" | awk -F" " '{ print $5 }' | tr -cd [0-9.]`
light=`cat index.html | grep "put 1" | awk -F" " '{ print $5 }' | tr -cd [0-9.]`
rh=`cat index.html | grep "RH" | awk -F"is" '{ print $2 }' | tr -cd [0-9.]`
temps=`cat index.html | grep "Temp" | awk -F"is" '{ print $2 }' | tr -cd [0-9.]`

#echo $fire ; echo $light ; echo $rh ; echo $temps 
curl -sd "varname=darkval&value=$light&action=Send" http://$varhost/$varstore
curl -sd "varname=relhumid&value=$rh&action=Send" http://$varhost/$varstore
curl -sd "varname=temp72&value=$temps&action=Send" http://$varhost/$varstore
curl -sd "varname=garfire&value=$fire&action=Send" http://$varhost/$varstore

rm index.html

sleep 300
done
