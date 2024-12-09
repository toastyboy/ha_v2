#!/usr/bin/python
import os
import serial 

ser = serial.Serial('/dev/ttyACM0',9600)
s = [0]
last_char = '1'
out_str = '1234'
while True:
	read_serial=ser.readline()
	s[0] = str(int (ser.readline(),16))
	#print s[0]
	#print read_serial
        if ( s[0] != "" ):
          if ( s[0] != last_char ):
            if ( s[0] == "0" ):
              os.system('curl -sd "varname=pin&value=' + out_str +
                        '&action=Send" http://varhost/varshare/varstore.php')
              out_str = '123456'
            out_str += s[0] 
            out_str = out_str[-6:] 
            #print (" hello " , out_str)
            last_char = s[0]

