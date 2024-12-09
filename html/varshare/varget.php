<?php

################################################################################
#
# File: varget.php
# Author: D. McGrath
# Date: 30.10.2019
#
# Revision: 1.0 - Initial Production Version (30.10.2019)
#
# Revision: 1.1 - 
#
#
################################################################################
#        1         2         3         4         5         6         7         8
################################################################################

#Config Variables
#$varstore = "/var/www/varshare/vars/" ;
$varstore = "/var/www/html/varshare/vars/" ;

$action=$_REQUEST['action']; 
if ($action=="")    /* display form */ 
    { 
    ?> 
    <form  action="" method="POST" enctype="multipart/form-data"> 
    <input type="hidden" name="action" value="submit"> 
    Variable Name:<br> 
    <input name="varname" type="text" value="" size="30"/><br> 
    <input type="submit" value="Send"/> 
    </form> 
    <?php 
    }  
else                /* send the submitted data */ 
    { 
    $varname=$_REQUEST['varname']; 
    if ($varname=="") 
        { 
        echo "All fields are required"; 
        } 
    else{         
        chdir( $varstore );
        $current = file_get_contents($varname);
        echo "$current" ;
        } 
    }   
?> 
