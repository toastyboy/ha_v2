#!/usr/bin/perl

# Note this adaptor is for Galaxy GD-96 

#########################################################################
#
# Version: 1.0
# Date   : 19/09/2018
#
# Note : Perl modules are required
# 
#
#
# 
#########################################################################

use Device::SerialPort 0.12 ;

$url = "http://varhost/varshare" ;
$epoch = time() ;

# get the content of the web page
$content = `curl -s "$url/varshow.php"` ;

@content = split(/<br>/, $content) ;

foreach $origtext ( @content ) { 
  @values = split(/\|\|/, $origtext) ; # split on || into an array
  $hash{$values[0]} = $values[1] ;
  #print "$values[0] ... $values[1] hash $hash{$values[0]} \n" ;
}


foreach (sort keys %myhash) {
# print "$_ : $myhash{$_}\n";
}
#print "out08  $hash{out08} \n";

#Set up serial port
$ob = Device::SerialPort->new ("/dev/ttyAMA0") || die "Can't Open $PORT: $!";
$ob->baudrate(9600)    || die "failed setting baudrate";
$ob->parity("none")    || die "failed setting parity";
$ob->databits(8)       || die "failed setting databits";
$ob->stopbits(1)       || die "failed setting stopbits"; 

$count = 100 ;
$set = 0 ;
system( "logger 'HAL - galaxy.perl rebooted' ");

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



