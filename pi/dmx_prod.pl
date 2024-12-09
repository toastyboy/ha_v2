#!/usr/bin/perl

# Note this adaptor is for DMX RS232 Module 

#########################################################################
#
# Version: 1.0
# Date   : 14/10/2018
#
# Note : Perl modules are required
# 25/11/20 - updated to support extra 4 channels 21-24
#
#
# 
#########################################################################

use Device::SerialPort ;

$inc_up = 5 ;
$inc_down = 5 ;
$min_intensity = 70 ;
$url = "http://varhost/varshare" ;
$epoch = time() ;


# foreach (sort keys %myhash) {
# print "$_ : $myhash{$_}\n";
# }
# print "out08  $hash{out08} \n";


#Set up serial port
$port = Device::SerialPort->new("/dev/ttyAMA0") ;
$port->baudrate(9600) ;    $port->parity("none") ;
$port->handshake("none") ; $port->databits(8) ;
$port->stopbits(1) ;       $port->read_char_time(0) ;
$port->read_const_time(1) ;


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
    $hash{$varname}="$$varname" ;
    `curl -sd "varname=$varname&value=$hash{$varname}&action=Send" $url/varstore.php` ;
  }
}


# 
#SUBROUTINE writedmx
# 
sub writedmx {
  $port->write( pack "C", $channel ) ;
  $port->write( pack "C", $set_intensity ) ;
  system( "logger 'HAL - dmx_lighting_set $channel - $set_intensity' ");
  $$varname = $set_intensity ;
  #print "$channel , $set_intensity \n";
}


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
 #print "$hash{dmx7}[0] \n" ; #Print specific hash entry
}


#
#SUBROUTINE comparevals
#
sub comparevals {
  $varname = $_[0] ;
  $channel = $varname ; $channel =~ s/dmx// ;
  $vals = $hash{$varname}[0] ;
  #print "$vals -- $$varname -- $varname \n" ;
  if ( $$varname ne $vals ) {
    print "$varname is $$varname noteq $vals \n" ;
    $oldval = $$varname ;
    $newval = $vals ;
    if (( $newval - $oldval ) >= $inc_up ) {
          $set_intensity = $oldval + $inc_up ;
          if ( $set_intensity < $min_intensity ) {
             $set_intensity = $min_intensity ;
          }
       writedmx () ;
    }
    if (( $oldval - $newval ) >= $inc_down ) {
          $set_intensity = $oldval - $inc_down ;
          writedmx () ;
    }
  }
}


gethtml () ;

# Set original values to be web values
$n=1 ;
while ( $n <= 24 ) 
{
  $dmxvar = "dmx$n" ;
  $$dmxvar = $hash{$dmxvar}[0] ;
  $n = $n + 1 ; 
}


while (true) {

  gethtml () ;

  for (0..19) {
    comparevals ("dmx1") ;
    comparevals ("dmx2") ;
    comparevals ("dmx3") ;
    comparevals ("dmx4") ;
    comparevals ("dmx5") ;
    comparevals ("dmx6") ;
    comparevals ("dmx7") ;
    comparevals ("dmx8") ;
    comparevals ("dmx9") ;
    comparevals ("dmx10") ;
    comparevals ("dmx11") ;
    comparevals ("dmx12") ;
    comparevals ("dmx13") ;
    comparevals ("dmx14") ;
    comparevals ("dmx15") ;
    comparevals ("dmx16") ;
    comparevals ("dmx17") ;
    comparevals ("dmx18") ;
    comparevals ("dmx19") ;
    comparevals ("dmx20") ;
    comparevals ("dmx21") ;
    comparevals ("dmx22") ;
    comparevals ("dmx23") ;
    comparevals ("dmx24") ;

    select(undef, undef, undef, 0.05) ; #Sleeep 50 mS
    $count++ ;
    if ( $count eq "100" )
    {
      $dmx_pink_lastran = $epoch ;
      setvals( "dmx_pink_lastran" ) ;
      $count = 0 ;
    }

  }
}
