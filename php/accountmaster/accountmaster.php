<?php
include '..\database.php';
class AccountMaster extends Database
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

    public function account_list($page=1,$search_input=''){
       $perpage=10;
       $page=($page-1)*$perpage;

       $search='';
       if($search_input!=''){
         $search="WHERE ( AccountName LIKE '%$search_input%' OR Address like '%$search_input%' OR City like '%$search_input%' OR Phone like '$search_input%'  )";
       }

if($page<0)
		$sql = "SELECT * FROM AccountMaster $search ORDER BY AccountMasterId ";
	else
       $sql = "SELECT * FROM AccountMaster $search ORDER BY AccountMasterId desc LIMIT $page,$perpage";

       $query=  $this->conn->query($sql);
       $account=array();
       if ($query->num_rows > 0) {
       while ($row = $query->fetch_assoc()) {
          $account['account_list'][]= $row;
       }
       }


    $count_sql = "SELECT COUNT(*) FROM AccountMaster $search";
    $query=  $this->conn->query($count_sql);
    $total = mysqli_fetch_row($query);
    $account['total'][]= $total;


    return $account;
    }

    public function create_account_info($post_data=array()){


       $AccountName='';
       if(isset($post_data->AccountName)){
       $AccountName= mysqli_real_escape_string($this->conn,trim($post_data->AccountName));
       }
       $Address='';
       if(isset($post_data->Address)){
       $Address= mysqli_real_escape_string($this->conn,trim($post_data->Address));
       }

        $City='';
       if(isset($post_data->City)){
       $City= mysqli_real_escape_string($this->conn,trim($post_data->City));
       }


       $Phone='';
       if(isset($post_data->Phone)){
       $Phone= mysqli_real_escape_string($this->conn,trim($post_data->Phone));
       }
      



       $sql="INSERT INTO AccountMaster (AccountName, Address, City,Phone) VALUES ('$AccountName', '$Address', '$City','$Phone')";

        $result=  $this->conn->query($sql);

        if($result){
          return 'Succefully Created Account Info';
        }else{
           return 'An error occurred while inserting data';
        }





    }

    public function view_account_by_student_id($id){
       if(isset($id)){
       $AccountMasterId= mysqli_real_escape_string($this->conn,trim($id));

       $sql="Select * from AccountMaster where AccountMasterId='$AccountMasterId'";

       $result=  $this->conn->query($sql);

        return $result->fetch_assoc();

       }
    }


    public function UpdateRecord($post_data=array()){
       
      
       $AccountName='';
       if(isset($post_data->AccountName)){
       $AccountName= mysqli_real_escape_string($this->conn,trim($post_data->AccountName));
       }
       $Address='';
       if(isset($post_data->Address)){
       $Address= mysqli_real_escape_string($this->conn,trim($post_data->Address));
       }

        $City='';
       if(isset($post_data->City)){
       $City= mysqli_real_escape_string($this->conn,trim($post_data->City));
       }


       $Phone='';
       if(isset($post_data->Phone)){
       $Phone= mysqli_real_escape_string($this->conn,trim($post_data->Phone));
       }
	   $AccountMasterId='';
       if(isset($post_data->AccountMasterId)){
       $AccountMasterId= mysqli_real_escape_string($this->conn,trim($post_data->AccountMasterId));
       }
      

       $sql="UPDATE AccountMaster SET AccountName='$AccountName',Address='$Address',City='$City',Phone='$Phone' where AccountMasterId=$AccountMasterId";

        $result=  $this->conn->query($sql);


         
         if($result){
          return 'Succefully Updated AccountMaster Info';
        }else{
         return 'An error occurred while inserting data';
        }




       
    }

    public function deleteObject($id){

       if(isset($id)){
       $AccountMasterId= mysqli_real_escape_string($this->conn,trim($id));

       $sql="DELETE FROM  AccountMaster  WHERE AccountMasterId =$AccountMasterId";
        $result=  $this->conn->query($sql);

         if($result){
          return 'Successfully Deleted AccountMaster';
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
