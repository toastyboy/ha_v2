#!/bin/bash

cd elec_meter 
myhost=`hostname`
while true
do
#Consumption
  if [ $myhost == "clear" ]
    then for i in 1 2 3 4 5 6 7 8 9 10
      do
        mval=`cat con_5sec_rate.txt | cut -c 1-7`
        curl -d "varname=elec_5sec&value=$mval&action=\
                 Send" http://varhost/varshare/varstore.php
        sleep 5
      done

  mval=`cat con_1hour_rate.txt | cut -c 1-7`
  curl -d "varname=elec_1hour&value=$mval&action=\
           Send" http://varhost/varshare/varstore.php

  mval=`cat con_meter_read.txt | cut -c 1-7`
  curl -d "varname=elec_meter&value=$mval&action=\
           Send" http://varhost/varshare/varstore.php

  mval=`cat con_meter_read_o.txt | cut -c 1-7`
  curl -d "varname=elec_meter_o&value=$mval&action=\
           Send" http://varhost/varshare/varstore.php

  mval=`cat con_day_meter.txt | cut -c 1-7`
  curl -d "varname=day_meter&value=$mval&action=\
           Send" http://varhost/varshare/varstore.php
  fi

#Solar
  if [ $myhost == "solar" ]
    then for i in 1 2 3 4 5 6 7 8 9 10 11 12
      do
        mval=`cat gen_5sec_rate.txt | cut -c 1-7`
        curl -d "varname=gen_elec_5sec&value=$mval&action=\
                 Send" http://varhost/varshare/varstore.php
        sleep 5
      done

    mval=`cat gen_1hour_rate.txt | cut -c 1-7` # cut first 7 chars
    curl -d "varname=gen_elec_1hour&value=$mval&action=\
             Send" http://varhost/varshare/varstore.php

    mval=`cat gen_meter_read.txt | cut -c 1-7` # cut first 7 chars
    curl -d "varname=gen_elec_meter&value=$mval&action=\
             Send" http://varhost/varshare/varstore.php

    mval=`cat gen_day_meter.txt | cut -c 1-7` # cut first 7 chars
    curl -d "varname=gen_day_meter&value=$mval&action=\
             Send" http://varhost/varshare/varstore.php
  fi
done
