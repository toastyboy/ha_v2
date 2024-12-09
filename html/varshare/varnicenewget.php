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
$files = glob( '*'.htmlspecialchars($_GET["search"]).'*' ) ;
#above line takes the GET var 'search' and puts a * at both ends
$variab = array() ;

foreach( $files as $fname )
  {
    #echo $fname . "||" ;
    $vals = file_get_contents( $fname ) ;
    $vals = rtrim($vals) ;

    $vals_arr = explode ("|", $vals) ;
    $nicetime = date('Y-m-d H:i:s', $vals_arr[4]) ;
    $newvar = $fname . "|" . $vals_arr[0] . "|" . $vals_arr[1] . "|" . $vals_arr[2] . "|" . $vals_arr[3] . "|" . $nicetime ;
    $variab[$newvar] = $vals_arr[4] ; 
    #echo $newvar ; # $vals_arr[0] ."|" . $vals_arr[1] ."|". $vals_arr[2] . "|" . date('Y-m-d H:i:s', $vals_arr[4]) ." " . $vals_arr[4] ;
    #echo "<br> \n" ;
    #echo $variab[4] ;
  }

arsort($variab) ;
#print_r($variab);

echo "<html><body> \n" ;
echo '<META HTTP-EQUIV="refresh" CONTENT="10">' ;
echo "<FONT SIZE=14>" ;
echo '<body style="background-color:#999966"> ' ;
echo "<table>" ;
echo "<tr><th>Name</th><th>Val</th><th>1</th><th>2</th><th>3</th><th>Time</th>" ;
foreach( $variab as $varia => $varia_val )
  { 
  $values = explode ("|", $varia) ; 
  echo "<tr>" ;
  echo "<td> $values[0] </td>" ;
  echo "<td> $values[1] </td>" ;
  echo "<td> $values[2] </td>" ;
  echo "<td> $values[3] </td>" ;
  echo "<td> $values[4] </td>" ;
  echo "<td> $values[5] </td>" ;

  echo "</tr> \n" ;

  }
echo "</table>" ;
?>
