#!/usr/bin/perl


# Note this adaptor is to process basic I/O logic 

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

$sleepwait = "0.25" ;
$url = "http://varhost/varshare" ;
our %hash = ();


#init gpio, set up gpio ports initially
`/usr/bin/gpio mode 6 in` ; # door switch


#SUBROUTINE setvals simplified!!***
#
# setvals (var_name) - will compare the value of $var_name with the centrally
# stored value $hash{$var_name}[0] and if different will write is back to the
# repository via http 
#
sub setvals {
  $varname = $_[0] ;
  $epoch = time() ;
  if (( $$varname ne $vals ) && ( $$varname ne "" )) {
    #print "$varname is $$varname noteq $vals \n" ;
    $hash{$varname}="$$varname" ;
    `curl -sd "varname=$varname&value=$hash{$varname}&action=Send" $url/varstore.php` ;
  }
  $vals = $$varname
}


while (1) {

  # read door bell
  $frontdoorbell = `/usr/bin/gpio read 6` ;
  $frontdoorbell =~ s/[^a-zA-Z0-9,|.]+//g;
  setvals( "frontdoorbell" ) ;

 
  select(undef, undef, undef, $sleepwait) ; #Sleep before rerunning 

}
