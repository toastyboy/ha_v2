<html><body>
<META HTTP-EQUIV="refresh" CONTENT="5">
<FONT SIZE=14>
<body style="background-color:#999966">
<h1>Garage Control </h1>

<?php

function time_elapsed($secs){
    $bit = array(
        'y' => $secs / 31556926 % 12,
        'w' => $secs / 604800 % 52,
        'd' => $secs / 86400 % 7,
        'h' => $secs / 3600 % 24,
        'm' => $secs / 60 % 60,
        's' => $secs % 60
        );
        
    foreach($bit as $k => $v)
        if($v > 0)$ret[] = $v . $k;
        
    return join(' ', $ret);
    }


$epoch=time() ; 

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
$t1 = $hash["temp53"] ; // toplanding temp


$st01 = $hash["gal01"] ;
$st02 = $hash["gal02"] ;
$st03 = $hash["gal03"] ; 
$st04 = $hash["gal04"] ;
$st05 = $hash["gal05"] ;
$st06 = $hash["gal06"] ;
$st07 = $hash["gal07"] ;
$st08 = $hash["gal08"] ;
$st37 = $hash["gal37"] ;
$st38 = $hash["gal38"] ;
#put in other sensors  kens and recept 06 and 08

$stga = $hash["garagealarm"] ; 
$stgb = $hash["garagebackdoorlock"] ;
$stgd = $hash["garageuandolocks"] ;


$dur01=$epoch-$hash["gal01_time"] ;
$dur02=$epoch-$hash["gal02_time"] ;
$dur03=$epoch-$hash["gal03_time"] ;
$dur04=$epoch-$hash["gal04_time"] ;
$dur05=$epoch-$hash["gal05_time"] ;
$dur06=$epoch-$hash["gal06_time"] ;
$dur07=$epoch-$hash["gal07_time"] ;
$dur08=$epoch-$hash["gal08_time"] ;
$dur37=$epoch-$hash["gal37_time"] ;
$dur38=$epoch-$hash["gal38_time"] ;


echo "<table><table border='0'> " ;

if ( $st01 == "0" )
{
  echo "<td>Middle Garage Door</td><td>CLOSED</td><td>" .time_elapsed($dur01) ."</td><td></td></tr>" ; 
}
if ( $st01 == "1" )
{
  echo "<td>Middle Garage Door</td><td>OPEN</td><td>" .time_elapsed($dur01) ."</td><td></td></tr>" ;
}


if ( $st02 == "0" )
{
  echo "<td>Big Garage Door</td><td>CLOSED</td><td>" .time_elapsed($dur02) ."</td><td></td></tr>" ;
}
if ( $st02 == "1" )
{
  echo "<td>Big Garage Door</td><td>OPEN</td><td>" .time_elapsed($dur02) ."</td><td></td></tr>" ;
}

if ( $st03 == "0" )
{
  echo "<td>Middle U&O Door</td><td>CLOSED</td><td>" .time_elapsed($dur03) ."</td><td></td></tr>" ;
}
if ( $st03 == "1" )
{
  echo "<td>Middle U&O Door</td><td>OPEN</td><td>" .time_elapsed($dur03) ."</td><td></td></tr>";
}

if ( $st04 == "0" )
{
  echo "<td>Big U&O Door</td><td>CLOSED</td><td>" .time_elapsed($dur04) ."</td>";
}
if ( $st04 == "1" )
{
  echo "<td>Big U&O Door</td><td>OPEN</td><td>" .time_elapsed($dur04) ."</td>" ;
}

if ( $stgd == "0" )
{
  echo "<td>LOCKED </td></tr>" ;
}
if ( $stgd == "1" )
{
  echo "<td>UNLOCKED </td></tr>" ;
}


if ( $st05 == "0" )
{
  echo "<td>Small Garage Door</td><td>CLOSED</td><td>" .time_elapsed($dur05) ."</td><td></td></tr>" ;
}
if ( $st05 == "1" )
{
  echo "<td>Small Garage Door</td><td>OPEN</td><td>" .time_elapsed($dur05) ."</td><td></td></tr>" ;
}


if ( $st07 == "0" )
{
  echo "<td>Garage Back Door</td><td>CLOSED</td><td>" .time_elapsed($dur07) ."</td>";
}
if ( $st07 == "1" )
{
  echo "<td>Garage Back Door</td><td>OPEN</td><td>" .time_elapsed($dur07) ."</td>";
}

