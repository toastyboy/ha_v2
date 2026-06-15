
<html>
<head>
<meta http-equiv="refresh" content="30">
<style>
body {
    background:#f2f2f2;
    font-family: sans-serif;
    color:#000;
}

table {
    width:100%;
    border-collapse:collapse;
}

.section {
    font-size:26px;
    padding:10px 0;
    border-bottom:2px solid #ccc;
}

.btn {
    width:110px;
    height:80px;
    font-size:22px;
    border-radius:12px;
    border:2px solid #333;
    background:#ddd;
}

.navbtn {
    width:180px;
    height:90px;
    font-size:24px;
    border-radius:12px;
    border:2px solid #333;
    background:#ddd;
}

.active {
    background:#666;
    color:#fff;
}
</style>
</head>

<body>

<?php
$oncol="active";
$offcol="";
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
    $data = rtrim($data);
    $array = preg_split("/\|\|/",$data);
    $vals = preg_split("/\|/",$array[1]);
    $hash[$array[0]] = $vals[0];
}

$gtemp = $hash["temp52"];

/* ✅ FIXED FORM LINE */
echo '<form action="new_proc.php" method="POST">';
echo '<table>';

function lightbuttons($dmxnum,$location){
  global $fulval,$brival,$midval,$dimval,$vdival,$offval,$oncol,$offcol,$hash;

  $curval = rtrim($hash["dmx$dmxnum"]);

  $state = ["off"=>$offcol,"vdi"=>$offcol,"dim"=>$offcol,"mid"=>$offcol,"bri"=>$offcol,"ful"=>$offcol];

  if ($curval >= $fulval) $state["ful"]=$oncol;
  elseif ($curval >= $brival) $state["bri"]=$oncol;
  elseif ($curval >= $midval) $state["mid"]=$oncol;
  elseif ($curval >= $dimval) $state["dim"]=$oncol;
  elseif ($curval >= $vdival) $state["vdi"]=$oncol;
  else $state["off"]=$oncol;

  echo "<tr><td class='section' colspan='6'>$location</td></tr><tr>";

  echo "<td><button class='btn {$state['off']}' name='dmx$dmxnum' value='$offval'>Off</button></td>";
  echo "<td><button class='btn {$state['vdi']}' name='dmx$dmxnum' value='$vdival'>VDim</button></td>";
  echo "<td><button class='btn {$state['dim']}' name='dmx$dmxnum' value='$dimval'>Dim</button></td>";
  echo "<td><button class='btn {$state['mid']}' name='dmx$dmxnum' value='$midval'>Mid</button></td>";
  echo "<td><button class='btn {$state['bri']}' name='dmx$dmxnum' value='$brival'>Bright</button></td>";
  echo "<td><button class='btn {$state['ful']}' name='dmx$dmxnum' value='$fulval'>Full</button></td>";

  echo "</tr>";
}

function buttons($pokenum,$location){
  global $oncol,$offcol,$hash;

  $curval = rtrim($hash["out$pokenum"]);
  $off=$offcol; $on=$offcol;

  if ($curval=="1") $on=$oncol;
  else $off=$oncol;

  echo "<tr><td class='section' colspan='2'>$location</td></tr><tr>";

  echo "<td><button class='btn $off' name='out$pokenum' value='0'>Off</button></td>";
  echo "<td><button class='btn $on' name='out$pokenum' value='1'>On</button></td>";

  echo "</tr>";
}

/* Lights */
lightbuttons("3","Front Porch");
lightbuttons("5","Hallway");
lightbuttons("7","Front Room");
lightbuttons("1","Lounge");
lightbuttons("21","Dining");
lightbuttons("19","Kitchen");

/* Switches */
buttons("201","Cellar");
buttons("5","Heating");

/* Themes */
echo "<tr><td class='section' colspan='4'>Themes</td></tr><tr>";
foreach(["off","morning","evening","night"] as $t){
    echo "<td><button class='btn' name='theme' value='$t'>$t</button></td>";
}
echo "</tr>";

echo "</table></form>";

/* Navigation */
echo "<br><table><tr>";
foreach([
"porch.php"=>"Porch",
"lounge.php"=>"Lounge",
"kitchen.php"=>"Kitchen",
"hallway.php"=>"Hallway",
"landing.php"=>"Landing",
"toplanding.php"=>"Top Landing"
] as $link=>$name){
    echo "<td><button class='navbtn' onclick=\"location.href='$2px;'>Temperature: $gtemp °C</p>";
?>

</body>
</html>
