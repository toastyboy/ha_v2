#!/usr/bin/perl

################################################################################
#
# File: temps.pl
# Author: D. McGrath
# Date: 30.10.2019
#
# Note : Perl modules are required
# Note2 : Calls gethtml() and setvals() routines
#
# This script provides a method to obtain the locally held DS1820 temperature
# sensor values and write them to the web service using varstore.php
#
# Revision: 1.0 - Initial Production Version (30.10.2019)
# Revision: 1.2 - Updated to validate temps and various improvements 15/3/24
#
#
################################################################################
#        1         2         3         4         5         6         7         8
################################################################################

use List::Util qw(sum);
require "./routines.pl" ;

my $hostname = `hostname` ; chomp ($hostname) ;
our %hash ; 

our @badtemps = ( 0.062, 25, 32 ) ; # list of spurious ds1820 vals returned

$url = "http://varhost/varshare" ;
$epoch = time() ;

while (true) 
{
  gethtml (temp) ;

  if ( $hostname eq "clear" ) 
  {
    $temp51 = gettempvals ("28-00000536048f") ; # Basement
    $temp52 = gettempvals ("28-000005353b14") ; # Gnd floor
    $temp53 = gettempvals ("28-00000534af25") ; # First floor
    if ( checktemp ( "temp51" , "5" ) eq "0" ) { setvals ("temp51") }
    if ( checktemp ( "temp52" , "5" ) eq "0" ) { setvals ("temp52") }
    if ( checktemp ( "temp53" , "5" ) eq "0" ) { setvals ("temp53") }
  }

  if ( $hostname eq "black" ) {
    $temp1  = gettempvals ("28-00000466d3df") ; # Thermal store Tank (2)
    $temp2  = gettempvals ("28-00000466e04b") ; # Thermal store Tank (7)
    $temp3  = gettempvals ("28-00000466f0ae") ; # Thermal store Tank (6)
    $temp4  = gettempvals ("28-00000466f1ed") ; # Thermal store Tank (3)
    $temp5  = gettempvals ("28-00000466cc8e") ; # Thermal store Tank (5)
    $temp6  = gettempvals ("28-00000466cd20") ; # Thermal store Tank (8) TOP
    $temp7  = gettempvals ("28-00000466db69") ; # Thermal store Tank (1) BOTTOM
    $temp8  = gettempvals ("28-00000466dda7") ; # Thermal store Tank (4)
    $temp9  = gettempvals ("28-00000466e6c2") ; # Thermal store Tank (Heat-Ex)
    $temp10 = gettempvals ("28-00000466f31d") ; # Thermal store Tank (Flow)
    if ( checktemp ( "temp1" ,  "5" ) eq "0" ) { setvals ("temp1") }
    if ( checktemp ( "temp2" ,  "5" ) eq "0" ) { setvals ("temp2") }
    if ( checktemp ( "temp3" ,  "5" ) eq "0" ) { setvals ("temp3") }
    if ( checktemp ( "temp4" ,  "5" ) eq "0" ) { setvals ("temp4") }
    if ( checktemp ( "temp5" ,  "5" ) eq "0" ) { setvals ("temp5") }
    if ( checktemp ( "temp6" ,  "5" ) eq "0" ) { setvals ("temp6") }
    if ( checktemp ( "temp7" ,  "5" ) eq "0" ) { setvals ("temp7") }
    if ( checktemp ( "temp8" ,  "5" ) eq "0" ) { setvals ("temp8") }
    if ( checktemp ( "temp9" ,  "5" ) eq "0" ) { setvals ("temp9") }
    if ( checktemp ( "temp10" , "5" ) eq "0" ) { setvals ("temp10") }
  }

  if ( $hostname eq "shedpi" ) {
    $temp61 = gettempvals ("28-00000535bdc1") ; # Shed internal
    $temp62 = gettempvals ("28-00000527274d") ; # Shed external
    if ( checktemp ( "temp61" , "10" ) eq "0" ) { setvals ("temp61") }
    if ( checktemp ( "temp62" , "10" ) eq "0" ) { setvals ("temp62") }
  }

  if ( $hostname eq "solar" ) {
    $temp71 = gettempvals ("28-0000053518c8") ; # Kens
    if ( checktemp ( "temp71" , "5" ) eq "0" ) { setvals ("temp71") }
  }

  if ( $hostname eq "boiler" ) {

    ## Reboot of DS1820s if not listed, note DS1820 connected to gpio pin 17
    $numds1820 = `ls -1 /sys/devices/w1_bus_master1/ | grep "28-" | wc -l` ;
    if ( $numds1820 != 10 ) { 
      `/usr/bin/gpio -g write 17 0` ;
      sleep 3 ; 
      `/usr/bin/gpio -g write 17 1` ; 
    }

    $temp11 = gettempvals ("28-3ce1e3811ed1") ; sleep 1 ;
    $temp12 = gettempvals ("28-3ce1e3812004") ; sleep 1 ; 
    $temp13 = gettempvals ("28-3ce1e3812ad9") ; sleep 1 ; 
    $temp14 = gettempvals ("28-3ce1e3814c32") ; sleep 1 ;
    $temp15 = gettempvals ("28-3ce1e38187a0") ; sleep 1 ;
    $temp16 = gettempvals ("28-3ce1e381ad5e") ; sleep 1 ;
    $temp17 = gettempvals ("28-3ce1e381b522") ; sleep 1 ;
    $temp18 = gettempvals ("28-3ce1e381b745") ; sleep 1 ;
    $temp19 = gettempvals ("28-3ce1e381b8d7") ; sleep 1 ;
    $temp20 = gettempvals ("28-3ce1e381d8a2") ; sleep 1 ; 

    if ( checktemp ( "temp11" , "35" ) eq "0" ) { setvals ("temp11") }
    if ( checktemp ( "temp12" , "35" ) eq "0" ) { setvals ("temp12") }
    if ( checktemp ( "temp13" , "35" ) eq "0" ) { setvals ("temp13") }
    if ( checktemp ( "temp14" , "35" ) eq "0" ) { setvals ("temp14") }
    if ( checktemp ( "temp15" , "35" ) eq "0" ) { setvals ("temp15") }
    if ( checktemp ( "temp16" , "35" ) eq "0" ) { setvals ("temp16") }
    if ( checktemp ( "temp17" , "35" ) eq "0" ) { setvals ("temp17") }
    if ( checktemp ( "temp18" , "35" ) eq "0" ) { setvals ("temp18") }
    if ( checktemp ( "temp19" , "35" ) eq "0" ) { setvals ("temp19") }
    if ( checktemp ( "temp20" , "35" ) eq "0" ) { setvals ("temp20") }
  }

  if ( $hostname eq "pizero" ) {
    $temp54 = gettempvals ("28-000005350fa5") ; # Joshs Room
    if ( checktemp ( "temp54" , "5" ) eq "0" ) { setvals ("temp54") }
  }

sleep 30
}

