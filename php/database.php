<?php

class Database
{
	
	    public $conn;
    function __construct() {
	    
	    	   ini_set("display_startup_errors", 1);
    ini_set("display_errors", 1);

    
    error_reporting(E_ALL);
	    
	    
    session_start();
    $servername = "localhost";
    $dbname = "account";
    $username = "root";
    $password = "root";



    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
      if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
       }else{
        $this->conn=$conn;
       }

    }
}
?>
