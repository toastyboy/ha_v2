#!/usr/bin/perl


# Note this adaptor is to process basic ifttt logic 

#########################################################################
#
# Version: 1.0
# Date   : 06/04/2020
#
# Note : Perl modules are required
# Jul 22 - added sms disable/enable button on out202 
#
#
# 
#########################################################################

$sleepwait = "0.2" ;
$url = "http://varhost/varshare" ;
our %hash = ();
$counter = 0 ;
$smslastran = 10 ;

$logfile = 'logic_log.txt';

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
  #clear old hash
  $epoch = time() ;
  undef %{$hash} ;
  #get the content of the web page set initial values

  #open(FH, '>>', $logfile) or die $!;
  #print FH "$epoch getting variables \n";
  $content = `curl -s -m5 "$url/varshow.php"` ;
  #print "$content \n" ;
  #print FH "$epoch got variables \n";
  #close(FH) ;

  @content = split(/<br>/, $content) ;

  #$hash{dan}[0] = "1" ;
  #$hash{dan}[1] = "3" ;
  #$hash{dan}[2] = "5" ;

  foreach $origtext ( @content ) {
    $origtext =~ s/[^a-zA-Z0-9,|._]+//g; #remove funky chars
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
    print "$varname is $$varname noteq $vals \n" ;
    $hash{$varname}="$$varname" ;
    #open(FH, '>>', $logfile) or die $!;
    #print FH "$epoch setting variable - $varname with value $hash{$varname} \n";
    `curl -m5 -sd "varname=$varname&value=$hash{$varname}&action=Send" $url/varstore.php` ;
    #print FH "set variable - $varname with value $hash{$varname}  \n";
    #close(FH) ;
    select(undef, undef, undef, 0.1) ; #Sleep before rerunning
  }
}


