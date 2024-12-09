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

foreach( $files as $fname ) 
  {
    echo $fname . "||" ;
    $vals = file_get_contents( $fname ) ;
    $vals = rtrim($vals) ;
    echo $vals ;
    echo "<br> \n" ;
  }
?>
