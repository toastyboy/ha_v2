<html><body>
<META HTTP-EQUIV="refresh" CONTENT="30">
<FONT SIZE=14>
<body style="background-color:#999966"> 


<?php

$oncol="#555511" ;
$offcol="#999933" ;

$offval = 0 ;
$vdival = 70 ;
$dimval = 100 ; 
$midval = 150 ;
$brival = 180 ; 
$fulval = 250 ;

$html = file_get_contents('http://varhost/varshare/varshow.php');
$html = preg_replace("/[^A-Za-z0-9<>|_.]/", "", $html);
$list = explode("<br>",$html);

foreach($list AS $data) {
    $data = rtrim($data) ;
    $array = preg_split("/\|\|/",$data);
        //echo "Varname: " . $array[0] . "<br/>";
        //echo "Val: " . $array[1] . "<br/>";
        $vals = preg_split("/\|/",$array[1]);
        // echo "Real Val: " . $vals[0] . "<br/>";
        $hash[$array[0]] = $vals[0] ;
        $hash[$array[0]."_time"] = $vals[4] ;
}



$t1 = $hash["temp61"] ; // toplanding temp
$door = $hash["sheddoor"] ; // shed door open or closed 0 is open 1 is closed
$doortime = $hash["sheddoor_time"] ;
echo '<form name="htmlform" action="new_proc.php" method="POST">' . "\n" ;
echo '<table border="0">' . "\n" ;
echo '<tr>' . "\n" ;


function lightbuttons( $dmxnum , $location ) {
  global $fulval, $brival, $midval, $dimval, $vdival, $offval ;
  global $oncol, $offcol , $hash ;
  $curval = $hash["dmx$dmxnum"] ; // first floor landing light
  $curval = rtrim($curval) ;
  $off = $vdi = $dim = $mid = $bri = $ful = $offcol ;
  if ( $curval >= $fulval ) {
    $ful = $oncol ;
  }
  elseif ( $curval >= $brival ) {
    $bri = $oncol ;
  }
  elseif ( $curval >= $midval ) {
    $mid = $oncol ;
  }
  elseif ( $curval >= $dimval ) {
    $dim = $oncol ;
  }
  elseif ( $curval >= $vdival ) {
    $vdi = $oncol ;
  }
  else {
    $off = $oncol ;
  }
  echo '<td><b><h1> ' . $location . ' </b></td>' . "\n" ;
  echo '<td>  <button type="submit" style="background-color:' .  $off . 
       ';width:100px;height:80px;font-size:30" name="dmx' . $dmxnum . 
       '" value=' . $offval . '>Off</button> </td>' . "\n" ;

  echo '<td>  <button type="submit" style="background-color:' . $vdi . 
       ';width:100px;height:80px;font-size:30" name="dmx' . $dmxnum .
       '" value=' . $vdival . '>V_Dim</button> </td>' . "\n" ;

  echo '<td>  <button type="submit" style="background-color:' . $dim .
       ';width:100px;height:80px;font-size:30" name="dmx' . $dmxnum .
       '" value=' . $dimval . '>Dim</button> </td>' . "\n" ;

  echo '<td>  <button type="submit" style="background-color:' . $mid . 
       ';width:100px;height:80px;font-size:30" name="dmx' . $dmxnum . 
       '" value=' . $midval . '>Mid</button> </td>' . "\n" ;

  echo '<td>  <button type="submit" style="background-color:' . $bri . 
       ';width:100px;height:80px;font-size:30" name="dmx' . $dmxnum . 
       '" value=' . $brival . '>Bright</button> </td>' . "\n" ;

  echo '<td>  <button type="submit" style="background-color:' . $ful . 
       ';width:100px;height:80px;font-size:30" name="dmx' . $dmxnum .
       '" value=' . $fulval . '>Full</button> </td>' . "\n" ;

  echo '</tr>' . "\n" ;
}


