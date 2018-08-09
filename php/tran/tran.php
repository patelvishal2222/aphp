<?php

include '..\database.php';

class Tran extends Database
{




    public function tran_list($page=1,$search_input=''){
       $perpage=10;
       $page=($page-1)*$perpage;

       $search='';
       if($search_input!=''){
         $search="WHERE ( AccountName LIKE '%$search_input%' OR Address like '%$search_input%' OR City like '%$search_input%' OR Phone like '$search_input%'  )";
       }


       $sql = "SELECT * FROM Tran $search ORDER BY TranId desc LIMIT $page,$perpage";

       $query=  $this->conn->query($sql);
       $account=array();
       if ($query->num_rows > 0) {
       while ($row = $query->fetch_assoc()) {
          $account['tran_list'][]= $row;
       }
       }


    $count_sql = "SELECT COUNT(*) FROM Tran $search";
    $query=  $this->conn->query($count_sql);
    $total = mysqli_fetch_row($query);
    $account['total'][]= $total;


    return $account;
    }

    public function create_tran_info($post_data=array()){


	$BillNo='';
       if(isset($post_data->BillNo)){
       $BillNo= mysqli_real_escape_string($this->conn,trim($post_data->BillNo));
       }
	   $BillDate='';
       if(isset($post_data->BillDate)){
       $BillDate= mysqli_real_escape_string($this->conn,trim($post_data->BillDate));
	   $BillDate=substr($BillDate,0,strpos($BillDate,"T"));
	  //$date1=$BillDate;
	 //  $BillDate=strtotime($BillDate);
	  // $BillDate=Date('Y-m-d',$BillDate);
       }
      
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
   $Total='';
       if(isset($post_data->Total)){
       $Total= mysqli_real_escape_string($this->conn,trim($post_data->Total));
       }
	      $Remarks='';
       if(isset($post_data->Remarks)){
       $Remarks= mysqli_real_escape_string($this->conn,trim($post_data->Remarks));
       }
//str_to_date('$BillDate','%Y-%m-%d')
        $TranId= mysqli_real_escape_string($this->conn,trim($post_data->TranId));
		if($TranId==0)
       $sql1="INSERT INTO Tran (BillNo,BillDate,AccountName, Address, City,Phone,Total,Remarks) VALUES ('$BillNo','$BillDate','$AccountName', '$Address', '$City','$Phone','$Total','$Remarks')";
   else
	$sql1="UPDATE Tran SET BillNo='$BillNo',BillDate='$BillDate',AccountName='$AccountName', Address='$Address', City='$City',Phone='$Phone',Total='$Total',Remarks='$Remarks' WHERE TranId='$TranId'";

        $result=  $this->conn->query($sql1);
		
		if($TranId==0)
		{
		$count_sql = "SELECT  LAST_INSERT_ID()";
    $query=  $this->conn->query($count_sql);
    $TranId = mysqli_fetch_row($query)[0];
	
		}
$trandetails=$post_data->trandetails;
foreach( $trandetails as $trandetail )
{
	$Srno=$trandetail->Srno;
	$Height=$trandetail->Height;
	$Length=$trandetail->Length;
	
	
	$Quntity=$trandetail->Quntity;
	$Nos=$trandetail->Nos;
	$TotalQuntity=$trandetail->TotalQuntity;
	$Rate=$trandetail->Rate;
	$Amount=$trandetail->Amount;
	$ItemMasters=$trandetail->ItemMaster;

	
	$ItemMasterId=$ItemMasters->ItemMasterId;	
	
	
	$TranDetailsId=0;
	 if(isset($trandetail->TranDetailsId))
	 {
		$TranDetailsId= $trandetail->TranDetailsId;
	 }
	
	
		if($TranDetailsId==0)
	$sql="INSERT INTO trandetails (TranId,Srno,ItemMasterId,Height,Length,Quntity,Nos,TotalQuntity,Rate,Amount) VALUES ('$TranId','$Srno','$ItemMasterId','$Height','$Length','$Quntity','$Nos','$TotalQuntity','$Rate','$Amount')";
else
	$sql="UPDATE trandetails SET Srno='$Srno',ItemMasterId='$ItemMasterId',Height='$Height',Length='$Length',Quntity='$Quntity',Nos='$Nos',TotalQuntity='$TotalQuntity',Rate='$Rate',Amount='$Amount'  where TranDetailsId='$TranDetailsId' ";

	 $result=  $this->conn->query($sql);
}

        if($result){
          return 'Succefully Created Tran Info'.$sql1.$date1.$BillDate;
        }else{
           return 'An error occurred while inserting data '.$sql;
        }





    }

    public function getObject($id){
       if(isset($id)){
       $TranId= mysqli_real_escape_string($this->conn,trim($id));

       $sql="Select * from Tran where TranId='$TranId'";

       $result=  $this->conn->query($sql);
	   $account=array();
	   $account=$result->fetch_assoc();
       $sql = "SELECT * FROM trandetails  where TranId='$TranId' ORDER BY srno  ";

       $query=  $this->conn->query($sql);
       
       if ($query->num_rows > 0) {
       while ($row = $query->fetch_assoc()) {
          
		  
		  $ItemMasterId=$row["ItemMasterId"];
		    $sql="Select * from ItemMaster where ItemMasterId='$ItemMasterId'";
			$result=  $this->conn->query($sql);
			
						$row['ItemMaster']=$result->fetch_assoc();
						  $account['trandetails'][]= $row;
       }
       }

        return  $account;

       }
    }



    public function deleteObject($id){

       if(isset($id)){
       $TranId= mysqli_real_escape_string($this->conn,trim($id));

       $sql="DELETE FROM  trandetails  WHERE TranId =$TranId";
        $result=  $this->conn->query($sql);
		
		$sql="DELETE FROM  Tran  WHERE TranId =$TranId";
        $result=  $this->conn->query($sql);

         if($result){
          return 'Successfully Deleted Tran Info';
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