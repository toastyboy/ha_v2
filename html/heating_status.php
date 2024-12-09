<html><body>
<META HTTP-EQUIV="refresh" CONTENT="5">
<!--  <META HTTP-EQUIV="refresh" CONTENT="5">  -->
<FONT SIZE=14>
<body style="background-color:#999966">




<?php
$oncol="#555511" ;
$offcol="#999933" ;

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
}


$btemp = $hash["temp51"] ;
$gtemp = $hash["temp52"] ;
$ttemp = $hash["temp53"] ; // toplanding temp



# Room Temps
$tb = $hash["temp51"] ;
$tg = $hash["temp52"] ;
$t1 = $hash["temp53"] ;
$t2 = $hash["temp53"] ;

# Tank and pipe Temps
$tank8 = $hash["temp6"] ;
$tank7 = $hash["temp2"] ;
$tank6 = $hash["temp3"] ;
$tank5 = $hash["temp5"] ;
$tank4 = $hash["temp8"] ;
$tank3 = $hash["temp4"] ;
$tank2 = $hash["temp1"] ;
$tank1 = $hash["temp7"] ;

$exch = $hash["temp9"] ;
$flow = $hash["temp10"] ;


# Boiler and pump status

$dhw = $hash["out16"] ;
$ufh = $hash["out2"] ;
$sec = $hash["out3"] ;
$fir = $hash["out4"] ;
$gnd = $hash["out5"] ;
$bas = $hash["out6"] ;
$boil1 = $hash["out7"] ; 
$boil2 = $hash["out8"] ;


echo '<img src="/hmi/a1.png"><img src="/hmi/a2.png"><img src="/hmi/a3.png">' ;
echo '<br>';

if ( $tank8 > '70' ) { echo '<img src="/hmi/b1_70.png">' ; }
elseif ( $tank8 > '60' ) { echo '<img src="/hmi/b1_60.png">' ; }
elseif ( $tank8 > '50' ) { echo '<img src="/hmi/b1_50.png">' ; }
elseif ( $tank8 > '40' ) { echo '<img src="/hmi/b1_40.png">' ; }
else { echo '<img src="/hmi/b1_30.png">' ; }

if ( $boil2 == '1' ) { 
echo '<a href="heating_state/boiler1_state.php"><img src="/hmi/b2_on.png"></a>' ; }
else { 
echo '<a href="heating_state/boiler1_state.php"><img src="/hmi/b2.png"></a>' ; }

if ( $boil1 == '1' ) { 
echo '<a href="heating_state/boiler2_state.php"><img src="/hmi/b3_on.png"></a>' ; }
else { 
echo '<a href="heating_state/boiler2_state.php"><img src="/hmi/b3.png"></a>' ; }
echo '<br>';

if ( $tank7 > '70' ) { echo '<img src="/hmi/c1_70.png">' ; }
elseif ( $tank7 > '60' ) { echo '<img src="/hmi/c1_60.png">' ; }
elseif ( $tank7 > '50' ) { echo '<img src="/hmi/c1_50.png">' ; }
elseif ( $tank7 > '40' ) { echo '<img src="/hmi/c1_40.png">' ; }
else { echo '<img src="/hmi/c1_30.png">' ; }

echo '<img src="/hmi/c2.png"><img src="/hmi/c3.png">' ;
echo '<br>';

if ( $tank6 > '70' ) { echo '<img src="/hmi/d1_70.png">' ; }
elseif ( $tank6 > '60' ) { echo '<img src="/hmi/d1_60.png">' ; }
elseif ( $tank6 > '50' ) { echo '<img src="/hmi/d1_50.png">' ; }
elseif ( $tank6 > '40' ) { echo '<img src="/hmi/d1_40.png">' ; }
else { echo '<img src="/hmi/d1_30.png">' ; }

echo '<img src="/hmi/d2.png"><img src="/hmi/d3.png">' ;
echo '<br>';


if ( $tank5 > '70' ) { echo '<img src="/hmi/e1_70.png">' ; }
elseif ( $tank5 > '60' ) { echo '<img src="/hmi/e1_60.png">' ; }
elseif ( $tank5 > '50' ) { echo '<img src="/hmi/e1_50.png">' ; }
elseif ( $tank5 > '40' ) { echo '<img src="/hmi/e1_40.png">' ; }
else { echo '<img src="/hmi/e1_30.png">' ; }

if ( $boil2 == '1' ) { echo '<img src="/hmi/e2_on.png">' ; }
else { echo '<img src="/hmi/e2.png">' ; }

if ( $boil1 == '1' ) { echo '<img src="/hmi/e3_on.png">' ; }
else { echo '<img src="/hmi/e3.png">' ; }
echo '<br>';


if ( $tank4 > '70' ) { echo '<img src="/hmi/f1_70.png">' ; }
elseif ( $tank4 > '60' ) { echo '<img src="/hmi/f1_60.png">' ; }
elseif ( $tank4 > '50' ) { echo '<img src="/hmi/f1_50.png">' ; }
elseif ( $tank4 > '40' ) { echo '<img src="/hmi/f1_40.png">' ; }
else { echo '<img src="/hmi/f1_30.png">' ; }

echo '<img src="/hmi/f2.png"><img src="/hmi/f3.png">' ;
echo '<br>';


if ( $tank3 > '70' ) { echo '<img src="/hmi/g1_70.png">' ; }
elseif ( $tank3 > '60' ) { echo '<img src="/hmi/g1_60.png">' ; }
elseif ( $tank3 > '50' ) { echo '<img src="/hmi/g1_50.png">' ; }
elseif ( $tank3 > '40' ) { echo '<img src="/hmi/g1_40.png">' ; }
else { echo '<img src="/hmi/g1_30.png">' ; }

