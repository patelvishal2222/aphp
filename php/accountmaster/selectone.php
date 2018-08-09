
<?php
include 'accountmaster.php';
$obj=new AccountMaster();
$student_data=$obj->view_account_by_student_id($_GET['AccountMasterId']);
echo json_encode($student_data);


?>
