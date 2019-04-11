<?php
 class Database
{
	    //public $conn;
		public $servername = "localhost";
		public $dbname = "Account";
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
	 
	 
	 
	  public function Query2($Query){
	
    $listdata=array();
	$count=1;
      if ($this->conn->multi_query($Query)) {
		 
      do {
	
      
         if ($result = $this->conn->store_result()) {
			 			 $rows=array();
            
			while ($row = $result->fetch_assoc())
				{
               $rows[]=$row;
			  
            }
			$listdata[$count]=$rows;
			$count++;
            $result->free();
			
         }
		 
         if ($this->conn->more_results()) {
         }
		 
      } while ($this->conn->next_result());

   }
   else
   { echo "not data";
   }
   return $listdata;
	}	
	public function getQuery($Query){
		 // echo  $Query;
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
   echo  $Query;
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
		$cmd = "C:\Program Files\MySQL\MySQL Workbench SE 6.1.6\mysqldump   -h {$this->servername} -u {$this->username} -p {$this->password} {$this->dbname} > " . 'h:\\'.$this->dbname . '_'.$date_string.'.sql';
			  echo $cmd.'<br/>';
		exec($cmd);
   echo "Backup Sucessfully";
				
	}
		 function __destruct() {
    mysqli_close($this->conn);
    }
		
}
class DataLayer 
{
	function getTableValue($TableName,$PrimaryKey,$PrimaryValue,$MasterTable)
	{
		
				$Query="Select *  FROM $TableName WHERE $PrimaryKey=$PrimaryValue";
				$obj=new DyamicClass();
				$rows=$obj->getQuery($Query);
				$Query=$obj->getForeginkeyQuery($TableName);
				$ForeginKeyTables=$obj->getQuery($Query);
					for($index=0;$index<count($rows);$index++)
					{
							foreach(  $ForeginKeyTables as $fktable )
							{
							$FkName=$fktable["COLUMN_NAME"];
							$FkData=$rows[$index][$fktable["COLUMN_NAME"]];;
							$inMaster=false;
								if(count( $MasterTable)>0)
								{
								if(in_array(   $fktable["REFERENCED_TABLE_NAME"],$MasterTable))
								$inMaster=true;
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
	//SaveData
	function SaveData($data)
	{
		foreach( $data as $key=>$value)
		{
			$obj=new DyamicClass();
			if( is_array($value))
			{
			$MasterKeyValue=array();
			$obj->beginTran();
			$Id=$this->SaveRecord($obj,$key,$value,$MasterKeyValue);
			$obj->commit();	
			echo    $Id;
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
	function SaveRecord($obj,$Table,$TableData,$MasterKeyValue)
	{
			$DetailTable=array();
			$Query=$this->InsertUpdate($Table,$TableData,$MasterKeyValue,$DetailTable);
			$value=$obj->executeQuery($Query);
			$PrimaryKey=$this->GetPrimaryKey($Table);	
			$MasterKeyValue[$PrimaryKey]=$TableData[$PrimaryKey];
				if($MasterKeyValue[$PrimaryKey]==0)
				{
				$LastInsertIdSql = "SELECT  LAST_INSERT_ID()";
				$tempData=$obj->getValue($LastInsertIdSql);
				$MasterKeyValue[$PrimaryKey]=$tempData[0];
				}
				
			$this->SaveDetail($obj,$DetailTable,$MasterKeyValue);
		return $MasterKeyValue[$PrimaryKey];
	}
	function SaveDetail($obj,$DetailTable,$MasterKeyValue)
	{
		foreach($DetailTable as  $Table=>$TableDatas)
		{
								if( is_array($TableDatas))
								{
									foreach($TableDatas as $TableData)
									{
								   $this->SaveRecord($obj,$Table,$TableData,$MasterKeyValue);
									}
								}
								else
								{
									$Query=$TableDatas;
									$value=$obj->executeQuery($Query);
								}
								
		}
		
	}
	
	
	
function InsertUpdate($tb,$data,$MasterKeyValue,&$DetailTable)
	{
		
		$f="";
		$v="";
		$fv="";
		$PrimaryKey=$tb.'Id';
		$PrimaryKey=$this->GetPrimaryKey($tb);
		$PrimaryKeyValue=0;
		foreach( $MasterKeyValue as $insertKey=>$insertValue)
		{
			if( array_search($insertKey,$data))
			{
			unset($data[$insertKey]);
			}
			$f=$insertKey.",";
			 $v=$insertValue.",";
		}
		$Query="select *  from information_schema.COLUMNS  where table_name='$tb' ";
		$obj=new DyamicClass();
		$tabledata=$obj->getQuery($Query);
		foreach( $data as $key=>$value)
		{
				if($key==$PrimaryKey)
				{
					$PrimaryKeyValue=$value;
				}
				else if($this->isfield($key,$tb,$tabledata)  &&  !$data[substr($key,0,-2)])
				{
					if(isset($value)  && trim($value)!="" )
					{
						$f=$f.$key.",";
						if($key=='BillDate' || $key=='ExpireDate' )
						{
						$value=substr($value,0,strpos($value,"T"));
						$v=$v."'".$value."',";
						$fv=$fv.$key."='".$value."',";
						}
						else
						{
						$v=$v."'".$value."',";
						$fv=$fv.$key."='".$value."',";
						}
					}
				}
				else if($this->isVirtualTable($key))
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
				else if($this->isTable($key))
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
	
	
	function searcharray($value, $key, $array) {
   foreach ($array as $k => $val) {
       if ($val[$key] == $value) {
           return $k;
       }
   }
   return null;
}
	  function isfield($key,$tb,$tabledata)
	{
		$datarow=$this->searcharray($key,'COLUMN_NAME',$tabledata);
		if($datarow!=null )
		return true;
		else
		{
			
			return false;
		}
	}
	  function GetPrimaryKey($tableName)
	{
		$obj=new DyamicClass();
		$Query=$obj->getPrimaryKey($tableName);
		$rows=$obj->getQuery($Query);
		if(count($rows)>0)
			return $rows[0]['COLUMN_NAME'];
		else
			return "";
	}
	function isVirtualTable($tableName)
	{
			if(substr($tableName,0,7)=="Virtual")
				return true;
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
				$obj=new DyamicClass();
				$rows=$obj->getQuery($Query);
				$listdata=$obj->getList($rows);
				echo json_encode($listdata);
				
				
			}
			if(!empty($_GET["Query2"]))
			{
				
				$Query=$_GET["Query2"];
				$obj=new DyamicClass();
				$rows=$obj->Query2($Query);
				echo json_encode($rows);
			}
			else if(!empty($_GET["getObject2"]))
			{
				$TableName=$_GET["getObject2"];
				$PrimaryKey=$_GET["PrimaryKey"];
				$PrimaryValue=$_GET["PrimaryValue"];
				$Query="Select *  FROM $TableName WHERE $PrimaryKey=$PrimaryValue";
				$obj=new DyamicClass();
				$rows=$obj->getQuery($Query);
				$Query=$obj->getForeginkeyQuery($TableName);
				$ForeginKeyTables=$obj->getQuery($Query);
				foreach(  $ForeginKeyTables as $fktable )
				{
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
			else if(!empty($_GET["getObject"]))
			{
				
				$MainObject = $_GET["getObject"];
				 $MainObject=json_decode($MainObject,true);
				$PrimaryValue=$MainObject["PrimaryValue"];
				$PrimaryKey=$MainObject["PrimaryKey"];
				$TableNames=$MainObject["TableNames"];
				$rows=array();
				$MasterTable=array();
				$objDataLayer=new DataLayer();
					foreach( $TableNames as $key=>$value){
							if( is_array($value))
								{
												foreach(  $value as $object )
												
												{
													$TableName=$object["TableName"];
													$rows[0][$TableName]=$objDataLayer->getTableValue($TableName,$PrimaryKey,$PrimaryValue,$MasterTable);
												}
								}
								else
								{
								$TableName=$value;
								$rows=$objDataLayer->getTableValue($TableName,$PrimaryKey,$PrimaryValue,$MasterTable);
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
				$obj=new DyamicClass();
				$rows=$obj->getQuery($Query);
				$listdata=$obj->getList($rows);
				$value=$obj->getValue("select count(1)  from $TableName $Search");
				$listdata['total'][]= $value;
				echo json_encode($listdata);
			}
			else if(!empty($_GET["deleteObject2"]))
			{
				$TableName=$_GET["deleteObject2"];
				$PrimaryKey=$_GET["PrimaryKey"];
				$PrimaryValue=$_GET["PrimaryValue"];
				$Query="DELETE  FROM $TableName WHERE $PrimaryKey=$PrimaryValue";
				$obj=new DyamicClass();
				$value=$obj->executeQuery($Query);
				echo  $value;
			}
			else if(!empty($_GET["deleteObject"]))
			{
				
				$MainObject = $_GET["deleteObject"];
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
			//echo " One two get Not work";	
			}
			break;
		case 'POST':
				$data = json_decode(file_get_contents('php://input'), true);
				$objDataLayer=new DataLayer();
				$objDataLayer->SaveData($data);
				
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