#!/usr/bin/perl
# Note this adaptor is to process basic I/O logic 
#exit ;
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

$sleepwait = "0.5" ;
$url = "http://varhost/varshare" ;
our %hash = ();


use IO::Socket::INET;
$socket = new IO::Socket::INET (
  PeerHost => '192.168.100.150',
  PeerPort => '20055',
  Proto => 'tcp',
);

$b7_raw = 0 ; 
$direct = "up" ;
$| = 1 ; # auto-flush on socket

$b1 = "bb" ; # don't change
$b2 = "cc" ; # cc to bulk read outputs
$b3 = "00" ;
$b4 = "00" ;
$b5 = "00" ; # no value for item40
$b6 = "00" ; # no value for item40

$b3 = sprintf("%2s", $b3 ) ;  $b3=~ tr/ /0/ ; #pad with zeros up to 2 chars


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

gethtml() ;

  if    ( $direct eq "up" )   { $b7_raw = $b7_raw + 1 ;} 
  elsif ( $direct eq "down" ) { $b7_raw = $b7_raw - 1 ; } 
  if    ( $b7_raw == 255 )    { $direct = "down" ; } 
  elsif ( $b7_raw == 0 )      { $direct = "up" ; } 

  $b7 = sprintf ( "%X", $b7_raw ) ;
  $b7 = sprintf("%2s", $b7 ) ; $b7=~ tr/ /0/ ; #pad with zeros up to 2 chars
  print "$b7_raw \n";
  $sumbs = hex($b1)+hex($b2)+hex($b3)+hex($b4)+hex($b5)+hex($b6)+hex($b7) ; 
                       # checksum mod 0x100 sum b1-7

  $b8 = $sumbs % 256 ;
  print "checksum is : $b8 in dec \n";
  $b8 = sprintf("%X", $b8) ;
  print "che is $b8 \n";
  $b8 = sprintf("%2s", $b8 ) ;  $b8=~ tr/ /0/ ; #pad with zeros up to 2 chars
  print "checksum is : $b8 \n" ;

  my $req = pack ("H*" , "$b1$b2$b3$b4$b5$b6$b7$b8" . "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
  my $size = $socket->send("$req");
  #print "sent data of length $size\n";
  #print "sent .... - $req \n";
  $dan = unpack ("H*" , $req );
  #print "sent data clear $dan \n";
  # notify server that request has been sent
#  shutdown($socket, 1);

  # receive a response of up to 1024 characters from server
  $response = "";
  $socket->recv($response, 1024);
  #print "received response: $response\n";
  $dan=unpack ( "H*", $response );
  print "received clear response: $dan\n";

  if ( $dan =~ m/aacc/ ) {
    $hexdata = substr $dan, 16, 14 ; #18 chars in and 14 chars long
    # print "$hexdata \n";
    $binary_string = sprintf "%056b", hex( $hexdata );
    print "$binary_string \n" ;
    $in1 = substr $binary_string, 7, 1;
    $in2 = substr $binary_string, 6, 1;
    $in3 = substr $binary_string, 5, 1;
    $in4 = substr $binary_string, 4, 1;
    $in5 = substr $binary_string, 3, 1;
    $in6 = substr $binary_string, 2, 1;
    $in7 = substr $binary_string, 1, 1;
    $in8 = substr $binary_string, 0, 1;

    $in9 = substr $binary_string, 15, 1;
    $in10 = substr $binary_string, 14, 1;
    $in11 = substr $binary_string, 13, 1;
    $in12 = substr $binary_string, 12, 1;
    $in13 = substr $binary_string, 11, 1;
    $in14 = substr $binary_string, 10, 1;
    $in15 = substr $binary_string, 9, 1;
    $in16 = substr $binary_string, 8, 1;
    #print "$in1, $in2, $in3, $in4, $in5, $in6, $in7, $in8 \n" ; 
    #print "$in9, $in10, $in11, $in12, $in13, $in14, $in15, $in16 \n" ;

    setvals( "in1" ) ;
    setvals( "in2" ) ;
    setvals( "in3" ) ;
    setvals( "in4" ) ;
    setvals( "in5" ) ;
    setvals( "in6" ) ;
    setvals( "in7" ) ;
    setvals( "in8" ) ;

    setvals( "in9" ) ;
    setvals( "in10" ) ;
    setvals( "in11" ) ;
    setvals( "in12" ) ;
    setvals( "in13" ) ;
    setvals( "in14" ) ;
    setvals( "in15" ) ;
    setvals( "in16" ) ;

  }
  select(undef, undef, undef, $sleepwait); #sleeep 250 mS

  $count++ ;
  if ( $count eq "100" )
  {
    $pokeys_in_butler_lastran = $epoch ;
    setvals( "pokeys_in_butler_lastran" ) ;
    $count = 0 ;
  }

}
