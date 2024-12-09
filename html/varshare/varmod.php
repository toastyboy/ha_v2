<?php

#########################################################################
#
# Version: 1.0
# Date   : 19/09/2018
#
# This script produces a page of html containing all variables contained
# within the $varstore dir in the form:
#
# varname1||value1
# varname2||value2
# ....
#
# Additionally it provides a form which can be used to modify them.
#
#########################################################################

#Config Variables
$varstore="/var/www/varshare/vars/" ;
#$varstore="/var/www/html/varshare/vars/" ;

chdir ($varstore) ;
$files = glob( '*' ) ;

foreach( $files as $fname ) 
{
  echo $fname . "||" ;
  $vals = file_get_contents( $fname ) ;
  $vals = rtrim($vals) ;
  echo $vals ;
  echo "<br> \n" ;
}


if(isset($_POST['submit']))
{
  $var1 = $_POST['var1']; # Var name
  $var2 = $_POST['var2']; # Value
  $var3 = $_POST['var3']; # }
  $var4 = $_POST['var4']; # } 1,2,3 special vals
  $var5 = $_POST['var5']; # }
  $var6 = $_POST['var6']; # Time
  #echo "User Has submitted the form and entered this :";
  #echo "<br>$var1$var2$var3$var4$var5$var6";

  $val5 = time() ;

  $varname = $var1 ; 
  $value = $var2 . "|" . $var3 . "|" . $var4 . "|" . $var5 . "|" . $var6 ; 
  chdir( $varstore ) ;
  // Format is value|sp1|sp2|sp3|epoch
  // i.e -  12|1|1|1|1541772288
  $data = file_get_contents( $varname ) ; // read in old values 
  # echo "<br>data is $data <br>";
  $old_values = explode( "|" , $data ) ; 
  $val1 = $old_values[0] ;
  $val2 = $old_values[1] ;
  $val3 = $old_values[2] ;
  $val4 = $old_values[3] ;
  $new_values = explode( "|" , $value ) ;
  if ( array_key_exists( "0" , $new_values )) {
    if ($new_values[0] != "") {
      $val1 = $new_values[0] ; 
    }
  } 
  if ( array_key_exists( "1" , $new_values )) {
    if ($new_values[1] != "") {
      $val2 = $new_values[1] ; 
    }
  } 
  if ( array_key_exists( "2" , $new_values )) {
    if ($new_values[2] != "") {
      $val3 = $new_values[2] ; 
    }
  } 
  if ( array_key_exists( "3" , $new_values )) {
    if ($new_values[3] != "") {
      $val4 = $new_values[3] ; 
    }
  } 
  if ( array_key_exists( "4" , $new_values )) {
    if ($new_values[4] != "") {
      $val5 = $new_values[4] ; 
    }
  }        

  file_put_contents($varname, $val1."|".$val2."|".$val3."|".$val4."|".$val5);

  $var1 = $var2 = $var3 = $var4 = $var5 = NULL ;

}
?>

<br><p><br>
<form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
   Var Name: <input type="text" name="var1"><br>
   Value: <input type="text" name="var2"><br>
   S Val1: <input type="text" name="var3"><br>
   S Val2: <input type="text" name="var4"><br>
   S Val3: <input type="text" name="var5"><br>
   Timestamp: <input type="text" name="var6"><br>
   <input type="submit" name="submit" value="Submit Form"><br>
</form>

