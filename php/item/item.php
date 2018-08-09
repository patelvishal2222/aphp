<?php

include '..\database.php';
class Item   extends Database
{
	/*
    private $conn;
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
*/


    public function item_list($page=1,$search_input=''){
       $perpage=10;
       $page=($page-1)*$perpage;

       $search='';
       if($search_input!=''){
         $search="WHERE ( itemname LIKE '%$search_input%' OR purrate like '%$search_input%' OR salRate like '%$search_input%'  )";
       }

		if($page<0)
			$page=0;
	
       $sql = "SELECT * FROM ItemMaster $search ORDER BY ItemMasterId desc LIMIT $page,$perpage";
	
       $query=  $this->conn->query($sql);
       $item=array();
	   
       if ($query->num_rows > 0) {
		   
       while ($row = $query->fetch_assoc()) {
          $item['item_list'][]= $row;
		
       }
       }


    $count_sql = "SELECT COUNT(*) FROM ItemMaster $search";
    $query=  $this->conn->query($count_sql);
    $total = mysqli_fetch_row($query);
    $item['total'][]= $total;


    return $item;
    }

    public function create_item_info($post_data=array()){


       $ItemName='';
       if(isset($post_data->ItemName)){
       $ItemName= mysqli_real_escape_string($this->conn,trim($post_data->ItemName));
       }
       $PurRate='';
       if(isset($post_data->PurRate)){
       $PurRate= mysqli_real_escape_string($this->conn,trim($post_data->PurRate));
       }

        $SaleRate='';
       if(isset($post_data->SaleRate)){
       $SaleRate= mysqli_real_escape_string($this->conn,trim($post_data->SaleRate));
       }





       $sql="INSERT INTO itemMaster (ItemName, PurRate, SaleRate) VALUES ('$ItemName', '$PurRate', '$SaleRate')";

        $result=  $this->conn->query($sql);

        if($result){
          return 'Succefully Created Item Info';
        }else{
           return 'An error occurred while inserting data';
        }





    }

    public function view_item_by_item_id($id){
       if(isset($id)){
       $ItemMasterId= mysqli_real_escape_string($this->conn,trim($id));

       $sql="Select * from ItemMaster where ItemMasterId='$ItemMasterId'";

       $result=  $this->conn->query($sql);

        return $result->fetch_assoc();

       }
    }


    public function update_item_info($post_data=array()){
       if( isset($post_data->ItemMasterId)){
       $ItemMasterId=mysqli_real_escape_string($this->conn,trim($post_data->ItemMasterId));

       $ItemName='';
       if(isset($post_data->ItemName)){
       $ItemName= mysqli_real_escape_string($this->conn,trim($post_data->ItemName));
       }
       $PurRate='';
       if(isset($post_data->PurRate)){
       $PurRate= mysqli_real_escape_string($this->conn,trim($post_data->PurRate));
       }

        $SaleRate='';
       if(isset($post_data->SaleRate)){
       $SaleRate= mysqli_real_escape_string($this->conn,trim($post_data->SaleRate));
       }


     

       $sql="UPDATE ItemMaster SET ItemName='$ItemName',PurRate='$PurRate',SaleRate='$SaleRate' WHERE ItemMasterId =$ItemMasterId";

        $result=  $this->conn->query($sql);


         unset($post_data->ItemMasterId);
         if($result){
          return 'Succefully Updated ItemMaster Info';
        }else{
         return 'An error occurred while inserting data '.$sql;
        }




       }
    }

    public function deleteObject($id){

       if(isset($id)){
       $ItemMasterId= mysqli_real_escape_string($this->conn,trim($id));

       $sql="DELETE FROM  ItemMaster  WHERE ItemMasterId =$ItemMasterId";
        $result=  $this->conn->query($sql);

         if($result){
          return 'Successfully Deleted Item Info'.$sql;
        }else{
         return 'An error occurred while inserting data';
        }



       }

    }
    function __destruct() {
    mysqli_close($this->conn);
    }

}

?>