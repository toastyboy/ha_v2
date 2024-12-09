#!/usr/bin/perl


# Note this adaptor is to send notifications by SMS and other 

#########################################################################
#
# Version: 1.0
# Date   : 22/10/2018
#
# Note : Perl modules are required
# Update Feb2024 - added support for NTFY
# 
#
#
# 
#########################################################################

$sleepwait = "5" ;
$url = "http://varhost/varshare" ;
our %hash = ();

#
#SUBROUTINE gethtml
#
# gethtml () - retrieves all centrally stored variables and writes them to a
# hash
# $hash{var_name}[0] is the value
# $hash{var_name}[0], [1], [2] are special values
# $hash{var_name}[3] is the last updated time
#
sub gethtml {
  #get the content of the web page set initial values
  $content = `curl -s "$url/varshow.php"` ;
  #print "$content \n" ;
  @content = split(/<br>/, $content) ;

  #$hash{dan}[0] = "1" ;
  #$hash{dan}[1] = "3" ;
  #$hash{dan}[2] = "5" ;

  foreach $origtext ( @content ) {
    $origtext =~ s/[^a-zA-Z0-9,|.]+//g; #remove funky chars
    #print "$origtext \n" ;
    @values = split(/\|\|/, $origtext) ; # split on || into an array
    #print "$values[0] \n";
    #print "$values[1] \n";
    @subv = split(/\|/, $values[1]) ; # split on | into an array
    #print "\$subv[0] = $subv[0] \n" ;
    if ( $values[0] ne "" ) {
      $hash{$values[0]}[0] =  $subv[0] ;
      $hash{$values[0]}[1] =  $subv[1] ;
      $hash{$values[0]}[2] =  $subv[2] ;
      $hash{$values[0]}[3] =  $subv[3] ;
      $hash{$values[0]}[4] =  $subv[4] ;
      #print "Setting hash value with key $values[0] \n";
    }
  }

  # print entire array
  #for $fam ( keys %hash ) {
  #  print "$fam: ";
  #  for $i ( 0 .. $#{ $hash{$fam} } ) {
  #    print " $i = $hash{$fam}[$i]";
  #    }
  #    print "\n";
  #}
# print "$hash{temp61}[0] \n" ; #Print specific hash entry
}

#
#SUBROUTINE setvals
#
# setvals (var_name) - will compare the value of $var_name with the centrally
# stored value $hash{$var_name}[0] and if different will write is back to the
# repository via http 
#
sub setvals {
  $varname = $_[0] ;
  $epoch = time() ;
  @vals ;
  $vals = $hash{$varname}[0] ;
  if (( $$varname ne $vals ) && ( $$varname ne "" )) {
    #print "$varname is $$varname noteq $vals \n" ;
    $hash{$varname}="$$varname|1|2|3|$epoch" ;
    `curl -sd "varname=$varname&value=$hash{$varname}&action=Send" $url/varstore.php` ;
  }
}


while (1) {

gethtml () ;


  #Send NTFY
  if ( $hash{ntfymsg}[0] == "1" ) {
   $ntfycontent = $hash{ntfymsg}[1] ;

  `curl -sd "$ntfycontent" ntfy.sh/yourmissus_com` ;
 
  $ntfymsg = "0" ;
  setvals( "ntfymsg" ) ;
  }




  #Send Text
  if ( $hash{tc35sms}[0] == "1" ) {
   $smscontent = $hash{tc35sms}[1] ;

   use Device::SerialPort ;
   my $port = Device::SerialPort->new("/dev/ttyAMA0") ;

   $port->baudrate(9600) ;    $port->parity("none") ;
   $port->handshake("none") ; $port->databits(8) ;
   $port->stopbits(1) ;       $port->read_char_time(0) ;
   $port->read_const_time(1) ;


   $port->write( "AT\r" ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS

   $port->write( "AT+CPIN=?\r" ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS

   $port->write( "AT+CREG\r" ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS

   $port->write( "ATT\r" ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS

   $port->write( "AT+CSQ\r" ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS

   $port->write( "AT+CMGF=1\r" ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS

   $port->write( "AT+CMGS=07393715953\r" ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS

   $port->write( "$smscontent\r" ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS

   $port->write( chr(26) ) ;
   select(undef, undef, undef, 0.1); #sleep 250 mS
   $byte=$port->read(64);
   print "$byte \n";
   select(undef, undef, undef, 0.1); #sleep 250 mS


  $tc35sms = "0" ;
  setvals( "tc35sms" ) ;
  }
 
  select(undef, undef, undef, $sleepwait) ; #Sleep before rerunning 

}
