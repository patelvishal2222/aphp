<?php

class Database
{
	
	    public $conn;
    function __construct() {
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