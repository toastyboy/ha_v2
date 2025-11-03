#!/usr/bin/python

import serial
import re
import requests
import time


#set up serial port
ser = serial.Serial(
    port='/dev/ttyUSB0',\
    baudrate=19200,\
    parity=serial.PARITY_NONE,\
    stopbits=serial.STOPBITS_ONE,\
    bytesize=serial.EIGHTBITS,\
        timeout=0)

print("connected to: " + ser.portstr)

url='http://varhost/varshare/varstore.php'
m=0
n=0
p=0
q=0
max=10

#watchdog timers 
time1 = time.time()
time2 = time1
time3 = time1
time4 = time1
time5 = time1


while True:
     cc=str(ser.readline())
     print(cc)
     print("--")
     if cc.startswith("b'VPV\\t"):
       try:
         time2 = time.time() 
         print(time2)  
         info, value = cc.split("\\t", maxsplit=2)
         solarvolts = re.sub(r'[^0-9]', '', value)
         solarvolts = int(solarvolts)
         solarvolts = solarvolts / 1000       
         print ("solar voltage" , solarvolts)

         if ( m > max ):
           myobj = {'varname': 'mppt1_solarvolts' ,
                    'value': solarvolts,
                    'action' : 'Send' }
           x = requests.post(url, data = myobj)
           m=0
       except:
         print ("Out of bound VPV!")


     elif cc.startswith("b'PPV\\t"):
       try:
         time3 = time.time()
         info, value = cc.split("\\t", maxsplit=2)
         solarpower = re.sub(r'[^0-9]', '', value)
         solarpower = int(solarpower)
         #solarpower = solarpower / 1000
         print ("solar power" , solarpower)

         if ( n > max):
           myobj = {'varname': 'mppt1_solarpower' ,
                    'value': solarpower,
                    'action' : 'Send' }
           x = requests.post(url, data = myobj)
           n=0
       except:
         print ("Out of bound PPV!") 

     elif cc.startswith("b'V\\t"):
       try:
         time4 = time.time()
         info, value = cc.split("\\t", maxsplit=2)
         chargevolts = re.sub(r'[^0-9]', '', value)
         chargevolts = int(chargevolts)
         chargevolts = chargevolts / 1000
         print ("MPPT charge voltage VPV" , chargevolts)

         if ( p > max):
           myobj = {'varname': 'mppt1_chargevolts' ,
                    'value': chargevolts,
                    'action' : 'Send' }
           x = requests.post(url, data = myobj)
           p=0
       except:
         print ("Out of bound V!") 

     elif cc.startswith("b'I\\t"):
       try:
         time5 = time.time()
         info, value = cc.split("\\t", maxsplit=2)
         chargecurrent = re.sub(r'[^0-9]', '', value)
         chargecurrent = int(chargecurrent)
         chargecurrent = chargecurrent / 1000
         print ("charge current" , chargecurrent)

         if ( q > max):
           myobj = {'varname': 'mppt1_chargecurrent' ,
                    'value': chargecurrent,
                    'action' : 'Send' }
           x = requests.post(url, data = myobj)
           q=0
       except:
         print ("Out of bound I!") 
     m=m+1
     n=n+1
     p=p+1
     q=q+1
     if ( time.time() > (time2 + 60) ):
       print("No action, quitting")
       quit()
     if ( time.time() > (time3 + 60) ):
       print("No action, quitting")
       quit()
     if ( time.time() > (time4 + 60) ):
       print("No action, quitting")
       quit()
     if ( time.time() > (time5 + 60) ):
       print("No action, quitting")
       quit()

     time.sleep(0.1)
