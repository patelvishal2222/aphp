<?php
  
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
       // $this->conn=$conn;  
       }




	$request_method=$_SERVER["REQUEST_METHOD"];
	
	
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
				$data = json_decode(file_get_contents('php://input'), true);
				foreach( $data as $key=>$value){
						if( is_array($value))
						{
						//echo 'array'.$key . " = " . $value. "<br>";
							InsertUpdate($key,$value);
						}
					else if(is_object($value)) 
					{
					//echo 'OBject'.$key . " = " . $value. "<br>";
					}
					
					else
					{
						//echo 'Other'.$key . " = " . $value. "<br>";
					}
				}

//echo "End";
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
	
	  function InsertUpdate($tb,$data)
	{
		$f="";
		$v="";
		$fv="";
		$PrimaryKey=$tb.'Id';
		$PrimaryKeyValue=0;
		foreach( $data as $key=>$value){
			
				if($key==$PrimaryKey)
				{$PrimaryKeyValue=$value;
				}
				else
				{
				$f=$f.$key.",";
				$v=$v."'".$value."',";
				$fv=$fv.$key."='".$value."',";
				}
		}
		$f1=rtrim($f,",");
		$v1=rtrim($v,",");
		$fv=rtrim($fv,",");
		
		
		$Query="";
		if($PrimaryKeyValue==0)
			$Query= "INSERT INTO $tb ($f1) values ($v1)";
		else
			$Query= "UPDATE $tb SET $fv where $PrimaryKey= $PrimaryKeyValue";
		echo $Query;
	}
	

	

?>
