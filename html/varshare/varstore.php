<?php

################################################################################
#
# Version: 1.1
# Date   : 09/11/2018
#
# Note : Write permission for apache needed on $varstore directory
# 
# This script provides a html form to set variables with persistence
# provided by a file with the variable name created in the $varstore dir
#
# On a B+ pi this takes about 15% processor to handle 40 requests per 
# second
#
# To call from wget:
# 
# curl -d "varname=test&value=12&action=Send" http://[server]/[dir]/varstore.php
#
# Update 1.1 - added rules to allow just variable1, 2, 3, 4 or all 5 updates
#              Note: structure is value|sp1|sp2|sp3|epoch - can now send
#              1 - 5 values left to right, will keep sp1-3 vals if not spec
#              timestamp (epoch) will be updated if not set
################################################################################

#Config Variables
#$varstore = "/var/www/varshare/vars/" ;
$varstore = "/var/www/html/varshare/vars/" ;
$val5 = time() ;

$action = $_REQUEST['action']; 
if ( $action == "" ) { 
  ?> 
  <form  action="" method="POST"> 
  <input type="hidden" name="action" value="submit"> 
  Variable Name:<br> 
  <input name="varname" type="text" value="" size="30"/><br> 
  Value:<br> 
  <input name="value" type="text" value="" size="30"/><br> 
  <input type="submit" value="Send"/> 
  </form> 
  <?php 
}  
else { 
  $varname=$_REQUEST['varname']; 
  $value=$_REQUEST['value']; 
  if (( $varname == "" ) || ( $value=="" )) { 
    echo "All fields are required" ; 
  } 
  else {         
    echo "Sent $varname $value" ;
    chdir( $varstore ) ;
    // Format is value|sp1|sp2|sp3|epoch
    // i.e -  12|1|1|1|1541772288
    $data = file_get_contents( $varname ) ; // read in old values 
    $old_values = explode( "|" , $data ) ; 
    $val1 = $old_values[0] ;
    $val2 = $old_values[1] ;
    $val3 = $old_values[2] ;
    $val4 = $old_values[3] ;
    if ( $val1 == "" ) { $val1 = "0" ; } # sets default vals if none set
    if ( $val2 == "" ) { $val2 = "1" ; } 
    if ( $val3 == "" ) { $val3 = "2" ; }
    if ( $val4 == "" ) { $val4 = "3" ; }

    $new_values = explode( "|" , $value ) ;
    if ( array_key_exists( "0" , $new_values )) {
      $val1 = $new_values[0] ; 
    } 
    if ( array_key_exists( "1" , $new_values )) {
      $val2 = $new_values[1] ; 
    } 
    if ( array_key_exists( "2" , $new_values )) {
      $val3 = $new_values[2] ; 
    } 
    if ( array_key_exists( "3" , $new_values )) {
      $val4 = $new_values[3] ; 
    } 
    if ( array_key_exists( "4" , $new_values )) {
      $val5 = $new_values[4] ; 
    }        

    file_put_contents($varname, $val1."|".$val2."|".$val3."|".$val4."|".$val5);

    $ip = "192.168.100.255";
    $port = 8888;
    $str = "varstore";

    $sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP); 
    socket_set_option($sock, SOL_SOCKET, SO_BROADCAST, 1); 
    socket_sendto($sock, $varname, strlen($str), 0, $ip, $port);

    #socket_recvfrom($sock, $buf, 20, 0, $ip, $port);
    #echo "Messagge : < $buf > , $ip : $port <br>";

    socket_close($sock); 

  } 
}   
?>
