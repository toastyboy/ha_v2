<!doctype html>

<?php


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
}
$t1 = $hash["temp53"] ; // toplanding temp



$elec_5sec = $hash["elec_5sec"] ;
$elec_1hour = $hash["elec_1hour"] ;
$elec_meter = $hash["elec_meter"] ;
$elec_meter_o = $hash["elec_meter_o"] ;

$gen_elec_5sec = $hash["gen_elec_5sec"] ;
$gen_elec_1min = $hash["gen_elec_1min"] ;
$gen_elec_1hour = $hash["gen_elec_1hour"] ; 
$gen_elec_meter = $hash["gen_elec_meter"] ;



?>

<html>
  <head>
    <title>Electricty Meter</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <META HTTP-EQUIV="refresh" CONTENT="10">
    <style>
      body {
        text-align: center;
      }

      #g1, #g5 {
        width:400px; height:320px;
        display: inline-block;
        margin: 1em;
      }

      #g2, #g3, #g4, #g6, #g7, #g8 {
        width:100px; height:80px;
        display: inline-block;
        margin: 1em;
      }

      p {
        display: block;
        width: 450px;
        margin: 2em auto;
        text-align: left;
      }
    </style>


  </head>
  <body>
    <div id="g1"></div>
    <div id="g2"></div>
    <div id="g3"></div>
    <div id="g4"></div>
    <div id="g5"></div>
    <div id="g6"></div>
    <div id="g7"></div>
    <div id="g8"></div>
    <p>

    <script src="justgage/raphael-2.1.4.min.js"></script>
    <script src="justgage/justgage.js"></script>
    <script>
      var g1, g2, g3, g4, g5, g6, g7, g8;

      window.onload = function(){
        var g1 = new JustGage({
          id: "g1",
<?php
          echo "value: $elec_5sec," ;
?>
          min: 0,
          max: 10,
          decimals: 2,
          title: "Electricity Usage",
          label: "Kwh"
        });

        var g2 = new JustGage({
          id: "g2",
<?php
          echo "value: $elec_1hour," ;
?>
          min: 0,
          max: 20,
          decimals: 2,
          title: "1hour Average",
          label: "Kwh"
        });

        var g3 = new JustGage({
          id: "g3",
<?php
          echo "value: $elec_meter," ;
?>
          min: 00000,
          max: 100000,
          decimals: 2,
          title: "On Peak",
          label: "Kwh"
        });

        var g4 = new JustGage({
          id: "g4",
<?php
          echo "value: $elec_meter_o," ;
?>
          min: 00000,
          max: 100000,
          decimals: 2,
          title: "Off Peak",
          label: "Kwh"
        });


<?php
          echo "" ;
?>

        var g5 = new JustGage({
          id: "g5",
<?php
          echo "value: $gen_elec_5sec," ;
?>
          min: 0,
          max: 10,
          decimals: 2,
          title: "Electricity Generation",
          label: "Kwh"
        });

        var g6 = new JustGage({
          id: "g6",
<?php
          echo "value: $gen_elec_1min," ;
?>
          min: 0,
          max: 20,
          decimals: 2,
          title: "1min Average",
          label: "Kwh"
        });

        var g7 = new JustGage({
          id: "g7",
<?php
          echo "value: $gen_elec_1hour," ;
?>
          min: 0,
          max: 20,
          decimals: 2,
          title: "1hour Average",
          label: "Kwh"
        });

        var g8 = new JustGage({
          id: "g8",
<?php
          echo "value: $gen_elec_meter," ;
?>
          min: 00000,
          max: 100000,
          decimals: 2,
          title: "Meter Reading",
          label: "Kwh"
        });

      };
    </script>
  </body>
</html>

