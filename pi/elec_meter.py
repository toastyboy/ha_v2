#!/usr/bin/python  
import os

# modified Dec 2024 to use same module for useage and generation meter
import time
from time import sleep
import RPi.GPIO as GPIO  
from datetime import datetime
import os
GPIO.setmode(GPIO.BCM)
global my_list
my_list = list()

myhost = os.uname()[1]
print(myhost)

global meter_read
global meter_read_o
global day_meter
day_meter = 0

if myhost == "clear":
  meter_read = 14609
  meter_read_o = 6703
  print("clear")


if myhost == "solar":
  meter_read = 12385
  print("solar")


if myhost == "clear":
  text_file = open("elec_meter/con_meter_read.txt", "r")
  try:
    meter_read = float(text_file.read())
  except ValueError:
    meter_read = 1
  text_file.close()

  text_file = open("elec_meter/con_meter_read_o.txt", "r")
  try:
    meter_read_o = float(text_file.read())
  except ValueError:
    meter_read_o = 1
  text_file.close()

  text_file = open("elec_meter/con_day_meter.txt", "r")
  try:
    day_meter = float(text_file.read())
  except ValueError:
    day_meter = 1
  text_file.close()

if myhost == "solar":
  text_file = open("elec_meter/gen_meter_read.txt", "r")
  try:
    meter_read = float(text_file.read())
  except ValueError:
    meter_read = 1
  text_file.close()

  text_file = open("elec_meter/gen_day_meter.txt", "r")
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

    #This is economy seven stuff, 00:30 - 07:30 GMT
    #meaning 1:30am - 8:30am during the summer (BST) - code doesn't allow for that.
    day_meter = day_meter + 0.001  # every pulse add 0.001kwh i.e a watt-hour
    nw = datetime.now()
    hrs = nw.hour;mins = nw.minute;
    if myhost == "solar":
       meter_read = meter_read + 0.001 
    elif hrs == 0 and mins <= 30: 
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

    # NOT SURE WE NEED THESE ANYMORE
    # For the 5 second reading, upon pulse detection look back 5 seconds in the array/list
    # and count how many pulses there have been
    target = millis - 5000
    fivesec = sum(i > target for i in my_list) 
    fivesec = fivesec * 12 * 60 / ( 1000 * 1.0 ) 
    #print (fivesec)

    #  Same as for 5 sec reading, just for 3600 secs
    target = millis - 3600000
    onehour = sum(i > target for i in my_list)
    onehour = onehour / ( 1000 * 1.0 )
    #print (onehour)

    # do we update these every pulse or every 5 secs?  probably 5 secs is better?
    # or is this genius?  I.e we aren't updating solar all night when nothing is happening?
    if meter_read  >= 1:
      if myhost == "clear":
        text_file = open("elec_meter/con_meter_read.txt", "w")
      if myhost == "solar":
        text_file = open("elec_meter/gen_meter_read.txt", "w")
      fileval = str(meter_read)
      text_file.write( fileval )
      text_file.close()
    if myhost == "clear":
      if meter_read_o  >= 1:
        text_file = open("elec_meter/con_meter_read_o.txt", "w")
        fileval = str(meter_read_o)
        text_file.write( fileval )
        text_file.close()

    if myhost == "clear":
      text_file = open("elec_meter/con_day_meter.txt", "w")
    if myhost == "solar":
      text_file = open("elec_meter/gen_day_meter.txt", "w")
    fileval = str(day_meter)
    text_file.write( fileval )
    text_file.close()


GPIO.add_event_detect(25, GPIO.RISING, callback=my_callback, bouncetime=300)  

while True:
    sleep(5) # Every 5 secs have a clean up of the list
    millis = int(round(time.time() * 1000))
    target = millis - 3600000 # remove all entries older than an hour
    dessize = sum(i > target for i in my_list)
    del my_list[dessize:]  

    # If the list gets empty, just return an instant rate of 0
    # i.e there have been no pulses in an hour
    if ( len(my_list) > 3 ):
      first = my_list[0]
      second = my_list[3]
      instant = ( 3600000 / ( first - second ) ) / ( 333 * 1.0 )  # this is clever, this one is time between last two recorded pulses
      instant2 = ( 3600000 / ( millis - first ) ) / ( 1000 * 1.0 ) # this is time between last pulse and now...
      if ( instant2 < instant ):   # compare the two and chose the lower, or else a high rate can remain if no further pulses
        instant=instant2 
    else:
      instant = 0

    if (( instant >= 0 ) and ( instant < 32 )): 
      if myhost == "clear": 
        text_file = open("elec_meter/con_5sec_rate.txt", "w")
      if myhost == "solar":
        text_file = open("elec_meter/gen_5sec_rate.txt", "w")
      fileval = str(instant)
      text_file.write( fileval )
      text_file.close()
      print(instant)

    target = millis - 3600000
    onehour = sum(i > target for i in my_list)
    onehour = onehour / ( 1000 * 1.0 )

    if myhost == "clear":
      text_file = open("elec_meter/con_1hour_rate.txt", "w")
    if myhost == "solar":
      text_file = open("elec_meter/gen_1hour_rate.txt", "w")
    fileval = str(onehour)
    text_file.write( fileval )
    text_file.close()

    nw = datetime.now()
    hrs = nw.hour;mins = nw.minute;
    if hrs == 0 and mins <= 1:
      day_meter = 0
