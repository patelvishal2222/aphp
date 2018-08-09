<?php
try
{

 $d="2018-08-15T18:30:00.000Z";
 
 echo substr($d,0,strpos($d,"T"));

//$billdate=date_create(substr($d,0,strpos($d,"T"));
echo $billdate;

}catch(exception $e)
{
	echo $e;
	
}

?>