# NOTE: This script contains all the ha subroutines
################################################################################
#
# File: routines.pl
# Author: D. McGrath
# Date: 30.10.2019
#
# Revision: 1.0 - Initial Production Version (30.10.2019)
#
# Revision: 1.1 - (12/11/19) Minor update to fix lack of html update check
#
#
################################################################################
#        1         2         3         4         5         6         7         8
################################################################################

## Contains all subroutines for HA 
#
# Contents:
# +-------+
#
# SUB01: sendsms()
# SUB02: gettempvals ()
# SUB03: writedmx()
# SUB04: gethtml()
# SUB05: setvals()
# SUB06: decodestatus()
# SUB07: setstatusgpio()
# SUB08: initvals()
# SUB09: checktemp()

use Device::SerialPort ; # should we remove these to another routines.pl for 
use IO::Socket::INET ; # reasons of speed?
use Email::Send::SMTP::Gmail ;


## SUB01
### sendsms()
##
## Created: Oct 30, 2019 10:30AM
## Module Purpose: Send an SMS via txtlocal webservice         
## Inputs: 
## Outputs: SMS
## Revision: 1.0 - First production version
##           1.1 - 
##
###
sub sendsms {
($mail,$error)=Email::Send::SMTP::Gmail->new( -smtp=>'smtp.gmail.com',
                                              -login=>'dan.m.mcgrath@gmail.com',
                                              -pass=>'!Zaczegm80713');
 
#print "session error: $error" unless ($email!=-1);
 
$mail->send(-to=>'07393715953@txtlocal.co.uk', 
            -subject=>'Hello!', 
            -body=>'Just testing it');
 
$mail->bye;
}




## SUB02
### gettempvals() 
##
## Created: Oct 30, 2019 10:34AM
## Module Purpose: Returns a value of the nn.nn form of the
## specified file's temperature reading         
## Inputs: Input the w1_bus_master ID
## Outputs: 
## Revision: 1.0 - First production version
##           1.1 - 
##
###
sub gettempvals {
  $file = "/sys/devices/w1_bus_master1/$_[0]/w1_slave" ;
  if ( -e $file ) {
    $temp = `cat $file` ;
    $temp = substr $temp, 69, 5 ; # Pull out temperature from other guff
    $temp = $temp / 1000 ;
    if ( $temp > -30 && $temp < 99 ) {
      return $temp ;
    }
    else {
      return ;
    }
  }
  else {
    return ;
  }
}




## SUB03
### writedmx() 
##
## Created: Oct 30, 2019 10:38AM
## Module Purpose: Set a DMX channel to a value         
## Inputs: Input the DMX channel and intensity value
## Outputs: 
## Revision: 1.0 - First production version
##           1.1 - 
##
###
sub writedmx {

  $min_intensity = 70 ;
  my $port = Device::SerialPort->new("/dev/ttyAMA0") ;

  $port->baudrate(9600) ;    $port->parity("none") ;
  $port->handshake("none") ; $port->databits(8) ;
  $port->stopbits(1) ;       $port->read_char_time(0) ;
  $port->read_const_time(1) ;

  $channel   = $_[0] ;
  $intensity = $_[1] ;

  if ( $intensity > 255 ) { $intensity = 0 } ;
  if ( $intensity < $min_intensity ) { $intensity = 0 } ;

  $port->write( pack "C", $channel ) ;
  $port->write( pack "C", $set_intensity ) ;
  select(undef, undef, undef, 0.05) ; #Sleeep 50 mS

  $port->close() ;
}




## SUB04
### gethtml() 
##
## Created: Oct 30, 2019 10:44AMA
## Module Purpose: Retrieves all centrally stored vars and write 
## them to a hash:
## $hash{var_name}[0] is the value
## $hash{var_name}[0] , [1] & [2] are special values
## $hash{var_name}[3] is the last updated time
##       
## Inputs: None
## Outputs: A hash entitled %hash
## Revision: 1.0 - First production version
##           1.1 - Added option to pass a search term when calling 15/3/24
##           1.2
###
sub gethtml {
  $searchterm = $_[0] ;

  undef %{$hash} ; # Clear %hash contents
  $content = `curl -s "$url/varshow.php?search=$searchterm"` ; # Get web page

  @content = split(/<br>/, $content) ;
  # print "@content \n";
  foreach $origtext ( @content ) {
    # Each line looks like varname||value|1|2|3|epochtime
    # I.e.  temp71||7.687|1|2|3|1573726266
    # print "$origtext \n" ;  
    @values = split(/\|\|/, $origtext) ; # Split on "||" into an array
    @subv = split(/\|/, $values[1]) ; # Split on "|" into an array
    $index = $values[0] ; 
    $index =~ s/\s+//g ; # Remove whitespace
    $hash{$index} = [ $subv[0], $subv[1], $subv[2], $subv[3], $subv[4] ] ;
    # print "$hash{temp61}[0]  ... $values[0]$index$index ... $subv[0]  \n" ;
    # while ( ($k,$v) = each %hash ) { print "$k => $v\n"; } # print hash
  }
}




## SUB05
### setvals() 
##
## Created: Oct 30, 2019 10:55AM
## Module Purpose: Will compare the value of $var_name with the centrally
## stored value $hash{$var_name}[0] and if different will write it back to the
## repository via http 
##       
## Inputs: 
## Outputs: 
## Revision: 1.0 - First production version
##           1.1 - 
##
###
sub setvals {
  $varname = $_[0] ; 
  #print "Variable name (\$varname) is $varname \n" ;
  #print "Variable value (\$varname) is $$varname \n" ;
  $epoch = time() ;
  $currentval = $hash{$varname}[0] ; 
  #print "Current stored value (\$currentval) is $currentval \n";
  if (( $$varname ne $currentval ) && ( $$varname ne "" )) {
    #print "$varname is $$varname noteq $currentval \n" ;
    $hash{$varname} = "$$varname" ;
    `curl -sd "varname=$varname&value=$hash{$varname}&action=Send" $url/varstore.php` ;
  }
}




