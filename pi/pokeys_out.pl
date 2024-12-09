#!/usr/bin/perl
# Note this adaptor is to process basic I/O logic
#exit;
#########################################################################
#
# Version: 1.0
# Date   : 22/10/2018
#
# Note : Perl modules are required
#
#
#
#
#########################################################################

$sleepwait = "0.7" ;
$url = "http://varhost/varshare" ;
our %hash = ();

use IO::Socket::INET;
$socket = new IO::Socket::INET (
  PeerHost => '192.168.100.151',
  PeerPort => '20055',
  Proto => 'tcp',
);

$b7_raw = 0 ;
$direct = "up" ;
$| = 1 ; # auto-flush on socket

$b1 = "bb" ; # don't change
$b2 = "40" ; # to set outputs
$b3 = "00" ;
$b4 = "00" ;
$b5 = "00" ; # no value for item40
$b6 = "00" ; # no value for item40



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
    $hash{$varname}="$$varname" ;
    `curl -sd "varname=$varname&value=$hash{$varname}&action=Send" $url/varstore.php` ;
  }
}


while () {
  gethtml () ;
  $epoch = time();
  $tensecs = $epoch - 10 ;
  $onemin  = $epoch - 60 ;
  $tenmins = $epoch - 600 ;


  @varnames = ( "out1"  , "out2"  , "out3"  , "out4"  ,
                "out5"  , "out6"  , "out7"  , "out8"  ,
                "out9"  , "out10" , "out11" , "out12" ,
                "out13" , "out14" , "out15" , "out16"   ) ;

  foreach $varname (@varnames) {

   if ( $hash{$varname}[4] > $tensecs ) { 
    $b3 = $varname ; $b3 =~ s/out// ; #varname 
    $b4 = $hash{$varname}[0] ; #value
    if ( $b4 eq "1" ) { $b4 = "01" ; }
    elsif ( $b4 eq "0" ) { $b4 = "00" ; } 

    $b3 = $b3 - 1 ; 
    $b3 = sprintf( "%X", $b3 ) ;

    if ( $direct eq "up" ) { $b7_raw = $b7_raw + 1 ; }
    elsif ( $direct eq "down" ) { $b7_raw = $b7_raw - 1 ; }
    if ( $b7_raw == 255 ) { $direct = "down" ; } 
    elsif ( $b7_raw == 0 ) { $direct = "up" ; }

    $b7 = sprintf ( "%X", $b7_raw ) ;
    $sumbs = hex($b1)+hex($b2)+hex($b3)+hex($b4)+hex($b5)+hex($b6)+hex($b7) ; 
                    # checksum mod 0x100 sum b1-7
  
    $b3 = sprintf("%2s", $b3 ) ;  $b3=~ tr/ /0/ ; #pad with zeros up to 2 chars
    $b7 = sprintf("%2s", $b7 ) ;  $b7=~ tr/ /0/ ; #pad with zeros up to 2 chars

    $b8 = $sumbs % 256 ;
    $b8 = sprintf("%X", $b8) ;
    $b8 = sprintf("%2s", $b8 ) ; $b8=~ tr/ /0/ ; #pad with zeros up to 2 chars
    #print "$b3 , $b7, $b8 \n" ;
    $req = pack ("H*" , "$b1$b2$b3$b4$b5$b6$b7$b8" . "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
   
    $socket = new IO::Socket::INET (
      PeerHost => '192.168.100.151',
      PeerPort => '20055',
      Proto => 'tcp',
    );

 
    $size = $socket->send("$req");
    $dan = unpack ("H*" , $req );
    #shutdown($socket, 1);

    # receive a response of up to 1024 characters from server
    $response = "";
    $socket->recv($response, 1024);
    $dan=unpack ( "H*", $response );
    $socket->close() ;
    } 
  }
  select(undef, undef, undef, $sleepwait); #sleeep 250 mS

  $count++ ;
  if ( $count eq "100" )
  {
    $pokeys_out_blue_lastran = $epoch ;
    setvals( "pokeys_out_blue_lastran" ) ;
    $count = 0 ;
  }

}
