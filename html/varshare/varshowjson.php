<?php

#########################################################################
#
# Version: 1.0
# Date   : 15/11/2022
# ....
#
#########################################################################

#Config Variables
#$varstore="/var/www/varshare/vars/" ;
$varstore="/var/www/html/varshare/vars/" ;

if(isset($_GET['search'])){
    $search = $_GET['search'];
}else{
    $search = "";
}

chdir ($varstore) ;

$files = glob( '*'.htmlspecialchars($search).'*' ) ;
#above line takes the GET var 'search' and puts a * at both ends

echo "{" ;
foreach( $files as $fname ) 
  {
    $vals = file_get_contents( $fname ) ;
    $vals = rtrim($vals) ;
    $splitvals = explode("|", $vals) ;
    if(isset($splitvals[4])) { 
      echo "\"$fname\": {\"value\": \"$splitvals[0]\", \"epoch\": $splitvals[4]},"  ;
    }
  }
echo "\"end\": {\"value\": 0, \"epoch\": 0}}" ;

?>
