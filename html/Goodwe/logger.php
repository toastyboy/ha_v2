<?php

#Config Variables
$varstore = "/var/www/html/Acceptor/" ;
$server="http://varhost/varshare/varstore.php" ;

chdir( $varstore ) ;

$file = file_get_contents('php://input');

if  ( $file  !=  "" )  { 
  $file  =  bin2hex ( $file ); 

#  for ($x = 0; $x <= 40; $x++) {
#    $y = ( $x * 4 )   ;
#    $a = $y . " - " . (hexdec(substr($file, $y, 4)))."";

#    file_put_contents("dan.txt", print_r("$a \n", true),FILE_APPEND);
#  }


$solar_vac = (hexdec(substr($file, 48, 4))/10) ;
if  ( $solar_vac  <  '255' )  {
  exec("curl -d \"varname=solar_vac&value=$solar_vac&action=Send\" $server") ; 

  #file_put_contents("dan.txt", "Vac - ". (hexdec(substr($file, 48, 4))/10) ."\n" ,FILE_APPEND);   
}

$solar_hz = (hexdec(substr($file, 56, 4))/100) ;
if  ( $solar_hz  >  '42' )  {

  exec("curl -d \"varname=solar_hz&value=$solar_hz&action=Send\" $server") ; 
  #file_put_contents("dan.txt", "Hz - ". (hexdec(substr($file, 56, 4))/100) . "\n" ,FILE_APPEND);
}

$solar_kwatts = (hexdec(substr($file, 60, 4))/1000) ;
if  ( $solar_kwatts  <  '3' )  {
  exec("curl -d \"varname=solar_kwatts&value=$solar_kwatts&action=Send\" $server") ;    

  #file_put_contents("dan.txt", "Watts - ". (hexdec(substr($file, 60, 4))) . "\n" ,FILE_APPEND);
}

$solar_temp = (hexdec(substr($file, 68, 4))/10) ;
exec("curl -d \"varname=solar_temp&value=$solar_temp&action=Send\" $server") ;    
#file_put_contents("dan.txt", "Temp - ". (hexdec(substr($file, 68, 4))/10) . "\n" ,FILE_APPEND);


$solar_kwhday = (hexdec(substr($file, 116, 4))/10) ;
exec("curl -d \"varname=solar_kwhday&value=$solar_kwhday&action=Send\" $server") ;    

#file_put_contents("dan.txt", "kWh Day - ". (hexdec(substr($file, 116, 4))/10) . "\n" ,FILE_APPEND);


$solar_kwhtot = ((hexdec(substr($file, 80, 8))/10) - 20820) ;
if  ( $solar_kwhtot  >  '1' )  {
  exec("curl -d \"varname=solar_kwhtot&value=$solar_kwhtot&action=Send\" $server") ;    

  #file_put_contents("dan.txt", "kWh Total - ". ((hexdec(substr($file, 80, 8))/10) - 20820 ) . "\n" ,FILE_APPEND);
}

#file_put_contents("dan.txt", "Hours - ". (hexdec(substr($file, 88, 8))) . "\n" ,FILE_APPEND);

}
?>
