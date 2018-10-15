<?php



//DyamicClass
	
	include 'database.php';
	class DyamicClass  extends Database
	{
		
		
   // private $conn;
  //private	$servername = "localhost";
 
  //private $username = "root";
// private   $password = "root";

    function __construct() {

  //  session_start();
    

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
				return "Error ".$Query;
			
				
	}
	public function getObject()
	{
		
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
	
	
	
?>
