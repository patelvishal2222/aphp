<?php
include 'item.php';



$obj=new Item();
$item_list=$obj->item_list($_GET['page'],$_GET['search_input']);


echo json_encode($item_list);


?>