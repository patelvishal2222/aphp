
<?php
include 'tran.php';

$obj=new Tran();
$student_data=$obj->getObject($_GET['TranId']);
echo json_encode($student_data);


?>
