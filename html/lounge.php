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
array_pop($list);

foreach($list AS $data) {
    $data = rtrim($data) ;
    $array = preg_split("/\|\|/",$data);
        //echo "Varname: " . $array[0] . "<br/>";
        //echo "Val: " . $array[1] . "<br/>";
        $vals = preg_split("/\|/",$array[1]);
        // echo "Real Val: " . $vals[0] . "<br/>";
        $hash[$array[0]] = $vals[0] ;
}

$btemp = $hash["temp51"] ;
$gtemp = $hash["temp52"] ;
$ttemp = $hash["temp53"] ; // toplanding temp


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

lightbuttons( "10" , "Front Outside") ;
lightbuttons( "2" ,  "Front Porch") ;
lightbuttons( "5" ,  "Downstairs Hallway") ;
lightbuttons( "7" ,  "Front Room") ;
lightbuttons( "1" ,  "Back Lounge") ;
lightbuttons( "21" ,  "Dining Room") ;
lightbuttons( "19" , "Kitchen") ;

buttons ( "5" , "Ground Floor Heating" ) ;


/*
buttons ( "1" , "Alarm Supply" ) ; // (see 28,29,30,31)
buttons ( "2" , "UFH" ) ; 
buttons ( "3" , "CH2" ) ;
buttons ( "4" , "CH1" ) ;
buttons ( "5" , "CHG" ) ;
buttons ( "6" , "CHB" ) ;
buttons ( "7" , "Boiler 1" ) ;
buttons ( "8" , "Boiler 2" ) ;
buttons ( "9" , "" ) ;
buttons ( "10" , "Workshop Right" ) ;
buttons ( "11" , "Workshop Left" ) ;
buttons ( "12" , "Cellar WC" ) ;
buttons ( "13" , "Cellar Reception" ) ;
buttons ( "14" , "" ) ;
buttons ( "15" , "" ) ;
buttons ( "16" , "DHW" ) ;
buttons ( "17" , "" ) ;
buttons ( "18" , "" ) ;
buttons ( "19" , "Masterbath Ext" ) ;
buttons ( "20" , "" ) ;
buttons ( "21" , "" ) ;
buttons ( "22" , "" ) ;
buttons ( "23" , "" ) ;
buttons ( "24" , "" ) ;
buttons ( "25" , "Alarm Interlock" ) ; // Must be ON with 01&27 ON and 26 OFF
buttons ( "26" , "Alarm Interlock" ) ; // Must be OFF with 01&25 and 27 ON
buttons ( "27" , "Alarm Interlock" ) ; // Must be ON with 01&25 ON and 26 OFF
buttons ( "28" , "Masterblaster" ) ;
buttons ( "29" , "External Sounder" ) ;
buttons ( "30" , "Ext Strobe" ) ;
buttons ( "31" , "Internal Sounder" ) ;
buttons ( "32" , "Cellar Door Lock" ) ;
buttons ( "13" , "Heating" ) ;
lightbuttons( "1" ,  "Back Lounge") ;
lightbuttons( "2" ,  "Front Porch") ;
lightbuttons( "3" ,  "Dining Ceiling Centre") ;
lightbuttons( "4" ,  "Towel Rail") ;
lightbuttons( "5" ,  "Downstairs Hallway") ;
lightbuttons( "6" ,  "Nursery Bedroom") ;
lightbuttons( "7" ,  "Front Room") ;
lightbuttons( "8" ,  "Master Bath") ;
lightbuttons( "9" ,  "1st Floor Landing") ;
lightbuttons( "10" , "Front Outside") ;
lightbuttons( "11" , "Master Bedroom") ;
lightbuttons( "12" , "Spare Bedroom") ;
lightbuttons( "13" , "Em Bedroom") ;
lightbuttons( "14" , "Josh Bedroom") ;
lightbuttons( "15" , "Top Landing") ;
lightbuttons( "16" , "Kids Bathroom") ;
lightbuttons( "17" , "Spare" ) ;
lightbuttons( "18" , "Kitchen Counter") ;
lightbuttons( "19" , "Kitchen Track") ;
lightbuttons( "20" , "Dining Right Ceiling") ;
*/

echo '<td><b><h1> Themes </b></td>' ."\n" ;

echo '<td><button type="submit"
      style="background-color:#999933;width:100px;height:100px;font-size:20"
      name="theme" value="off">Off</button> </td>' . "\n" ;

echo '<td><button type="submit"
      style="background-color:#999933;width:100px;height:100px;font-size:20"
      name="theme" value="morning">Morning</button> </td>' . "\n" ;

echo '<td><button type="submit"
      style="background-color:#999933;width:100px;height:100px;font-size:20"
      name="theme" value="evening">Evening</button> </td>' . "\n" ;

echo '<td><button type="submit"
      style="background-color:#999933;width:100px;height:100px;font-size:20"
      name="theme" value="night">Night</button> </td>' . "\n" ;

echo '</tr>' ."\n" ;

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
echo '<input type="button" Value="Hallway"
      style="background-color:#999933;width:180px;height:100px;font-size:30"
      Onclick="window.location.href=\'hallway.php\'">' . "\n" ;
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
echo 'Current Temp - ' , $gtemp , 'C <br>' . "\n" ;
echo '</body></html>' . "\n" ;
?>
