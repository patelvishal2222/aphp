<?php
   $dbhost = 'localhost';
   $dbuser = 'root';
   $dbpass = 'root';
   $dbname='account';
   $backup_file = 'D:\\'.$dbname . date("Y-m-d-H-i-s") . '.gz';
  // echo $backup_file;
   $command = "mysqldump --opt -h $dbhost -u $dbuser -p $dbpass ". "account | gzip > $backup_file";
   $server_name   = "localhost";
$username      = "root";
$password      = "root";
$dbname = "account";
$date_string   = date("Y-m-d-H-i-s");

   $cmd = "C:\wamp\bin\mysql\mysql5.6.17\bin\mysqldump  --routines  -h {$server_name} -u {$username} -p{$password} {$dbname} > " . 'D:\\'.$dbname . '_'.$date_string.'.sql';
   echo $cmd.'<br/>';
   //system($command);
   exec($cmd);
   echo "Backup Sucessfully";
   
  
?>