#!/usr/bin/python

import urllib3
import re
import smbus
import time

bus = smbus.SMBus(1) # Rev 2 Pi uses 1

DEVICE = 0x24 # Device address (A0-A2)
IODIRA = 0x00 # Pin direction register
OLATA  = 0x14 # Register for outputs
GPIOA  = 0x12 # Register for inputs
http = urllib3.PoolManager()
url = 'http://varhost/varshare/varshow.php'

while True:

  response = http.request('GET', url)

  hash = {'test123':'1'}
  html = response.data
  my_list = html.split("<br>")
  #print my_list

  for element in my_list:
      element = re.sub(r"[\n\t\s]*", "", element)
      x = element.split("||")
      if ( len(x) >= 2 ): 
        varname = x[0]
        vals = x[1]
        y = vals.split("|")
        varval = y[0]
        hash.update({varname:varval})


  # Set all GPA pins as outputs by setting
  bus.write_byte_data(DEVICE,IODIRA,0x00)


  #Relays vals are:
  #128
  #64
  #32
  #16
  #8
  #4
  #2
  #1

  relayval = 255
  if ( hash['out130'] == "1" ):
    relayval = relayval - 128
  if ( hash['out131'] == "1" ):
    relayval = relayval - 64
  if ( hash['out132'] == "1" ):
    relayval = relayval - 32
  if ( hash['out133'] == "1" ):
    relayval = relayval - 16
  if ( hash['out134'] == "1" ):
    relayval = relayval - 8
  if ( hash['out135'] == "1" ):
    relayval = relayval - 4
  if ( hash['out136'] == "1" ):
    relayval = relayval - 2
  if ( hash['out137'] == "1" ):
    relayval = relayval - 1



  # Set output all 8 output bits to 1 note relays are inverted so all ON
  bus.write_byte_data(DEVICE,OLATA,relayval)
  #print(relayval) 

  time.sleep( 2 )
