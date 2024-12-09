#!/bin/bash

host=`hostname`
url="http://varhost/varshare/"


###Run these scripts each time this script runs

./pingreboot.bash


### scripts to monitor for

#PINK
if  [ `hostname` == "pink" ] ;               
then array=( "dmx_prod.pl" "vitals.bash" ) 
fi

#BLACK
if  [ `hostname` == "black" ] ;
then array=( "galaxy.pl" "temps.pl" "vitals.bash" )
fi

#CLEAR
if  [ `hostname` == "clear" ] ;
then array=( "process.py" "elec_meter.py" "update_meter.bash" \
             "temps.pl" "vitals.bash" )
fi

#BLUE
if  [ `hostname` == "blue" ] ;
then array=( "pokeys_out.pl" "process.py" "vitals.bash" )
fi

#BUTLER
if  [ `hostname` == "butler" ] ; 
then array=( "doorbell.pl" "process.py" "pokeys_in.pl" "speedtest.bash" \
             "vitals.bash" )
fi

#BOILER
if  [ `hostname` == "boiler" ] ;
then array=( "temps.pl" "vitals.bash" )
fi

#NAS
if  [ `hostname` == "nas" ] ;
then array=( "process.pl" "logic.pl" "vitals.bash" "heatmon.pl")
fi

#SHED
if  [ `hostname` == "shed" ] ;
then array=( "process.pl" "temps.pl" "vitals.bash" )
fi

#PI ZERO
if  [ `hostname` == "pizero" ] ;
then array=( "process.pl" "vitals.bash" "temps.pl" )
fi

# SOLAR
if  [ `hostname` == "solar" ] ;
then array=( "vitals.bash" "temps.pl" "elec_meter.py" "update_meter.bash" )
fi

#KEYPAD
if  [ `hostname` == "keypad" ] ;
then array=( "vitals.bash" "process.pl" "python_keypad.py" )
fi

#GARAGEPINK
if  [ `hostname` == "garagepink" ] ;
then array=( "process.pl" "vitals.bash" "arduino_www.bash" )
fi

#SMSHOST - - - GARAGEPI
if  [ `hostname` == "smshost" ] ;
then array=( "process_sms.pl" )
fi


#DNShost?

#NAGIOS and other clusterpis





#Actual work done here
vars=`curl -s $url/varshow.php`
varlines=`echo $vars | tr -d " \t\n\r" | sed s/"<br>"/"\n"/g` 

for i in $varlines
do
  #echo $i
  varname=`echo $i | awk -F"\|\|" '{ print $1 }'`
  varval=`echo $i | awk -F'\|\|' '{ print $2 }' | awk -F"\|" '{ print $1 }'`

  #echo "name "$varname ; echo "Val "$varval
  declare $varname=$varval  # creates a variable with the name of $varname
done

#echo $vars

## End up with 
# dmx10||0||||1585588429
# dmx11||1||||1585588430
# dmx12||1||||1585588430
#
# $dmx10="0" ; $dmx11="1" etc.....


for scriptname in "${array[@]}" 
do

  scriptnamesnip=`echo $scriptname | awk -F"." '{ print $1 }'`
  #echo $scriptnamesnip
  runvar=$scriptnamesnip"_"$host
  #echo $runvar
  #echo ${!runvar} # varable called scriptname (minus .suffix) _ hostname
                   # contains RUN|STOP|RESTART 
  
  if [ -z "${!runvar}" ] # if no remote variable exists, create one
  then
    # echo "no remote var $runvar"
    curl -sd "varname=$runvar&value=RUN&action=Send" $url/varstore.php    
  fi


  if [ "${!runvar}" == "RUN" ]
  then 
    #echo "$scriptname is RUN"
    ps -ef | grep $scriptname | grep -v grep >> /dev/null
    if [ $? == 1 ]
    then  
      nohup ./$scriptname &
    fi

  elif [ "${!runvar}" == "RESTART" ]
  then
    #echo "$scriptname is RESTART"
    ps -ef | grep $scriptname | grep -v grep >> /dev/null
    if [ $? == 0 ]
    then
      ps aux | grep -ie $scriptname | grep -v grep | \
               awk '{ print $2 }' | xargs kill -9
      sleep 1 
    fi
    nohup ./$scriptname &
    curl -sd "varname=$runvar&value=RUN&action=Send" $url/varstore.php 

  elif [ "${!runvar}" == "STOP" ]
  then
    #echo "$scriptname is STOP"
    ps -ef | grep $scriptname | grep -v grep >> /dev/null
    if [ $? == 0 ]
    then 
      ps aux | grep -ie $scriptname | grep -v grep | \
               awk '{ print $2 }' | xargs kill -9 
    fi
  fi
done 
