#!/usr/bin/perl
# Note this adaptor is to process basic I/O logic
#exit;
#########################################################################
#
# Version: 1.0
# Date   : 10/11/2022
#
# Note : Perl modules are required
#
#
#
#
#########################################################################

$sleepwait = "0.7" ;
#$url = "http://varhost/varshare" ;
$url = "http://192.168.100.120/varshare" ;
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
    $hash{$varname}="$$varname" ;
    `curl -sd "varname=$varname&value=$hash{$varname}&action=Send" $url/varstore.php` ;
  }
}


@x = () ;

while () {
  gethtml () ;
  $epoch = time();
  $tensecs = $epoch - 10 ;
  $onemin  = $epoch - 60 ;
  $tenmins = $epoch - 600 ;

unshift(@x , $hash{tankheatkwh}[0]) ;
#print "Current vals \n" ;
#print $epoch ."\n" ; 
#print $x[0] . "\n" ;


if(exists($x[12]))
{
        $heatdelta60 = ( $x[0] - $x[11] ) * 60 ;
#	print "60 sec ave = " . $heatdelta60 . "\n" ;
	setvals ("heatdelta60") ;
}

if(exists($x[60]))
{
        $heatdelta300 = ( $x[0] - $x[59] ) * 12 ;
#        print "5 min ave = " . $heatdelta300 . "\n" ;
        setvals ("heatdelta300") ;
}

if(exists($x[120]))
{
        $heatdelta600 = ( $x[0] - $x[119] ) * 6 ;
#        print "10 min ave = " . $heatdelta600 . "\n" ;
        setvals ("heatdelta600") ;
}

if(exists($x[180]))
{
        $heatdelta900 = ( $x[0] - $x[179] ) * 4 ;
#        print "15 min ave = " . $heatdelta900 . "\n" ;
        setvals ("heatdelta900") ;
}

if(exists($x[360]))
{
        $heatdelta1800 = ( $x[0] - $x[359] ) * 2 ;
#        print "30 min ave = " . $heatdelta1800 . "\n" ;
        setvals ("heatdelta1800") ;
}

if(exists($x[720]))
{
        $heatdelta3600 = ( $x[0] - $x[719] ) * 1 ;
#        print "1 hr ave = " . $heatdelta3600 . "\n" ;
        setvals ("heatdelta3600") ;
	$test = pop @x ; #remove one from the end
}



sleep 5 ;
}
