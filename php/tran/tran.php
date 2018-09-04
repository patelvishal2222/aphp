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


       $sql = "SELECT * FROM Tran T inner join AccountMaster A on T.AccountMasterId=A.AccountMasterId    $search ORDER BY TranId desc LIMIT $page,$perpage";

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

    public function InsertUpdate($post_data=array()){


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
      
	   $AccountMasterId='';
       if(isset($post_data->AccountMaster->AccountMasterId)){
       $AccountMasterId= mysqli_real_escape_string($this->conn,trim($post_data->AccountMaster->AccountMasterId));
       }
     

     
	   $VoucherTypeId='';
       if(isset($post_data->VoucherTypeId)){
       $VoucherTypeId= mysqli_real_escape_string($this->conn,trim($post_data->VoucherTypeId));
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
       $sql1="INSERT INTO Tran (BillNo,BillDate,AccountMasterId,VoucherTypeId,Total,Remarks) VALUES ('$BillNo','$BillDate','$AccountMasterId','$VoucherTypeId','$Total','$Remarks')";
     else
  	$sql1="UPDATE Tran SET BillNo='$BillNo',BillDate='$BillDate',AccountMasterId='$AccountMasterId',Total='$Total',Remarks='$Remarks' WHERE TranId='$TranId'";
		$this->conn->autocommit(false);
        $result=  $this->conn->query($sql1);
		if(!$result)
		{
			$this->conn->rollback();
			  return 'An error occurred while inserting data '.$sql1;
			
		}
		
		if($TranId==0)
		{
		$count_sql = "SELECT  LAST_INSERT_ID()";
    $query=  $this->conn->query($count_sql);
    if($query)
	{
	 $row=mysqli_fetch_row($query);
   $TranId =(int)$row[0];
	}
	else
	{
		$this->conn->rollback();
		  return 'An error occurred while inserting data '.$count_sql;
	}
	
		}
		
$trandetails=$post_data->trandetails;
$TranDetailsIds=$post_data->TranDetailsIds;

foreach( $trandetails as $trandetail )
{
	$Srno=$trandetail->Srno;
	$Height=0;
	if(isset($trandetail->Height))
	$Height=$trandetail->Height;

	$Length=0;
	if(isset($trandetail->Length))
	$Length=$trandetail->Length;

	$Quantity=0;
	if(isset($trandetail->Quantity))
	$Quantity=$trandetail->Quantity;
	$Nos=0;
	if(isset($trandetail->Nos))
	$Nos=$trandetail->Nos;
	$TotalQuantity=$trandetail->TotalQuantity;
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
	$sql="INSERT INTO trandetails (TranId,Srno,ItemMasterId,Height,Length,Quantity,Nos,TotalQuantity,Rate,Amount) VALUES ('$TranId','$Srno','$ItemMasterId','$Height','$Length','$Quantity','$Nos','$TotalQuantity','$Rate','$Amount')";
else
{
	$sql="UPDATE trandetails SET Srno='$Srno',ItemMasterId='$ItemMasterId',Height='$Height',Length='$Length',Quantity='$Quantity',Nos='$Nos',TotalQuantity='$TotalQuantity',Rate='$Rate',Amount='$Amount'  where TranDetailsId='$TranDetailsId' ";
	
	
	
}

	 $result=  $this->conn->query($sql);
	 
	 if(!$result)
		{
			$this->conn->rollback();
			  return 'An error occurred while inserting data '.$sql;
			
		}
}



if($TranDetailsIds<>"" and $TranId>0)
{
   $sqlDelete="Update trandetails set IsDeleted=1   where tranid=$TranId and trandetailsId  in ($TranDetailsIds)";
   $result=  $this->conn->query($sqlDelete);
}

        if($result){
			 $this->conn->commit();
          return 'Succefully Created Tran Info';
        }else{
			$this->conn->rollback();
           return 'An error occurred while inserting data '.$sqlDelete;
        }





    }
	

    public function getObject($id){
       if(isset($id)){
       $TranId= mysqli_real_escape_string($this->conn,trim($id));

       $sql="Select * from Tran where TranId='$TranId'";

       $result=  $this->conn->query($sql);
	   $account=array();
	   $account=$result->fetch_assoc();
	   $AccountMasterId=$account["AccountMasterId"];
	   
	   $sql = "SELECT * FROM AccountMaster  where  AccountMasterId=$AccountMasterId ";
	   $result=  $this->conn->query($sql);
	   $account['AccountMaster']=$result->fetch_assoc();
       $sql = "SELECT * FROM trandetails  where  IsDeleted=0  AND TranId='$TranId' ORDER BY srno  ";
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
