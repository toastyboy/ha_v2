<?php
// loop through 20 times looking for POST vars dmx1 or dmx2 etc...
// then set to the value that corresponds
$valoff = "0" ;
$valvdi = "70" ;
$valdim = "100" ;
$valmid = "150" ;
$valbri = "180" ;
$valful = "250" ;
$server="http://varhost/varshare/varstore.php" ;
for ($x = 1; $x <= 24; $x++) {
$varname="dmx".$x ;
  if(isset($_POST['dmx'.$x])) {   ### Could replace this with $REQUEST and do GET and POST??
    $set = $_POST['dmx'.$x] ;
    exec("curl -d \"varname=$varname&value=$set&action=Send\" $server") ;
  }
}

#out123 types
for ($x = 1; $x <= 220; $x++) {
  $varname="out".$x ;
  if(isset($_POST['out'.$x])) {
    $set = $_POST['out'.$x] ;
    exec("curl -d \"varname=$varname&value=$set&action=Send\" $server") ;
  }
}


if(isset($_POST['theme']))
  {
  $set = $_POST['theme'] ;
  exec("curl -d \"varname=theme&value=$set&action=Send\" $server") ;
  }

$postvars = array( "garagebackdoorlock" , "garageuandolocks" , "garagealarm" ); 

foreach ($postvars as $value) 
{
  if(isset($_POST[$value]))
  {
  $set = $_POST[$value] ;
  exec("curl -d \"varname=$value&value=$set&action=Send\" $server") ;
  }
}



sleep(0.3);
//header('location: firstfloorlanding.php');
$referer = $_SERVER['HTTP_REFERER'];
header("Location: $referer");
exit;  
