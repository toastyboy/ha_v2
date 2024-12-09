#!/bin/bash

cd elec_meter 

while true
do

  for i in 1 2 3 4 5 6 7 8 9 10
  do
    mval=`cat 5sec_rate.txt | cut -c 1-7`
    curl -d "varname=elec_5sec&value=$mval&action=Send" http://varhost/varshare/varstore.php
    sleep 5
  done

mval=`cat 1min_rate.txt | cut -c 1-7`
curl -d "varname=elec_1min&value=$mval&action=Send" http://varhost/varshare/varstore.php

mval=`cat 5min_rate.txt | cut -c 1-7`
curl -d "varname=elec_5min&value=$mval&action=Send" http://varhost/varshare/varstore.php

mval=`cat 1hour_rate.txt | cut -c 1-7`
curl -d "varname=elec_1hour&value=$mval&action=Send" http://varhost/varshare/varstore.php

mval=`cat meter_read.txt | cut -c 1-7`
curl -d "varname=elec_meter&value=$mval&action=Send" http://varhost/varshare/varstore.php

mval=`cat meter_read_o.txt | cut -c 1-7`
curl -d "varname=elec_meter_o&value=$mval&action=Send" http://varhost/varshare/varstore.php

mval=`cat day_meter.txt | cut -c 1-7`
curl -d "varname=day_meter&value=$mval&action=Send" http://varhost/varshare/varstore.php


done
