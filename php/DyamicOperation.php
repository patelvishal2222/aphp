
<?php

include 'DyamicClass.php';
include 'DataBaseLayer.php';


	$request_method=$_SERVER["REQUEST_METHOD"];
	
	//echo $request_method;
	switch($request_method)
	{
		case 'GET':
			
			if(!empty($_GET["Query"]))
			{
				
				$Query=$_GET["Query"];
				//$Query=str_replace("@plus@","+",$Query);
				
				$obj=new DyamicClass();
				//echo $Query;
				$rows=$obj->getQuery($Query);
				
				$listdata=$obj->getList($rows);
				echo json_encode($listdata);
			}
			else if(!empty($_GET["getObject"]))
			{
				$TableName=$_GET["getObject"];
				$PrimaryKey=$_GET["PrimaryKey"];
				$PrimaryValue=$_GET["PrimaryValue"];
				$Query="Select *  FROM $TableName WHERE $PrimaryKey=$PrimaryValue";
				//echo $Query;
				$obj=new DyamicClass();
				
				$rows=$obj->getQuery($Query);
				
				$Query=$obj->getForeginkeyQuery($TableName);
				//echo $Query;
				$ForeginKeyTables=$obj->getQuery($Query);
				
				foreach(  $ForeginKeyTables as $fktable )
				{
					//echo json_encode($fktable);
					$FkName=$fktable["COLUMN_NAME"];
					$FkData=$rows[0][$fktable["COLUMN_NAME"]];;
					if( $FkData!=null)
					{
  				$Query="select  *  from $fktable[REFERENCED_TABLE_NAME]  where $fktable[REFERENCED_COLUMN_NAME] =$FkData;";
			
				$FkTableData=$obj->getQuery($Query);
				unset($rows[0][$FkName]);
				$rows[0][substr($FkName,0,-2)]=$FkTableData[0];
					}
				
			   }
				echo json_encode($rows[0]);
				
				
	
			}
			else if(!empty($_GET["getObject1"]))
			{
				
				$MainObject = $_GET["getObject1"];
				 $MainObject=json_decode($MainObject,true);
				$PrimaryValue=$MainObject["PrimaryValue"];
				$PrimaryKey=$MainObject["PrimaryKey"];
				$TableNames=$MainObject["TableNames"];
				//echo json_encode($TableNames);
				$rows=array();
				$MasterTable=array();
				
					foreach( $TableNames as $key=>$value){
							if( is_array($value))
								{
												
											
												foreach(  $value as $object )
												
												{
													$TableName=$object["TableName"];
													$rows[0][$TableName]=getTableValue($TableName,$PrimaryKey,$PrimaryValue,$MasterTable);
													
												}
												
						
					
								}
								else
								{
								$TableName=$value;
								$rows=getTableValue($TableName,$PrimaryKey,$PrimaryValue,$MasterTable);
								$MasterTable=array($TableName);
						
						
								}
					}
			
					
					echo  json_encode($rows[0]);
			}
			else if(!empty($_GET["List"]))
			{
				
				
				$TableName=$_GET["TableName"];
				$Page=$_GET["Page"];
				$PageSize=$_GET["PageSize"];
				$Search=$_GET["Search"];
				$OrderBy=$_GET["OrderBy"];
				
				if(isset($Search))
				{
					if($Search=='')
					{
					}
					else
					{
					$Search=" Where ".$Search;
					}
				}
				if(isset($OrderBy))
				{
					$OrderBy=' Order By '.$OrderBy;
				}
				
				$Page=($Page-1)*$PageSize;
				
			$Query=$_GET["Sql"].$Search.$OrderBy.' Limit '.$Page.','.$PageSize;
				
			//echo $Query;
			
				
				$obj=new DyamicClass();
				$rows=$obj->getQuery($Query);
				$listdata=$obj->getList($rows);
				
				$value=$obj->getValue("select count(1)  from $TableName $Search");
				
				$listdata['total'][]= $value;
				echo json_encode($listdata);
				
				
			}
			else if(!empty($_GET["deleteObject"]))
			{
				$TableName=$_GET["deleteObject"];
				$PrimaryKey=$_GET["PrimaryKey"];
				$PrimaryValue=$_GET["PrimaryValue"];
				$Query="DELETE  FROM $TableName WHERE $PrimaryKey=$PrimaryValue";
				
				$obj=new DyamicClass();
				$value=$obj->executeQuery($Query);
				echo  $value;
				//echo json_encode($rows[0]);
			}
			else if(!empty($_GET["deleteObject1"]))
			{
				
				$MainObject = $_GET["deleteObject1"];
				 $MainObject=json_decode($MainObject,true);
				$PrimaryValue=$MainObject["PrimaryValue"];
				$PrimaryKey=$MainObject["PrimaryKey"];
				$TableNames=$MainObject["TableNames"];
				$obj=new DyamicClass();
				
			for($index=0;$index<count($TableNames);$index++)
			{
				$TableName= $TableNames[$index]["TableName"];
					$Query="DELETE  FROM $TableName WHERE $PrimaryKey=$PrimaryValue";
					$value=$obj->executeQuery($Query);
				echo $Query."<br />";
				
				}
							
			}
			else if(!empty($_GET["backupdb"]))
			{
				
				$obj=new DyamicClass();
				$value=$obj->backupdb();
			}
			else 
			{
			 echo "get Not work";	
			}
			
			 
			break;
		case 'POST':
			// Insert Product
			//insert_product();
				$data = json_decode(file_get_contents('php://input'), true);
				
				foreach( $data as $key=>$value){
						if( is_array($value))
						{
						//echo 'array'.$key . " = " . $value. "<br>";
						$DetailTable=array();
							$Query=InsertUpdate($key,$value,$DetailTable);
							
						//	echo $Query;
							$obj=new DyamicClass();
							$PrimaryKey=GetPrimaryKey($key);
							//echo "ParimaryKey: $PrimaryKey<br/>";
							$value1=$obj->executeQuery($Query);
							$LastInsertIdSql = "SELECT  LAST_INSERT_ID()";
							$Id=$obj->getValue($LastInsertIdSql);
							if($Id[0]==0)
							{
								//echo $Id[0]."<br/>".json_encode($value);
								$Id[0]=$value[$PrimaryKey];
								//echo "<br/>".$key. "==>".$PrimaryKey." :".$Id[0]."<br/>";
							}
							
							foreach($DetailTable as  $Table=>$TableDatas)
							{
								
								if( is_array($TableDatas))
								{
									foreach($TableDatas as $TableData)
									{
										$DetailTable2=array();
									$Query=InsertUpdate2($Table,$TableData,$PrimaryKey,$Id[0],$DetailTable2);
									 echo $Query;
									$value=$obj->executeQuery($Query);
									}
								}
								else
								{
									$Query=$TableDatas;
									 echo $Query;
									$value=$obj->executeQuery($Query);
								}
														}
							echo   $Id[0];
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
	
	
	

?>
