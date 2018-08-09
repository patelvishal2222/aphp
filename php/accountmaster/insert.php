<?php 

include 'accountmaster.php';
$obj=new AccountMaster();
$data = json_decode(file_get_contents("php://input"));
$result=$obj->create_account_info($data);
$message['message']=$result;
echo json_encode($message);



?>