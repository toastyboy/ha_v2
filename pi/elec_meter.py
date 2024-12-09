#!/usr/bin/python  

import time
from time import sleep
import RPi.GPIO as GPIO  
from datetime import datetime
import os
GPIO.setmode(GPIO.BCM)
global my_list
my_list = list()

day_meter = 0

global meter_read
meter_read = 12316

global meter_read_o
meter_read_o = 5725

millis = int(round(time.time() * 1000))
my_list.insert(0,millis)
sleep(1)
millis = int(round(time.time() * 1000))
my_list.insert(0,millis)
sleep(1)
millis = int(round(time.time() * 1000))
my_list.insert(0,millis)
sleep(1)
millis = int(round(time.time() * 1000))
my_list.insert(0,millis)


text_file = open("elec_meter/meter_read.txt", "r")
try:
  meter_read = float(text_file.read())
except ValueError:
  meter_read = 1
text_file.close()


text_file = open("elec_meter/meter_read_o.txt", "r")
try:
  meter_read_o = float(text_file.read())
except ValueError:
  meter_read_o = 1
text_file.close()

text_file = open("elec_meter/day_meter.txt", "r")
try:
  day_meter = float(text_file.read())
except ValueError:
  day_meter = 1
text_file.close()
  
# GPIO 25 set up as an input, pulled down, connected to 3V3  
GPIO.setup(25, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)  

if not os.path.exists('elec_meter'):
    os.makedirs('elec_meter')
  
# define threaded callback function  
# will run in another thread when our event is detected  
def my_callback(channel): 
    global meter_read
    global meter_read_o
    global my_list
    global day_meter

    day_meter = day_meter + 0.001
    nw = datetime.now()
    hrs = nw.hour;mins = nw.minute;
    if hrs == 0 and mins <= 30: 
       meter_read = meter_read + 0.001
    elif hrs == 7 and mins >= 30: 
       meter_read = meter_read + 0.001
    elif hrs >=8:
       meter_read = meter_read + 0.001
    else:
       meter_read_o = meter_read_o + 0.001

    millis = int(round(time.time() * 1000))
    print (millis)
    print ("rising edge detected on 25")  
    my_list.insert(0,millis) # insert into the bottom 
    #print (my_list)


    target = millis - 5000
    fivesec = sum(i > target for i in my_list) 
    fivesec = fivesec * 12 * 60 / ( 1000 * 1.0 ) 
    #print (fivesec)


    target = millis - 3600000
    onehour = sum(i > target for i in my_list)
    onehour = onehour / ( 1000 * 1.0 )
    #print (onehour)

    #text_file = open("elec_meter/5sec_rate.txt", "w")
    #fileval = str(instant)
    #text_file.write( fileval )
    #text_file.close()

    #text_file = open("elec_meter/1hour_rate.txt", "w")
    #fileval = str(onehour)
    #text_file.write( fileval )
    #text_file.close()

    if meter_read  >= 1:
      text_file = open("elec_meter/meter_read.txt", "w")
      fileval = str(meter_read)
      text_file.write( fileval )
      text_file.close()

    if meter_read_o  >= 1:
      text_file = open("elec_meter/meter_read_o.txt", "w")
      fileval = str(meter_read_o)
      text_file.write( fileval )
      text_file.close()


    text_file = open("elec_meter/day_meter.txt", "w")
    fileval = str(day_meter)
    text_file.write( fileval )
    text_file.close()


GPIO.add_event_detect(25, GPIO.RISING, callback=my_callback, bouncetime=300)  

while True:
    sleep(5) # Every 5 secs have a clean up of the list
    #global my_list
    millis = int(round(time.time() * 1000))
    target = millis - 3600000 # remove all entries older than an hour
    dessize = sum(i > target for i in my_list)
    del my_list[dessize:]  

    #
    first = my_list[0]
    second = my_list[3]
    instant = ( 3600000 / ( first - second ) ) / ( 333 * 1.0 )
    instant2 = ( 3600000 / ( millis - first ) ) / ( 1000 * 1.0 )
    if ( instant2 < instant ):
        instant=instant2 
    print (instant)    


    if (( instant > 0 ) and ( instant < 32 )):  
      text_file = open("elec_meter/5sec_rate.txt", "w")
      fileval = str(instant)
      text_file.write( fileval )
      text_file.close()


    target = millis - 3600000
    onehour = sum(i > target for i in my_list)
    onehour = onehour / ( 1000 * 1.0 )
    #print (onehour)

    text_file = open("elec_meter/1hour_rate.txt", "w")
    fileval = str(onehour)
    text_file.write( fileval )
    text_file.close()

    nw = datetime.now()
    hrs = nw.hour;mins = nw.minute;
    if hrs == 0 and mins <= 1:
      day_meter = 0