while (1) {

  $dan=$ob->read(1);
  select(undef, undef, undef, 0.001); #sleep 250 mS
  $req = unpack ("H*" , $dan );
  $req =~ s/[^\w]//g ;
  $req =~ s/' '//g ;
  chomp($req);
  #print "$req \n";

  if ( $req ne "") { 

    if ($req eq "11") { 
      $match = 1 ; 
      $val1 = $req ;
    }

    if (( $match == 1 ) && ( $req eq "fe" )) {
      $match = 2 ;
      $val2 = $req ;
    }

    if (( $match == 2 ) && ( $req eq "ba" )) {
      $match = 3 ;
      $val3 = $req ;
    }

    if (($req != "11") && ($req != "fe") && ($req != "ba")) { 
      $match = "0" ; 
    }

    if ( $match == 3 ) {
      $count = 0 ;
      $match = 0 ;
      @dan=() ;
      push (@dan , $val1 ) ;
      push (@dan , $val2 ) ;
    }

    if ( $count < 25 ) {
      push ( @dan, $req ) ; 
    }
 
    sub decodestatus {
      $varout = $_[0] ;
      $varval = $varout . "_val" ;
      $$varval = $$varout ;
      print "$varout is $$varout \n ";
      if ( $$varout =~ /^07/ ) {
            $$varout = "1" ; $set++ ;
          }
          else {
            $$varout = "0" ; $set++ ;
          }
    }
    
    #print "$dan[3] $dan[7] $count $match $req $dan[0] $dan[17]" ;
    #print "$dan[8] $dan[9] $dan[10] $dan[11] $dan[22] $dan[23] \n" ;
    if ( $count == 25 ) {
      $epoch = time();
      if (($dan[3] eq "02") && ($dan[7] eq "f1")) {
        $gal21 = $dan[8] . $dan[9] ;
        $gal22 = $dan[10] . $dan[11] ;
        $gal23 = $dan[12] . $dan[13] ;
        $gal24 = $dan[14] . $dan[15] ;
        $gal25 = $dan[16] . $dan[17] ;
        $gal26 = $dan[18] . $dan[19] ;
        $gal27 = $dan[20] . $dan[21] ; 
        $gal28 = $dan[22] . $dan[23] ;

        decodestatus(gal21) ;
        decodestatus(gal22) ;
        decodestatus(gal23) ;
        decodestatus(gal24) ;
        decodestatus(gal25) ;
        decodestatus(gal26) ;
        decodestatus(gal27) ;
        decodestatus(gal28) ;
      }

      if (($dan[3] eq "03") && ($dan[7] eq "f1")) {
        $gal31 = $dan[8] . $dan[9] ;
        $gal32 = $dan[10] . $dan[11] ;
        $gal33 = $dan[12] . $dan[13] ;
        $gal34 = $dan[14] . $dan[15] ;
        $gal35 = $dan[16] . $dan[17] ;
        $gal36 = $dan[18] . $dan[19] ;
        $gal37 = $dan[20] . $dan[21] ;
        $gal38 = $dan[22] . $dan[23] ;
        
        decodestatus(gal31) ;
        decodestatus(gal32) ;
        decodestatus(gal33) ;
        decodestatus(gal34) ;
        decodestatus(gal35) ;
        decodestatus(gal36) ;
        decodestatus(gal37) ;
        decodestatus(gal38) ;
      }

      if (($dan[3] eq "04") && ($dan[7] eq "f1")) {
        $gal41 = $dan[8] . $dan[9] ;
        $gal42 = $dan[10] . $dan[11] ;
        $gal43 = $dan[12] . $dan[13] ;
        $gal44 = $dan[14] . $dan[15] ;
        $gal45 = $dan[16] . $dan[17] ;
        $gal46 = $dan[18] . $dan[19] ;
        $gal47 = $dan[20] . $dan[21] ;
        $gal48 = $dan[22] . $dan[23] ;

        decodestatus(gal41) ;
        decodestatus(gal42) ;
        decodestatus(gal43) ;
        decodestatus(gal44) ;
        decodestatus(gal45) ;
        decodestatus(gal46) ;
        decodestatus(gal47) ;
        decodestatus(gal48) ;      
      }

      if (($dan[3] eq "05") && ($dan[7] eq "f1")) {
        $gal51 = $dan[8] . $dan[9] ;
        $gal52 = $dan[10] . $dan[11] ;
        $gal53 = $dan[12] . $dan[13] ;
        $gal54 = $dan[14] . $dan[15] ;
        $gal55 = $dan[16] . $dan[17] ;
        $gal56 = $dan[18] . $dan[19] ;
        $gal57 = $dan[20] . $dan[21] ;
        $gal58 = $dan[22] . $dan[23] ;

        decodestatus(gal51) ;
        decodestatus(gal52) ;
        decodestatus(gal53) ;
        decodestatus(gal54) ;
        decodestatus(gal55) ;
        decodestatus(gal56) ;
        decodestatus(gal57) ;
        decodestatus(gal58) ;
      }


      if (($dan[3] eq "01") && ($dan[7] eq "f1")) {
        $gal11 = $dan[8] . $dan[9] ;
        $gal12 = $dan[10] . $dan[11] ;
        $gal13 = $dan[12] . $dan[13] ;
        $gal14 = $dan[14] . $dan[15] ;
        $gal15 = $dan[16] . $dan[17] ;
        $gal16 = $dan[18] . $dan[19] ;
        $gal17 = $dan[20] . $dan[21] ;
        $gal18 = $dan[22] . $dan[23] ;

        decodestatus(gal11) ;
        decodestatus(gal12) ;
        decodestatus(gal13) ;
        decodestatus(gal14) ;
        decodestatus(gal15) ;
        decodestatus(gal16) ;
        decodestatus(gal17) ;
        decodestatus(gal18) ;
      }

      if (($dan[3] eq "00") && ($dan[7] eq "f1")) {
        $gal01 = $dan[8] . $dan[9] ;
        $gal02 = $dan[10] . $dan[11] ;
        $gal03 = $dan[12] . $dan[13] ;
        $gal04 = $dan[14] . $dan[15] ;
        $gal05 = $dan[16] . $dan[17] ;
        $gal06 = $dan[18] . $dan[19] ;
        $gal07 = $dan[20] . $dan[21] ;
        $gal08 = $dan[22] . $dan[23] ;

        decodestatus(gal01) ;
        decodestatus(gal02) ;
        decodestatus(gal03) ;
        decodestatus(gal04) ;
        decodestatus(gal05) ;
        decodestatus(gal06) ;
        decodestatus(gal07) ;
        decodestatus(gal08) ;
      }

      if ( $set > 0 ) {
        sub comparevals {
          $varname = $_[0] ;
          $varval = $varname . "_val" ;
          @vals ;
          @vals = split /\|/, $hash{$varname} ;
          if (( $$varname ne $vals[0] ) && ( $$varname ne "" )) {
            print "$varname is $$varname noteq $vals[0] \n" ;
            $hash{$varname}="$$varname|$$varval" ;
            `curl -sd "varname=$varname&value=$hash{$varname}&action=Send" $url/varstore.php` ;
          }
        }

        comparevals ("gal01") ;
        comparevals ("gal02") ;
        comparevals ("gal03") ;
        comparevals ("gal04") ;
        comparevals ("gal05") ;
        comparevals ("gal06") ;
        comparevals ("gal07") ;
        comparevals ("gal08") ;

        comparevals ("gal21") ;
        comparevals ("gal22") ;
        comparevals ("gal23") ;
        comparevals ("gal24") ;
        comparevals ("gal25") ;
        comparevals ("gal26") ;
        comparevals ("gal27") ;
        comparevals ("gal28") ;

        comparevals ("gal31") ;
        comparevals ("gal32") ;
        comparevals ("gal33") ;
        comparevals ("gal34") ;
        comparevals ("gal35") ;
        comparevals ("gal36") ;
        comparevals ("gal37") ;
        comparevals ("gal38") ;

        comparevals ("gal41") ;
        comparevals ("gal42") ;
        comparevals ("gal43") ;
        comparevals ("gal44") ;
        comparevals ("gal45") ;
        comparevals ("gal46") ;
        comparevals ("gal47") ;
        comparevals ("gal48") ;

        comparevals ("gal51") ;
        comparevals ("gal52") ;
        comparevals ("gal53") ;
        comparevals ("gal54") ;
        comparevals ("gal55") ;
        comparevals ("gal56") ;
        comparevals ("gal57") ;
        comparevals ("gal58") ;

        comparevals ("gal11") ;
        comparevals ("gal12") ;
        comparevals ("gal13") ;
        comparevals ("gal14") ;
        comparevals ("gal15") ;
        comparevals ("gal16") ;
        comparevals ("gal17") ;
        comparevals ("gal18") ;


        $set = 0 ;
      }
      @dan=() ;
    }
    $count++ ;
  }
 
    $counter++ ;
    if ( $counter eq "10000" )
    {
      $galaxy_black_lastran = $epoch ;
      setvals( "galaxy_black_lastran" ) ;
      $counter = 0 ;
    }

}
