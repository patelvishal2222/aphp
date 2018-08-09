<?php
include 'item.php';
$obj=new Item();

$result=$obj->deleteObject($_GET['ItemMasterId']);

$message['message']=$result;
echo json_encode($message);






?>