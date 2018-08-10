<?php
  
    $servername = "localhost";
    $dbname = "test";
    $username = "root";
    $password = "root";
  

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
      if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
       }else{
       // $this->conn=$conn;  
       }




	$request_method=$_SERVER["REQUEST_METHOD"];
	
	echo $request_method;
	switch($request_method)
	{
		case 'GET':
			// Retrive Products
			/*
			if(!empty($_GET["product_id"]))
			{
				$product_id=intval($_GET["product_id"]);
				get_products($product_id);
			}
			else
			{
				get_products();
			}
			*/
			 echo "get";
			break;
		case 'POST':
			// Insert Product
			//insert_product();
			echo "POST";
			break;
		case 'PUT':
			// Update Product
			//$product_id=intval($_GET["product_id"]);
			//update_product($product_id);
			echo "PUT";
			break;
		case 'DELETE':
			// Delete Product
			//$product_id=intval($_GET["product_id"]);
			//delete_product($product_id);
			echo "DELETE";
			break;
		default:
			// Invalid Request Method
			header("HTTP/1.0 405 Method Not Allowed");
			break;
	}
	
	
	

?>