<?php

 class Database
{
	
	    //public $conn;
		public $servername = "localhost";
   public $dbname = "account";
 public   $username = "root";
   public $password = "root";

}

class DyamicClass  extends Database
	{
		
	
    function __construct() {

  
    

    // Create connection
    $conn = new mysqli($this->servername, $this->username, $this->password, $this->dbname);
    // Check connection
      if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
       }else{
        $this->conn=$conn;
       }

    }
	
	public function getForeginkeyQuery($TableName)
	{
		$Query="SELECT  COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='$TableName'  and  table_schema='$this->dbname' and REFERENCED_COLUMN_NAME is not null";
		return $Query;
	}
	public function getPrimaryKey($TableName)
	{
	$Query="SELECT * FROM information_schema.KEY_COLUMN_USAGE where  CONSTRAINT_name='PRIMARY' and CONSTRAINT_schema='$this->dbname' and table_Name='$TableName'";
		return $Query;
	}
	 
	  public function getQuery($Query){
       
//echo "getQuery<br/>";
       $Result=  $this->conn->query($Query);
	  
       $listdata=array();
	   if($Result)
	   { 
				$rows=array();
				while( $row=$Result->fetch_assoc())
				{
					$rows[]=$row;
					
					
				}
		return $rows;
	   }
	   else
	   {
		   echo "Error";
		   return "";
	   }
	   
	   
	  }
       
      
	   
	   public  function getList($rows)
	   {
		    $listdata=array();
		
		
          $listdata['listdata']= $rows;
     
	   
	   

    return $listdata;
    }
	
	public function getValue($Query)
	{
		
		
    $Result=  $this->conn->query($Query);
	
    $value = mysqli_fetch_row($Result);
	return $value;
    
	}
	

	
	public function executeQuery($Query)
	{
		$Result=  $this->conn->query($Query);
      
	   if($Result)
	   
			return true;
			else
			{
				$this->conn->rollback();
				return "Error ".$Query;
			}
			
				
	}
	public function beginTran()
	{
	
		$this->conn->autocommit(false);
	}
	public function commit()
	{
		
		 $this->conn->commit();
	}

	public function  backupdb()
	{
		$date_string   = date("Y-m-d-H-i-s");
		       //C:\Program Files\MySQL\MySQL Workbench SE 6.1.6
		$cmd = "C:\Program Files\MySQL\MySQL Workbench SE 6.1.6\mysqldump   -h {$this->servername} -u {$this->username} -p {$this->password} {$this->dbname} > " . 'h:\\'.$this->dbname . '_'.$date_string.'.sql';
			  echo $cmd.'<br/>';
   
   exec($cmd);
   echo "Backup Sucessfully";
   
  
				
	}
	
	
		
		 function __destruct() {
    mysqli_close($this->conn);
    }
	
	
	





		
	}

