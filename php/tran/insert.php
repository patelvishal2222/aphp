<?php 

include 'tran.php';
$obj=new Tran();
$data = json_decode(file_get_contents("php://input"));
/*
$trandetails=$data->trandetails;

foreach( $trandetails as $trandetail )
{
	$ItemMasters=$trandetail->ItemMaster;
echo json_encode($ItemMasters);	
	
echo	$ItemMasters->ItemMasterId;	

}
*/
$result=$obj->InsertUpdate($data);
$message['message']=$result;

echo json_encode($message);



?>