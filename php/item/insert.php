<?php 

include 'item.php';
$obj=new Item();
$data = json_decode(file_get_contents("php://input"));
$result=$obj->create_item_info($data);
$message['message']=$result;
echo json_encode($message);



?>