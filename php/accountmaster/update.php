<?php 
include 'accountmaster.php';
$obj=new AccountMaster();
$data = json_decode(file_get_contents("php://input"));
$result=$obj->UpdateRecord($data);
$message['message']=$result;
echo json_encode($message);
?>