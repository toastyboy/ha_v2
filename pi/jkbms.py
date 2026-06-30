#!/usr/bin/python

import serial
import struct
import re
import time
import requests


ser = serial.Serial(
    port='/dev/ttyUSB0',
    baudrate=115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

url='http://varhost/varshare/varstore.php'

#while True:
#  s = ser.read(80).hex()
#  print (s)

trig = 0
while True:
  s = ser.read(1).hex()
  if ( s == "a5"):
    s = ser.read(5).hex()
    #print (s)
    if ( s == "5a2d821000"):
      s = ser.read(2).hex()
      batt_voltage = int(s, 16) / 100
      print (batt_voltage)

      myobj = {'varname': 'batt_voltage' ,
               'value': batt_voltage,
               'action' : 'Send' }
      x = requests.post(url, data = myobj)

      s = ser.read(2).hex()
      batt_current = int(s, 16) / 10
      if ( batt_current > 3200):
        batt_current = batt_current - 6553.6
      batt_current = round(batt_current, 3) 
      print (batt_current)

      myobj = {'varname': 'batt_current' ,
               'value': batt_current,
               'action' : 'Send' }
      x = requests.post(url, data = myobj)

      s = ser.read(2).hex()
      # reserved

      s = ser.read(2).hex()
      batt_percentage = int(s, 16) 
      print (batt_percentage)

      myobj = {'varname': 'batt_percentage' ,
               'value': batt_percentage,
               'action' : 'Send' }
      x = requests.post(url, data = myobj)

      s = ser.read(2).hex()
      # cell differences

      s = ser.read(2).hex()
      # mosfet temp

      s = ser.read(2).hex()
      batt_temp = int(s, 16) 
      print (batt_temp)

      myobj = {'varname': 'batt_temp' ,
               'value': batt_temp,
               'action' : 'Send' }
      x = requests.post(url, data = myobj)

      time.sleep(10)
#  s2 = re.sub(r'[^a-zA-Z0-9]', '', s)
#  print (s, end=" ")


ser.close()
