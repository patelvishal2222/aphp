<?php

include 'tran.php';



$obj=new Tran();

$tran_list=$obj->tran_list($_GET['page'],$_GET['search_input']);


echo json_encode($tran_list);


?>