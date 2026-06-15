
<html>
<head>
<meta http-equiv="refresh" content="30">
</head>

<body style="background-color:#999966">

<?php
$oncol="#555511";
$offcol="#999933";

$offval = 0;
$vdival = 70;
$dimval = 100;
$midval = 150;
$brival = 180;
$fulval = 250;

$html = @file_get_contents('http://varhost/varshare/varshow.php') ?: '';
$html = preg_replace("/[^A-Za-z0-9<>|_.]/", "", $html);

$list = explode("<br>",$html);
array_pop($list);

$hash = [];

foreach($list AS $data) {
    $array = preg_split("/\|\|/",$data);
    if (count($array) < 2) continue;

    $vals = preg_split("/\|/",$array[1]);
    $hash[$array[0]] = $vals[0];
}

$gtemp = isset($hash["temp52"]) ? $hash["temp52"] : "--";

/* ✅ CORRECT FORM START */
echo 'new_proc.php';
echo '<table border="0">';

function lightbuttons($dmxnum,$location){
  global $fulval,$brival,$midval,$dimval,$vdival,$offval,$oncol,$offcol,$hash;

  $curval = isset($hash["dmx$dmxnum"]) ? $hash["dmx$dmxnum"] : 0;

  echo "<tr><td><h2>$location</h2></td>";

  echo "<td><button style='background:$offcol;width:100px;height:80px' name='dmx$dmxnum' value='$offval'>Off</button></td>";
  echo "<td><button style='background:$offcol;width:100px;height:80px' name='dmx$dmxnum' value='$vdival'>VDim</button></td>";
  echo "<td><button style='background:$offcol;width:100px;height:80px' name='dmx$dmxnum' value='$dimval'>Dim</button></td>";
  echo "<td><button style='background:$offcol;width:100px;height:80px' name='dmx$dmxnum' value='$midval'>Mid</button></td>";
  echo "<td><button style='background:$offcol;width:100px;height:80px' name='dmx$dmxnum' value='$brival'>Bright</button></td>";
  echo "<td><button style='background:$offcol;width:100px;height:80px' name='dmx$dmxnum' value='$fulval'>Full</button></td>";

  echo "</tr>";
}

function buttons($pokenum,$location){
  global $oncol,$offcol,$hash;

  echo "<tr><td><h2>$location</h2></td>";

  echo "<td><button style='background:$offcol;width:100px;height:80px' name='out$pokenum' value='0'>Off</button></td>";
  echo "<td><button style='background:$offcol;width:100px;height:80px' name='out$pokenum' value='1'>On</button></td>";

  echo "</tr>";
}

/* Devices */
lightbuttons("3","Front Porch");
lightbuttons("5","Hallway");

buttons("201","Cellar");

/* ✅ CLOSE FORM PROPERLY */
echo "</table>";
echo "</form>";

echo "Temp: $gtemp °C";

?>

</body>
</html>
