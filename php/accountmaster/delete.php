<?php
include 'accountmaster.php';
$obj=new AccountMaster();
$result=$obj->deleteObject($_GET['AccountMasterId']);
$message['message']=$result;
echo json_encode($message);






?>