## SUB06
### decodestatus() 
##
## Created: Oct 30, 2019 10:58AM
## Module Purpose: Galaxy output decoding
##
##       
## Inputs: 
## Outputs: 
## Revision: 1.0 - First production version
##           1.1 - 
##
###
sub decodestatus {
  $varname = $_[0] ;
  $varout = $varname =~ s/\_//r ;
  #print "$varout \n";
  if ( $$varname =~ /^07/ ) {
    $$varout = "O" ; $set++ ;
  }
  else {
    $$varout = "C" ; $set++ ;
  }
}




## SUB07
### setstatusgpio() 
##
## Created: Oct 30, 2019 11:00AM
## Module Purpose: Write to GPIO outputs
##
##       
## Inputs: 
## Outputs: 
## Revision: 1.0 - First production version
##           1.1 - 
##
###
sub setstatusgpio {

  if (( $varname eq "out_65" ) && ( $vals[0] == "1" )) {
    `echo 0 > /sys/class/gpio/gpio2/value`;
  } 
  if (( $varname eq "out_65" ) && ( $vals[0] == "0" )) {
    `echo 1 > /sys/class/gpio/gpio2/value`;
  }

  if (( $varname eq "out_66" ) && ( $vals[0] == "1" )) {
    `echo 0 > /sys/class/gpio/gpio3/value`;
  }
  if (( $varname eq "out_66" ) && ( $vals[0] == "0" )) {
    `echo 1 > /sys/class/gpio/gpio3/value`;
  }

  if (( $varname eq "out_67" ) && ( $vals[0] == "1" )) {
    `echo 0 > /sys/class/gpio/gpio4/value`;
  }
  if (( $varname eq "out_67" ) && ( $vals[0] == "0" )) {
    `echo 1 > /sys/class/gpio/gpio4/value`;
  }

  if (( $varname eq "out_68" ) && ( $vals[0] == "1" )) {
    `echo 0 > /sys/class/gpio/gpio14/value`;
  }
  if (( $varname eq "out_68" ) && ( $vals[0] == "0" )) {
    `echo 1 > /sys/class/gpio/gpio14/value`;
  }

  if (( $varname eq "out_69" ) && ( $vals[0] == "1" )) {
    `echo 0 > /sys/class/gpio/gpio15/value`;
  }
  if (( $varname eq "out_69" ) && ( $vals[0] == "0" )) {
    `echo 1 > /sys/class/gpio/gpio15/value`;
  }

  if (( $varname eq "out_70" ) && ( $vals[0] == "1" )) {
    `echo 0 > /sys/class/gpio/gpio17/value`;
  }
  if (( $varname eq "out_70" ) && ( $vals[0] == "0" )) {
    `echo 1 > /sys/class/gpio/gpio17/value`;
  }

  if (( $varname eq "out_71" ) && ( $vals[0] == "1" )) {
    `echo 0 > /sys/class/gpio/gpio18/value`;
  }
  if (( $varname eq "out_71" ) && ( $vals[0] == "0" )) {
    `echo 1 > /sys/class/gpio/gpio18/value`;
  }

  if (( $varname eq "out_72" ) && ( $vals[0] == "1" )) {
    `echo 0 > /sys/class/gpio/gpio27/value`;
  }
  if (( $varname eq "out_72" ) && ( $vals[0] == "0" )) {
    `echo 1 > /sys/class/gpio/gpio27/value`;
  }

  #gpio2  - garage lights
  #gpio3  - recep light
  #gpio4  - garage strobe
  #gpio14 - garage siren
  #gpio15
  #gpio17 - garage rear door
  #gpio18 - bottom locks (rear)
  #gpio27 - bottom locks (mid)

  $$varname = $vals[0] ; #update fixed var value
}




## SUB08
### initvals() 
##
## Created: Oct 30, 2019 11:04AM
## Module Purpose: 
##
##       
## Inputs: 
## Outputs: 
## Revision: 1.0 - First production version
##           1.1 - 
##
###
sub initvals {

}

## SUB09
### checktemp()
##
## Created: Mar15, 2024 12:04AM
## Module Purpose:
## Sometimes DS1820 return false peaks and troughs, but they seem
## to be certain values 
## call as checktem ( varname, temp_variance)

sub checktemp {
  $tempcheck = $_[0] ;
  $variance = $_[1] ;

  if ( @{$tempcheck} == "0" ) { @{$tempcheck} = ( $$tempcheck ) } #init array 

  unshift(@{$tempcheck}, $$tempcheck); #add current val to array
  if ( $#{$tempcheck} > 4 ) { pop(@{$tempcheck}) } #keep size to 5

  #print "$tempcheck $$tempcheck @{$tempcheck} \n";

  if ( grep { $_ eq $$tempcheck } @badtemps )  {
    return 1 ;
  }
  elsif ( abs(sum(@{$tempcheck})/@{$tempcheck} - $$tempcheck) > $variance ) { 
    return 1 ;
  }
  else {
    return 0 ;
  }
}



##
##
# KEEP THIS LAST LINE (below)
##
1; # Need to end with a true value
