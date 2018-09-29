<?php

	$request_method=$_SERVER["REQUEST_METHOD"];
	$dbName='Account';
	//echo $request_method;
	switch($request_method)
	{
		case 'GET':
			
			if(!empty($_GET["Query"]))
			{
				
				$Query=$_GET["Query"];
				//$Query=str_replace("@plus@","+",$Query);
				//echo $Query;
				$obj=new DyamicClass();
				
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
				$Query="SELECT  COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='$TableName'  and  table_schema='$dbName' and REFERENCED_COLUMN_NAME is not null";
				//echo $Query;
				$ForeginKeyTables=$obj->getQuery($Query);
				
				foreach(  $ForeginKeyTables as $fktable )
				{
					//echo json_encode($fktable);
					$FkName=$fktable[COLUMN_NAME];
					$FkData=$rows[0][$fktable[COLUMN_NAME]];;
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
			else if(!empty($_GET["backupdb"]))
			{
				$dbName=$_GET["backupdb"];
				$obj=new DyamicClass();
				$value=$obj->backupdb($dbName);
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
							$Query=InsertUpdate($key,$value);
							echo $Query;
							$obj=new DyamicClass();
							$value=$obj->executeQuery($Query);
							echo  $value;
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
				{
					$PrimaryKeyValue=$value;
				}
				
				
				else if(isfield($key,$tb)  &&  !$data[substr($key,0,-2)])
				{
					if(isset($value)  && trim($value)!="" )
					{
					$f=$f.$key.",";
					$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
				}
				else if(isTable($key))
				{
				
			    $f=$f.$key."Id,";
				$v=$v."'".$value[$key."Id"]."',";
				$fv=$fv.$key."Id='".$value[$key."Id"]."',";
				
				
				}
				else
				{
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
	
	  function isfield($key,$tb)
	{
		
		$Query="select *  from information_schema.COLUMNS  where table_name='$tb' and column_name='$key'";
		$obj=new DyamicClass();
		
		$rows=$obj->getQuery($Query);
		/*$count=0;
	foreach( $rows as $row )
{
	$count++;
}

		if($count> 0)
			*/
			if(count($rows)>0)
			return true;
		else
			return false;
		
	}

	  function isTable($key)
	{
		$Query="select *  from information_schema.tables where table_Name='$key'";
		
		$obj=new DyamicClass();
		$rows=$obj->getQuery($Query);
	
	/*$count=0;
	foreach( $rows as $row )
{
	$count++;
}

		if($count> 0)
			*/
			if(count($rows)>0)
			return true;
		else
			return false;
		
		
	}
	  function isTables($key)
	{
		return false;
	}
	
	
	class DyamicClass
	{
		
    private $conn;
  private	$servername = "localhost";
  private  $dbname = "account";
   private $username = "root";
 private   $password = "root";

    function __construct() {

    session_start();
    

    // Create connection
    $conn = new mysqli($this->servername, $this->username, $this->password, $this->dbname);
    // Check connection
      if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
       }else{
        $this->conn=$conn;
       }

    }
	
	  public function getQuery($Query){
       

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
				return "Error ".$Query;
			
				
	}
	public function getObject()
	{
		
	}

	public function  backupdb($dbName)
	{
		$date_string   = date("Y-m-d-H-i-s");
		$cmd = "C:\Program Files\MySQL\MySQL Server 5.6\bin\mysqldump   -h {$this->servername} -u {$this->username} -p {$this->password} {$this->dbname} > " . 'h:\\'.$this->dbname . '_'.$date_string.'.sql';
			  echo $cmd.'<br/>';
   
   exec($cmd);
   echo "Backup Sucessfully";
   
   /*
   
   
    $dbhost = 'localhost';
   $dbuser = 'root';
   $dbpass = 'root';
   $dbname='account';
   $backup_file = 'D:\\'.$dbname . date("Y-m-d-H-i-s") . '.gz';
  // echo $backup_file;
   $command = "mysqldump --opt -h $dbhost -u $dbuser -p $dbpass ". "account | gzip > $backup_file";
   $server_name   = "localhost";
$username      = "root";
$password      = "root";
$dbname = "account";
$date_string   = date("Y-m-d-H-i-s");
   $cmd = "C:\Program Files\MySQL\MySQL Server 5.6\bin\mysqldump  --routines  -h {$server_name} -u {$username} -p{$password} {$dbname} > " . 'D:\\'.$dbname . '_'.$date_string.'.sql';
   echo $cmd.'<br/>';
   //system($command);
   exec($cmd);
   echo "Backup Sucessfully";
   */
				
	}
	
	
		
		 function __destruct() {
    mysqli_close($this->conn);
    }
	
	
	
	function insertdb($tb){
echo $tb;
$f="";
$v="";
foreach($_POST as $key=>$value){
echo $key . " = " . $value. "<br>";
}
foreach($_POST as $key=>$value){
if(($key!==$tb)&&($key!=="image_y")){
$f=$f.mysqli_real_escape_string($this->mysqli,$key).",";
$v=$v."'".mysqli_real_escape_string($this->mysqli,$value)."',";

echo "<hr> there is no image<hr>";
}
if($key=="image_y"){
$f=$f."image,";
$v=$v."'".$_FILES['image']['name']."',";
echo "<hr> there is an image<hr>";
}
}
$f1=rtrim($f,",");
$v1=rtrim($v,",");
echo $f1 ."<br>".$v1;
$this->insert($tb,$f1,$v1);
}

function del($tb,$field,$value){

$d= mysqli_query($this->mysqli,"DELETE FROM $tb where $field = '$value' ");
if(!$d){
die("Delete Query Failed" );

}
}


function up($tb,$field,$value,$o_field,$o_value){

$u= mysqli_query($this->mysqli,"UPDATE $tb SET $field= '$value' where $o_field= '$o_value'   ");
if(!$u){
die("Update Query Failed".mysqli_error($this->mysqli) );

}
}

		
	}
	
	

?>