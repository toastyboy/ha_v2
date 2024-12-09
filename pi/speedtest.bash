#!/bin/bash

while true
do
#Server ID,Sponsor,Server Name,Timestamp,Distance,Ping,Download,Upload,Share,IP Address

speedtest-cli --csv > speedtest.txt

varhost="varhost"
hostname=`hostname`
pingtime=`cat speedtest.txt | awk -F"," '{ print $6 }'`
download=`cat speedtest.txt | awk -F"," '{ print $7 }'`
upload=`cat speedtest.txt | awk -F"," '{ print $8 }'`

pingname=$hostname"_pingtime"
downname=$hostname"_download"
upname=$hostname"_upload"

echo $pingtime
echo $download
echo $upload

curl -d "varname=$pingname&value=$pingtime&action=Send" http://$varhost/varshare/varstore.php
curl -d "varname=$downname&value=$download&action=Send" http://$varhost/varshare/varstore.php
curl -d "varname=$upname&value=$upload&action=Send" http://$varhost/varshare/varstore.php


rm speedtest.txt

sleep 3600
done
