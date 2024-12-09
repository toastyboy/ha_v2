<?php

#########################################################################
#
# Version: 1.0
# Date   : 19/09/2018
#
# This script produces a page of html containing all variables contained
# within the $varstore dir in the form:
#
# varname1||value1
# varname2||value2
# ....
#
#########################################################################

#Config Variables
#$varstore="/var/www/varshare/vars/" ;
$varstore="/var/www/html/varshare/vars/" ;

chdir ($varstore) ;
$files = glob( '*' ) ;
$variab = array() ;

foreach( $files as $fname )
  {
    #echo $fname . "||" ;
    $vals = file_get_contents( $fname ) ;
    $vals = rtrim($vals) ;

    $vals_arr = explode ("|", $vals) ;
    $nicetime = date('Y-m-d H:i:s', $vals_arr[4]) ;
    $newvar = $fname . "||" . $vals_arr[0] . "|" . $vals_arr[1] . "|" . $vals_arr[2] . "|" . $vals_arr[3] . "|" . $nicetime ;
    $variab[$newvar] = $vals_arr[4] ; 
    #echo $newvar ; # $vals_arr[0] ."|" . $vals_arr[1] ."|". $vals_arr[2] . "|" . date('Y-m-d H:i:s', $vals_arr[4]) ." " . $vals_arr[4] ;
    #echo "<br> \n" ;
    #echo $variab[4] ;
  }

arsort($variab) ;
#print_r($variab);
foreach( $variab as $varia => $varia_val )
  { 
  echo $varia ;
  echo "<br>";
  }
?>