function buttons( $pokenum , $location ) {
  global $oncol, $offcol , $hash ;

  $curval = $hash["out$pokenum"] ;
  $curval = rtrim($curval) ;
  $off =  $on = $offcol ;
  if ( $curval == "1" ) {
    $on = $oncol ;
  }
  elseif ( $curval == "0" ) {
    $off = $oncol ;
  }

  echo '<td><b><h1> ' . $location . ' </b></td>' . "\n" ;

  echo '<td>  <button type="submit" style="background-color:' . $off .
       ';width:100px;height:80px;font-size:30" name="out' . $pokenum .
       '" value="0">Off</button> </td>' . "\n" ;

  echo '<td>  <button type="submit" style="background-color:' . $on .
       ';width:100px;height:80px;font-size:30" name="out' . $pokenum .
       '" value="1">On</button> </td>' . "\n" ;

  echo '</tr>' . "\n" ;

}




#buttons ( "1" , "Alarm Supply" ) ;
#buttons ( "2" , "UFH" ) ; 
buttons ( "60" , "Inside Lights" ) ;
buttons ( "61" , "Outside Main" ) ;
buttons ( "62" , "Outside Side" ) ;




#lightbuttons( "1" ,  "Back Lounge") ;
#lightbuttons( "2" ,  "Front Porch") ;

echo '</table>' . "\n" ;

echo '</form>' . "\n" ;

echo '<form>' . "\n" ;

echo '<table border="0">' . "\n" ;
echo '<tr>' . "\n" ;

echo '<td>' . "\n" ;
echo '<input type="button" Value="Porch" 
      style="background-color:#999933;width:180px;height:100px;font-size:30" 
      Onclick="window.location.href=\'porch.php\'">' . "\n" ;

echo '</td>' . "\n" ;

echo '<td>' . "\n" ;
echo '<input type="button" Value="Lounge" 
      style="background-color:#999933;width:180px;height:100px;font-size:30" 
      Onclick="window.location.href=\'lounge.php\'">' . "\n" ;

echo '</td>' . "\n" ;

echo '<td>' . "\n" ;
echo '<input type="button" Value="Kitchen" 
      style="background-color:#999933;width:180px;height:100px;font-size:30" 
      Onclick="window.location.href=\'kitchen.php\'">' . "\n" ;
echo '</td>' . "\n" ;

echo '<td>' . "\n" ;
echo '<input type="button" Value="Landing" 
      style="background-color:#999933;width:180px;height:100px;font-size:30" 
      Onclick="window.location.href=\'landing.php\'">' . "\n" ;
echo '</td>' . "\n" ;

echo '<td>' . "\n" ;
echo '<input type="button" Value="Top Landing" 
      style="background-color:#999933;width:180px;height:100px;font-size:30" 
      Onclick="window.location.href=\'toplanding.php\'">' . "\n" ;
echo '</td>' . "\n" ;
echo '</tr>' . "\n" ;

echo '<td>' . "\n" ;
echo '<input type="button" Value="Advanced" 
      style="background-color:#999933;width:180px;height:70px;font-size:30" 
      Onclick="window.location.href=\'advanced.html\'">' . "\n" ;
echo '</td>' . "\n" ;

echo '</tr>' . "\n" ;
echo '</table>' . "\n" ;


echo '</form>' . "\n" ;


echo 'Current Temp - ' , $t1 , 'C <br>' . "\n" ;

$curtime = time() ;
$acttime = $curtime-$doortime ;
    if ( $acttime > 86400 ) { $tunit="days" ; $acttime = $acttime / 86400 ; }
    elseif ( $acttime > 3600 ) { $tunit="hours" ; $acttime = $acttime / 3600 ; }
    elseif ( $acttime > 60 ) { $tunit="mins" ; $acttime = $acttime / 60 ; }
    else { $tunit="secs" ; }
    $acttime = round($acttime, 1) ;
    $acttime = $acttime . " " . $tunit ;

if ( $door == "0" ) { $door = "Closed" ; } 
if ( $door == "1" ) { $door = "Open" ; } 
echo 'Door - ' , $door , '  ' , $acttime , '<br>' . "\n" ;

echo '</body></html>' . "\n" ;
?>
