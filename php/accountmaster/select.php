<?php
include 'accountmaster.php';



$obj=new AccountMaster();
$account_list=$obj->account_list($_GET['page'],$_GET['search_input']);


echo json_encode($account_list);


?>