while (1) 
{

  gethtml () ;
  #print "gethtml() ran \n" ;
  #print "dmx1 = $hash{dmx1}[0] \n" ;
  #print "dmx1 (local) = $dmx1 \n" ;
  $epoch = time();
  $tensecs = $epoch - 10 ;
  $onemin  = $epoch - 60 ;
  $tenmins = $epoch - 600 ;
  $sixtymins = $epoch - 3600 ;
  $tenhrs = $epoch - 36000 ;


  #tank heat storage calcs
  if ( $counter == 1 ) 
  {
    $tankheatkj = ((750/8) * 4.2 * ($hash{temp2}[0] + $hash{temp1}[0] 
                 + $hash{temp3}[0] + $hash{temp5}[0] + $hash{temp6}[0]
                 + $hash{temp4}[0] + $hash{temp8}[0] + $hash{temp7}[0] )) ;

    $tankheatkwh = $tankheatkj / 3600 ;
    setvals( "tankheatkj" );
    setvals( "tankheatkwh" );
  }

#is it dark
  if ( $hash{darkval}[0] < 1 )
  {
    $dark = "1" ; setvals( "dark" ) ;
  }
  else
  {
    $dark = "0" ; setvals( "dark" ) ;
  }
 

## Light themes 

if   ( $hash{theme}[0] eq "off" )       # all off theme
  {
    $dmx1 = "0" ; setvals( "dmx1" ) ; 
    $dmx2 = "0" ; setvals( "dmx2" ) ;
    $dmx3 = "0" ; setvals( "dmx3" ) ;
    $dmx4 = "0" ; setvals( "dmx4" ) ;
    $dmx5 = "0" ; setvals( "dmx5" ) ;
    $dmx6 = "0" ; setvals( "dmx6" ) ;
    $dmx7 = "0" ; setvals( "dmx7" ) ;
    $dmx8 = "0" ; setvals( "dmx8" ) ;
    $dmx9 = "70" ; setvals( "dmx9" ) ; #landing lights
    $dmx10 = "0" ; setvals( "dmx10" ) ;
    $dmx11 = "0" ; setvals( "dmx11" ) ;
    $dmx12 = "0" ; setvals( "dmx12" ) ;
    $dmx13 = "0" ; setvals( "dmx13" ) ;
    $dmx14 = "0" ; setvals( "dmx14" ) ;
    $dmx15 = "0" ; setvals( "dmx15" ) ;
    $dmx16 = "0" ; setvals( "dmx16" ) ;
    $dmx17 = "0" ; setvals( "dmx17" ) ;
    # $dmx18 = "0" ; setvals( "dmx18" ) ; #counter lights
    $dmx19 = "0" ; setvals( "dmx19" ) ;
    $dmx20 = "0" ; setvals( "dmx20" ) ;
    $dmx21 = "0" ; setvals( "dmx21" ) ; # new dining 
    $out201 = "0" ; setvals( "out201" ) ; #Cellar
    $theme = "set" ; setvals( "theme" ) ;

  }

if   ( $hash{theme}[0] eq "on" )       # all off theme
  {
    $dmx1 = "255" ; setvals( "dmx1" ) ;
    $dmx2 = "255" ; setvals( "dmx2" ) ;
    $dmx3 = "255" ; setvals( "dmx3" ) ;
    $dmx4 = "255" ; setvals( "dmx4" ) ;
    $dmx5 = "255" ; setvals( "dmx5" ) ;
    $dmx6 = "255" ; setvals( "dmx6" ) ;
    $dmx7 = "255" ; setvals( "dmx7" ) ;
    $dmx8 = "255" ; setvals( "dmx8" ) ;
    $dmx9 = "255" ; setvals( "dmx9" ) ; #landing lights
    $dmx10 = "255" ; setvals( "dmx10" ) ;
    $dmx11 = "255" ; setvals( "dmx11" ) ;
    $dmx12 = "255" ; setvals( "dmx12" ) ;
    $dmx13 = "255" ; setvals( "dmx13" ) ;
    $dmx14 = "255" ; setvals( "dmx14" ) ;
    $dmx15 = "255" ; setvals( "dmx15" ) ;
    $dmx16 = "255" ; setvals( "dmx16" ) ;
    $dmx17 = "255" ; setvals( "dmx17" ) ;
    $dmx18 = "255" ; setvals( "dmx18" ) ; #counter lights
    $dmx19 = "255" ; setvals( "dmx19" ) ;
    $dmx20 = "255" ; setvals( "dmx20" ) ;
    $dmx21 = "255" ; setvals( "dmx21" ) ; # new dining
    $out201 = "1" ; setvals( "out201" ) ; # Cellar
    $theme = "set" ; setvals( "theme" ) ;

  }

if   ( $hash{theme}[0] eq "morning" )       # all off theme
  {
    $dmx1 = "0" ; setvals( "dmx1" ) ;
    $dmx2 = "0" ; setvals( "dmx2" ) ;
    $dmx3 = "0" ; setvals( "dmx3" ) ;
    $dmx4 = "0" ; setvals( "dmx4" ) ;
    $dmx5 = "0" ; setvals( "dmx5" ) ;
    $dmx6 = "0" ; setvals( "dmx6" ) ;
    $dmx7 = "0" ; setvals( "dmx7" ) ;
    $dmx8 = "0" ; setvals( "dmx8" ) ;
    $dmx9 = "70" ; setvals( "dmx9" ) ; #landing lights
    $dmx10 = "0" ; setvals( "dmx10" ) ;
    $dmx11 = "0" ; setvals( "dmx11" ) ;
    $dmx12 = "0" ; setvals( "dmx12" ) ;
    $dmx13 = "0" ; setvals( "dmx13" ) ;
    $dmx14 = "0" ; setvals( "dmx14" ) ;
    $dmx15 = "0" ; setvals( "dmx15" ) ;
    $dmx16 = "0" ; setvals( "dmx16" ) ;
    $dmx17 = "0" ; setvals( "dmx17" ) ;
    # $dmx18 = "0" ; setvals( "dmx18" ) ; #counter lights
    $dmx19 = "0" ; setvals( "dmx19" ) ;
    $dmx20 = "0" ; setvals( "dmx20" ) ;
    $dmx21 = "0" ; setvals( "dmx21" ) ; # new dining
    $theme = "set" ; setvals( "theme" ) ;

  }

if   ( $hash{theme}[0] eq "evening" )       # all off theme
  {
    $dmx1 = "0" ; setvals( "dmx1" ) ;
    $dmx2 = "0" ; setvals( "dmx2" ) ;
    $dmx3 = "0" ; setvals( "dmx3" ) ;
    $dmx4 = "0" ; setvals( "dmx4" ) ;
    $dmx5 = "0" ; setvals( "dmx5" ) ;
    $dmx6 = "0" ; setvals( "dmx6" ) ;
    $dmx7 = "0" ; setvals( "dmx7" ) ;
    $dmx8 = "0" ; setvals( "dmx8" ) ;
    $dmx9 = "70" ; setvals( "dmx9" ) ; #landing lights
    $dmx10 = "0" ; setvals( "dmx10" ) ;
    $dmx11 = "0" ; setvals( "dmx11" ) ;
    $dmx12 = "0" ; setvals( "dmx12" ) ;
    $dmx13 = "0" ; setvals( "dmx13" ) ;
    $dmx14 = "0" ; setvals( "dmx14" ) ;
    $dmx15 = "0" ; setvals( "dmx15" ) ;
    $dmx16 = "0" ; setvals( "dmx16" ) ;
    $dmx17 = "0" ; setvals( "dmx17" ) ;
    # $dmx18 = "0" ; setvals( "dmx18" ) ; #counter lights
    $dmx19 = "0" ; setvals( "dmx19" ) ;
    $dmx20 = "0" ; setvals( "dmx20" ) ;
    $dmx21 = "0" ; setvals( "dmx21" ) ; # new dining
    $theme = "set" ; setvals( "theme" ) ;

  }

if   ( $hash{theme}[0] eq "night" )       # all off theme
  {
    $dmx1 = "0" ; setvals( "dmx1" ) ;
    $dmx2 = "0" ; setvals( "dmx2" ) ;
    $dmx3 = "0" ; setvals( "dmx3" ) ;
    $dmx4 = "0" ; setvals( "dmx4" ) ;
    $dmx5 = "0" ; setvals( "dmx5" ) ;
    $dmx6 = "0" ; setvals( "dmx6" ) ;
    $dmx7 = "0" ; setvals( "dmx7" ) ;
    $dmx8 = "0" ; setvals( "dmx8" ) ;
    $dmx9 = "70" ; setvals( "dmx9" ) ; #landing lights
    $dmx10 = "0" ; setvals( "dmx10" ) ;
    $dmx11 = "0" ; setvals( "dmx11" ) ;
    $dmx12 = "0" ; setvals( "dmx12" ) ;
    $dmx13 = "0" ; setvals( "dmx13" ) ;
    $dmx14 = "0" ; setvals( "dmx14" ) ;
    $dmx15 = "0" ; setvals( "dmx15" ) ;
    $dmx16 = "0" ; setvals( "dmx16" ) ;
    $dmx17 = "0" ; setvals( "dmx17" ) ;
    # $dmx18 = "0" ; setvals( "dmx18" ) ; #counter lights
    $dmx19 = "0" ; setvals( "dmx19" ) ;
    $dmx20 = "0" ; setvals( "dmx20" ) ;
    $dmx21 = "180" ; setvals( "dmx21" ) ; # new dining
    $theme = "set" ; setvals( "theme" ) ;

  }

  #37 pir , 38 viper, 01 middle door, 02 sliding
  # 03 middle u&o, 04 big u&o, 05 small door, 06 recept pir
  # 07 back door , 08 kens pir 

  select(undef, undef, undef, $sleepwait) ; #Sleep before rerunning 
  $count++ ;
  if ( $count eq "100" )
  { 
    $logic_nas_lastran = $epoch ; 
    setvals( "logic_nas_lastran" ) ;
    $count = 0 ; 
  }

$counter++ ; 
if ( $counter == 100 ) { $counter = 1 ; }

}