echo '<img src="/hmi/g2.png"><img src="/hmi/g3.png">' ;
echo '<br>';

if ( $tank2 > '70' ) { echo '<img src="/hmi/h1_70.png">' ; }
elseif ( $tank2 > '60' ) { echo '<img src="/hmi/h1_60.png">' ; }
elseif ( $tank2 > '50' ) { echo '<img src="/hmi/h1_50.png">' ; }
elseif ( $tank2 > '40' ) { echo '<img src="/hmi/h1_40.png">' ; }
else { echo '<img src="/hmi/h1_30.png">' ; }

echo '<img src="/hmi/h2.png"><img src="/hmi/h3.png">' ;
echo '<br>';


if ( $tank1 > '70' ) { echo '<img src="/hmi/i1_70.png">' ; }
elseif ( $tank1 > '60' ) { echo '<img src="/hmi/i1_60.png">' ; }
elseif ( $tank1 > '50' ) { echo '<img src="/hmi/i1_50.png">' ; }
elseif ( $tank1 > '40' ) { echo '<img src="/hmi/i1_40.png">' ; }
else { echo '<img src="/hmi/i1_30.png">' ; }

echo '<img src="/hmi/i2.png"><img src="/hmi/i3.png">' ;
echo '<br>';


if ( $tank1 > '70' ) { echo '<img src="/hmi/j1_70.png">' ; }
elseif ( $tank1 > '60' ) { echo '<img src="/hmi/j1_60.png">' ; }
elseif ( $tank1 > '50' ) { echo '<img src="/hmi/j1_50.png">' ; }
elseif ( $tank1 > '40' ) { echo '<img src="/hmi/j1_40.png">' ; }
else { echo '<img src="/hmi/j1_30.png">' ; }

echo '<img src="/hmi/j2.png"><img src="/hmi/j3.png">' ;
echo '<br>';


if ( $tank1 > '70' ) { echo '<img src="/hmi/k1_70.png" title="'.$tank1.'">' ; }
elseif ( $tank1 > '60' ) { echo '<img src="/hmi/k1_60.png" title="'.$tank1.'">' ; }
elseif ( $tank1 > '50' ) { echo '<img src="/hmi/k1_50.png" title="'.$tank1.'">' ; }
elseif ( $tank1 > '40' ) { echo '<img src="/hmi/k1_40.png" title="'.$tank1.'">' ; }
else { echo '<img src="/hmi/k1_30.png" title="'.$tank1.'">' ; }

echo '<img src="/hmi/k2.png"><img src="/hmi/k3.png">' ;
echo '<br>';


if ( $exch > '70' ) { echo '<img src="/hmi/l0_70.png" title="'.$exch.'">' ; }
elseif ( $exch > '60' ) { echo '<img src="/hmi/l0_60.png" title="'.$exch.'">'; }
elseif ( $exch > '50' ) { echo '<img src="/hmi/l0_50.png" title="'.$exch.'">'; }
elseif ( $exch > '40' ) { echo '<img src="/hmi/l0_40.png" title="'.$exch.'">'; }
else { echo '<img src="/hmi/l0_30.png" title="'.$exch.'">'; }

if ( $dhw == '1' ) { 
echo '<a href="heating_state/dhw_state.php"><img src="/hmi/l1_on.png"></a>' ; }
else { 
echo '<a href="heating_state/dhw_state.php"><img src="/hmi/l1.png"></a>' ; }

if ( $bas == '1' ) { 
echo '<a href="heating_state/chb_state.php"><img src="/hmi/l2_on.png"></a>' ; }
else { 
echo '<a href="heating_state/chb_state.php"><img src="/hmi/l2.png"></a>' ; }

if ( $gnd == '1' ) { 
echo '<a href="heating_state/chg_state.php"><img src="/hmi/l3_on.png"></a>' ; }
else { 
echo '<a href="heating_state/chg_state.php"><img src="/hmi/l3.png"></a>' ; }

if ( $fir == '1' ) { 
echo '<a href="heating_state/ch1_state.php"><img src="/hmi/l4_on.png"></a>' ; }
else { 
echo '<a href="heating_state/ch1_state.php"><img src="/hmi/l4.png"></a>' ; }

if ( $sec == '1' ) { 
echo '<a href="heating_state/ch2_state.php"><img src="/hmi/l5_on.png"></a>' ; }
else { 
echo '<a href="heating_state/ch2_state.php"><img src="/hmi/l5.png"></a>' ; }

if ( $ufh == '1' ) { 
echo '<a href="heating_state/ufh_state.php"><img src="/hmi/l6_on.png"></a>' ; }
else { 
echo '<a href="heating_state/ufh_state.php"><img src="/hmi/l6.png"></a>' ; }

?>

<form>

<table border="0">
<tr>
<td>
<input type="button" Value="Porch" style='background-color:#999933;width:180px;height:60px;font-size:30' Onclick="window.location.href='porch.php'">
</td>
<td>
<input type="button" Value="Hallway" style='background-color:#999933;width:180px;height:60px;font-size:30' Onclick="window.location.href='hallway.php'">
</td>
<td>
<input type="button" Value="Lounge" style='background-color:#999933;width:180px;height:60px;font-size:30' Onclick="window.location.href='lounge.php'">
</td>
<td>
<input type="button" Value="Kitchen" style='background-color:#999933;width:180px;height:60px;font-size:30' Onclick="window.location.href='kitchen.php'">
</td>
<td>
<input type="button" Value="Top Landing" style='background-color:#999933;width:180px;height:60px;font-size:30' Onclick="window.location.href='toplanding.php'">
</td>
</tr>
</table>


</form>
</body></html>