if ( $stgb == "0" )
{
  echo "<td>LOCKED </td></tr>" ;
}
if ( $stgb == "1" )
{
  echo "<td>UNLOCKED </td></tr>" ;

}


if ( $st37 == "0" )
{
  echo "<td>Big Garage PIR</td><td> CLOSED</td><td>" .time_elapsed($dur37) ."</td><td></td></tr>";
}
if ( $st37 == "1" )
{
  echo "<td>Big Garage PIR</td><td>OPEN</td><td>" .time_elapsed($dur37) ."</td><td></td></tr>";
}


if ( $st38 == "0" )
{
  echo "<td>Garage Viper</td><td>CLOSED</td><td>" .time_elapsed($dur38) ."</td><td></td></tr>";
}
if ( $st38 == "1" )
{
  echo "<td>Garage Viper</td><td>OPEN</td><td>" .time_elapsed($dur38) ."</td><td></td></tr>";
}


if ( $st08 == "0" )
{
  echo "<td>Kens PIR</td><td>CLOSED</td><td>" .time_elapsed($dur08) ."</td><td></td></tr>";
}
if ( $st08 == "1" )
{
  echo "<td>Kens PIR</td><td>OPEN</td><td>" .time_elapsed($dur08) ."</td><td></td></tr>";
}

if ( $st06 == "0" )
{
  echo "<td>Garage Reception PIR</td><td>CLOSED</td><td>" .time_elapsed($dur06) ."</td><td></td></tr>";
}
if ( $st06 == "1" )
{
  echo "<td>Garage Reception PIR</td><td>OPEN</td><td>" .time_elapsed($dur06) ."</td><td></td></tr>";
}


if ( $stga == "1" )
{
  echo "<td>Garage Alarm</td><td>ARMED </td><td></td></tr>";
}
if ( $stga == "0" )
{
  echo "<td>Garage Alarm</td><td>DISARMED </td><td></td></tr>";
}

echo "</table>" ;
?>

<form action="new_proc.php" method="POST">

<table border="0">
<tr>

<td><b><h1>GARAGE ALARM</b></td>
<td>  <button type='submit' style='background-color:#555511;width:100px;height:100px;' name='garagealarm' value='0'>DEACTIVATE</button> </td>
<td>  <button type='submit' style='background-color:#555511;width:100px;height:100px;' name='garagealarm' value='1'>ACTIVATE</button> </td>
</tr> 

<td><b><h1>U&O DOOR</b></td>
<td>  <button type='submit' style='background-color:#555511;width:100px;height:100px;' name='garageuandolocks' value='1'>OPEN</button> </td>
<td>  <button type='submit' style='background-color:#555511;width:100px;height:100px;' name='garageuandolocks' value='0'>CLOSE</button> </td>
</tr>


<td><b><h1>BACK DOOR</b></td>
<td>  <button type='submit' style='background-color:#555511;width:100px;height:100px;' name='garagebackdoorlock' value='1'>OPEN</button> </td>
<td>  <button type='submit' style='background-color:#555511;width:100px;height:100px;' name='garagebackdoorlock' value='0'>CLOSE</button> </td>
</tr>


</table>


<img src="http://192.168.100.161/GetData.cgi"style="width:450px;height:600px;">
<br>
Change Camera -
 <a href="garage_cams/cam11.php">1</a>,
 <a href="garage_cams/cam12.php">2</a>, 
 <a href="garage_cams/cam13.php">3</a>  </br>

<table border="0">
<tr>

<td>
<input type="button" Value="Porch" style='background-color:#999933;width:180px;height:100px;font-size:30' Onclick="window.location.href='porch.php'">
</td>

<td>
<input type="button" Value="Hallway" style='background-color:#999933;width:180px;height:100px;font-size:30' Onclick="window.location.href='hallway.php'">
</td>

<td>
<input type="button" Value="Kitchen" style='background-color:#999933;width:180px;height:100px;font-size:30' Onclick="window.location.href='kitchen.php'">
</td>

<td>
<input type="button" Value="Landing" style='background-color:#999933;width:180px;height:100px;font-size:30' Onclick="window.location.href='landing.php'">
</td>

<td>
<input type="button" Value="Top Landing" style='background-color:#999933;width:180px;height:100px;font-size:30' Onclick="window.location.href='toplanding.php'">
</td>
</tr>

<td>
<input type="button" Value="Advanced" style='background-color:#999933;width:180px;height:70px;font-size:30' Onclick="window.location.href='advanced.html'"> </td>

</tr>
</table>

</body></html>
