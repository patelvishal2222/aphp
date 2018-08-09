<?php
include 'tran.php';
$obj=new Tran();
$result=$obj->deleteObject($_GET['TranId']);
$message['message']=$result;
echo json_encode($message);






?>