//DataLayer

	function getTableValue($TableName,$PrimaryKey,$PrimaryValue,$MasterTable)
	{
		
				$Query="Select *  FROM $TableName WHERE $PrimaryKey=$PrimaryValue";
				//echo $Query;
				$obj=new DyamicClass();
				
				$rows=$obj->getQuery($Query);
				
				//echo $Query;
				$Query=$obj->getForeginkeyQuery($TableName);
				$ForeginKeyTables=$obj->getQuery($Query);
				
					
					for($index=0;$index<count($rows);$index++)
					{
				foreach(  $ForeginKeyTables as $fktable )
				{
					//echo json_encode($fktable);
					$FkName=$fktable["COLUMN_NAME"];
					
					$FkData=$rows[$index][$fktable["COLUMN_NAME"]];;
					 $inMaster=false;
					if(count( $MasterTable)>0)
					{
						
							if(in_array(   $fktable["REFERENCED_TABLE_NAME"],$MasterTable))
							$inMaster=true;
							
					//echo "check  ".in_array(   $fktable[REFERENCED_TABLE_NAME],$MasterTable)." -->  ".  $fktable[REFERENCED_TABLE_NAME] ." --> ".json_encode($MasterTable)."-->".$inMaster.  "<br/>";
					
					
					}
					if( $FkData!=null  &&   $inMaster==false )
					{
  				$Query="select  *  from $fktable[REFERENCED_TABLE_NAME]  where $fktable[REFERENCED_COLUMN_NAME] =$FkData;";
			
				$FkTableData=$obj->getQuery($Query);
				unset($rows[$index][$FkName]);
				$rows[$index]["Virtual".substr($FkName,0,-2)]=$FkTableData[0];
					}
				
			   }
					}
			   return $rows;
			   
	}
	
	
		  function InsertUpdate($tb,$data,$MasterKeyValue,&$DetailTable)
	{
		
		$f="";
		$v="";
		$fv="";
		$PrimaryKey=$tb.'Id';
		$PrimaryKey=GetPrimaryKey($tb);
		$PrimaryKeyValue=0;
		//Remove Id MasterTable
		foreach( $MasterKeyValue as $insertKey=>$insertValue){
			//echo json_encode($MasterKeyValue);
		if( array_search($insertKey,$data))
		{
				
			unset($data[$insertKey]);
			
		}
				$f=$insertKey.",";
			 $v=$insertValue.",";
		}
		
		foreach( $data as $key=>$value){
			
				
				
				if($key==$PrimaryKey)
				{
					$PrimaryKeyValue=$value;
				}
				
				
				else if(isfield($key,$tb)  &&  !$data[substr($key,0,-2)])
				{
					if(isset($value)  && trim($value)!="" )
					{
					$f=$f.$key.",";
					if($key=='BillDate')
					{
						$value=substr($value,0,strpos($value,"T"));
							$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					else{
					$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					}
				}
				else if(isVirtualTable($key))
				{
					$VirtualTable=substr($key,7);
					//echo "VirtualTable=>$VirtualTable <br/>";
				
			    $f=$f.$VirtualTable."Id,";
				$v=$v."'".$value[$VirtualTable."Id"]."',";
				$fv=$fv.$VirtualTable."Id='".$value[$VirtualTable."Id"]."',";
				
				
				}
				else if(substr($key,-3)=="Ids")
				{
					  if($value!=""  )
					  {
						  
					   $DeleteTable=substr($key,0,-3);
					   $DetailTable[$key]="Delete FROM $DeleteTable WHERE ".$DeleteTable."Id in( ".$value.")";
					   //echo  $DeleteTable." ".$value."<br/>";
					  }
					 
					
				}
				else if(isTable($key))
			   {
				   if(is_array($value))
					  if(count($value)>0)
				   $DetailTable[$key]=$value;
				   
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
		//echo $Query."<br/>";
		
		return $Query;
		
	}
	/*
	
	  function InsertUpdate3($tb,$data,&$DetailTable)
	{
		$f="";
		$v="";
		$fv="";
		$PrimaryKey=$tb.'Id';
		$PrimaryKey=GetPrimaryKey($tb);
		$PrimaryKeyValue=0;
		
		foreach( $data as $key=>$value){
			
				
				if($key==$PrimaryKey)
				{
					$PrimaryKeyValue=$value;
				}
				
				
				else if(isfield($key,$tb)  &&  !$data[substr($key,0,-2)])
				{
					if(isset($value)  && trim($value)!="" )
					{
					$f=$f.$key.",";
					if($key=='BillDate')
					{
						$value=substr($value,0,strpos($value,"T"));
							$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					else{
					$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					}
				}
				else if(isVirtualTable($key))
				{
				
			   $VirtualTable=substr($key,7);
					
				
			    $f=$f.$VirtualTable."Id,";
				$v=$v."'".$value[$VirtualTable."Id"]."',";
				$fv=$fv.$VirtualTable."Id='".$value[$VirtualTable."Id"]."',";
				
				
				}
				else if(substr($key,-3)=="Ids")
				{
					  if($value!=""  )
					  {
						  
					   $DeleteTable=substr($key,0,-3);
					   $DetailTable[$key]="Delete FROM $DeleteTable WHERE ".$DeleteTable."Id in( ".$value.")";
					   
					  }
					 
					
				}
				else if(isTable($key))
			   {
				 
				   if(is_array($value))
					  if(count($value)>0)
				   $DetailTable[$key]=$value;
				   
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
		
		return $Query;
	}
	
	
		  function InsertUpdate2($tb,$data,$insertKey,$insertValue,&$DetailTable)
	{
		
		
		
		$f="";
		$f=$insertKey.",";
	
		$v="";
	    $v=$insertValue.",";
	  
		$fv="";
		$PrimaryKey=$tb.'Id';
		
		$PrimaryKey=GetPrimaryKey($tb);
	
		$PrimaryKeyValue=0;
		
		if( array_search($insertKey,$data))
		{
				
			unset($data[$insertKey]);
			
		}
		
		foreach( $data as $key=>$value){
			
				
				
				if($key==$PrimaryKey)
				{
					$PrimaryKeyValue=$value;
				}
				
				
				else if(isfield($key,$tb)  &&  !$data[substr($key,0,-2)])
				{
					if(isset($value)  && trim($value)!="" )
					{
					$f=$f.$key.",";
					if($key=='BillDate')
					{
						$value=substr($value,0,strpos($value,"T"));
							$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					else{
					$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					}
				}
				else if(isVirtualTable($key))
				{
					$VirtualTable=substr($key,7);
					
				
			    $f=$f.$VirtualTable."Id,";
				$v=$v."'".$value[$VirtualTable."Id"]."',";
				$fv=$fv.$VirtualTable."Id='".$value[$VirtualTable."Id"]."',";
				
				
				}
				else if(isTable($key))
			   {
				   if(is_array($value))
					  if(count($value)>0)
				   $DetailTable[$key]=$value;
				   
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
	
		return $Query;
		
	}
	
	*/
	
	  function isfield($key,$tb)
	{
		
		$Query="select *  from information_schema.COLUMNS  where table_name='$tb' and column_name='$key'";
		$obj=new DyamicClass();
		
		$rows=$obj->getQuery($Query);
		
			if(count($rows)>0)
			return true;
		else
			return false;
		
	}
	  function GetPrimaryKey($tableName)
	{
		
		
		$obj=new DyamicClass();
	$Query=$obj->getPrimaryKey($tableName);
	//echo $Query;
		$rows=$obj->getQuery($Query);
			
			if(count($rows)>0)
			return $rows[0]['COLUMN_NAME'];
		else
			return "";
		
	}
		function isVirtualTable($tableName)
		{
			//echo "TestisVirtualTable  :".$tableName."   ".substr($tableName,0,7)."<br/>";
			
			if(substr($tableName,0,7)=="Virtual")
			{
				
				return true;
			
			}
			else
				return false;
		}
	
	  function isTable($key)
	{
		$Query="select *  from information_schema.tables where table_Name='$key'";
		
		$obj=new DyamicClass();
		$rows=$obj->getQuery($Query);
	
	
			if(count($rows)>0)
			return true;
		else
			return false;
		
		
	}
	  function isTables($key)
	{
		return false;
	}
	function SaveData($data)
	{
		
		foreach( $data as $key=>$value){
						$obj=new DyamicClass();
						if( is_array($value))
						{
							$MasterKeyValue=array();
							
								$obj->beginTran();
						
						
						
							$DetailTable=array();
							
							//$DetailTable=SaveRecord($obj,$Table,$TableData,$MasterKeyValue);
							$Query=InsertUpdate($key,$value,$MasterKeyValue,$DetailTable);
							echo  $Query;
							$value1=$obj->executeQuery($Query);
							
							$PrimaryKey=GetPrimaryKey($key);
					        $MasterKeyValue[$PrimaryKey]=$value[$PrimaryKey];
							if($MasterKeyValue[$PrimaryKey]==0)
							{
								$LastInsertIdSql = "SELECT  LAST_INSERT_ID()";
							$tempData=$obj->getValue($LastInsertIdSql);
							$MasterKeyValue[$PrimaryKey]=$tempData[0];
							}
							SaveDetail($obj,$DetailTable,$MasterKeyValue);
							
							
							
							$obj->commit();	
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
	}
	
	function SaveDetail($obj,$DetailTable,$MasterKeyValue)
	{
		foreach($DetailTable as  $Table=>$TableDatas)
							{
								
								if( is_array($TableDatas))
								{
									foreach($TableDatas as $TableData)
									{
									$DetailTable2=array();
								     $DetailTable2=SaveRecord($obj,$Table,$TableData,$MasterKeyValue);
									}
								}
								else
								{
									$Query=$TableDatas;
									 echo $Query;
									$value=$obj->executeQuery($Query);
								}
								
							}
		
	}
	function SaveRecord($obj,$Table,$TableData,$MasterKeyValue)
	{
		
									$DetailTable2=array();
									
									
									echo $PrimaryKey;
									$Query=InsertUpdate($Table,$TableData,$MasterKeyValue,$DetailTable2);
									echo $Query;
									$value=$obj->executeQuery($Query);
									/*$PrimaryKey=GetPrimaryKey($Table);	
									$MasterKeyValue[$PrimaryKey]=$value[$PrimaryKey];
										if($MasterKeyValue[$PrimaryKey]==0)
										{
										$LastInsertIdSql = "SELECT  LAST_INSERT_ID()";
										$tempData=$obj->getValue($LastInsertIdSql);
										$MasterKeyValue[$PrimaryKey]=$tempData[0];
										}
										*/
										
										return DetailTable2;
	}

	//DataLayer



















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
				$data = json_decode(file_get_contents('php://input'), true);
				SaveData($data);
				
//echo "End";
			break;
		case 'PUT':
		
			echo "PUT";
			break;
		case 'DELETE':
			
			echo "DELETE";
			break;
		default:
		
			header("HTTP/1.0 405 Method Not Allowed");
			break;
	}
	
	
	
?>
