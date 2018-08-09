
<?php
include 'item.php';
$obj=new Item();

$item_data=$obj->view_item_by_item_id($_GET['ItemMasterId']);
echo json_encode($item_data);


?>
