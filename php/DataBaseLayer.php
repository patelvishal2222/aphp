<?php

//include 'DyamicClass.php';


	function getTableValue($TableName,$PrimaryKey,$PrimaryValue,$MasterTable)
	{
		
				$Query="Select *  FROM $TableName WHERE $PrimaryKey=$PrimaryValue";
				//echo $Query;
				$obj=new DyamicClass();
				
				$rows=$obj->getQuery($Query);
				
				//echo $Query;
				$Query=$obj->getForeginkeyQuery($TableName);
				$ForeginKeyTables=$obj->getQuery($Query);
				
					
					for($index=0;$index<count($rows);$index++)
					{
				foreach(  $ForeginKeyTables as $fktable )
				{
					//echo json_encode($fktable);
					$FkName=$fktable["COLUMN_NAME"];
					
					$FkData=$rows[$index][$fktable["COLUMN_NAME"]];;
					 $inMaster=false;
					if(count( $MasterTable)>0)
					{
						
							if(in_array(   $fktable["REFERENCED_TABLE_NAME"],$MasterTable))
							$inMaster=true;
							
					//echo "check  ".in_array(   $fktable[REFERENCED_TABLE_NAME],$MasterTable)." -->  ".  $fktable[REFERENCED_TABLE_NAME] ." --> ".json_encode($MasterTable)."-->".$inMaster.  "<br/>";
					
					
					}
					if( $FkData!=null  &&   $inMaster==false )
					{
  				$Query="select  *  from $fktable[REFERENCED_TABLE_NAME]  where $fktable[REFERENCED_COLUMN_NAME] =$FkData;";
			
				$FkTableData=$obj->getQuery($Query);
				unset($rows[$index][$FkName]);
				$rows[$index]["Virtual".substr($FkName,0,-2)]=$FkTableData[0];
					}
				
			   }
					}
			   return $rows;
			   
	}
	
	  function InsertUpdate($tb,$data,&$DetailTable)
	{
		$f="";
		$v="";
		$fv="";
		$PrimaryKey=$tb.'Id';
		$PrimaryKey=GetPrimaryKey($tb);
		
		$PrimaryKeyValue=0;
		
		foreach( $data as $key=>$value){
			
				
				if($key==$PrimaryKey)
				{
					$PrimaryKeyValue=$value;
				}
				
				
				else if(isfield($key,$tb)  &&  !$data[substr($key,0,-2)])
				{
					if(isset($value)  && trim($value)!="" )
					{
					$f=$f.$key.",";
					if($key=='BillDate')
					{
						$value=substr($value,0,strpos($value,"T"));
							$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					else{
					$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					}
				}
				else if(isVirtualTable($key))
				{
				
			   $VirtualTable=substr($key,7);
					//echo "VirtualTable=>$VirtualTable <br/>";
				
			    $f=$f.$VirtualTable."Id,";
				$v=$v."'".$value[$VirtualTable."Id"]."',";
				$fv=$fv.$VirtualTable."Id='".$value[$VirtualTable."Id"]."',";
				
				
				}
				else if(substr($key,-3)=="Ids")
				{
					  if($value!=""  )
					  {
						  
					   $DeleteTable=substr($key,0,-3);
					   $DetailTable[$key]="Delete FROM $DeleteTable WHERE ".$DeleteTable."Id in( ".$value.")";
					   //echo  $DeleteTable." ".$value."<br/>";
					  }
					 
					
				}
				else if(isTable($key))
			   {
				  // echo $key."  --> ".count($value)."<br/>";
				   if(is_array($value))
					  if(count($value)>0)
				   $DetailTable[$key]=$value;
				   
				}
		}
		$f1=rtrim($f,",");
		$v1=rtrim($v,",");
		$fv=rtrim($fv,",");
		
		
		$Query="";
	
		if($PrimaryKeyValue==0)
			$Query= "INSERT INTO $tb ($f1) values ($v1)";
		else
			$Query= "UPDATE $tb SET $fv where $PrimaryKey= $PrimaryKeyValue";
		//echo $Query;
		//echo $key."<br/>start-->  ".json_encode($DetailTable)."<br/>";
		return $Query;
	}
	
	
		  function InsertUpdate2($tb,$data,$insertKey,$insertValue,&$DetailTable)
	{
		
		
		
		$f="";
		$f=$insertKey.",";
	
		$v="";
	    $v=$insertValue.",";
	  
		$fv="";
		$PrimaryKey=$tb.'Id';
		
		$PrimaryKey=GetPrimaryKey($tb);
	
		$PrimaryKeyValue=0;
		//Remove Id MasterTable
		if( array_search($insertKey,$data))
		{
				
			unset($data[$insertKey]);
			
		}
		
		foreach( $data as $key=>$value){
			
				
				
				if($key==$PrimaryKey)
				{
					$PrimaryKeyValue=$value;
				}
				
				
				else if(isfield($key,$tb)  &&  !$data[substr($key,0,-2)])
				{
					if(isset($value)  && trim($value)!="" )
					{
					$f=$f.$key.",";
					if($key=='BillDate')
					{
						$value=substr($value,0,strpos($value,"T"));
							$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					else{
					$v=$v."'".$value."',";
					$fv=$fv.$key."='".$value."',";
					}
					}
				}
				else if(isVirtualTable($key))
				{
					$VirtualTable=substr($key,7);
					//echo "VirtualTable=>$VirtualTable <br/>";
				
			    $f=$f.$VirtualTable."Id,";
				$v=$v."'".$value[$VirtualTable."Id"]."',";
				$fv=$fv.$VirtualTable."Id='".$value[$VirtualTable."Id"]."',";
				
				
				}
				else if(isTable($key))
			   {
				   if(is_array($value))
					  if(count($value)>0)
				   $DetailTable[$key]=$value;
				   
				}
		}
		$f1=rtrim($f,",");
		$v1=rtrim($v,",");
		$fv=rtrim($fv,",");
		
		
		$Query="";
	
		if($PrimaryKeyValue==0)
			$Query= "INSERT INTO $tb ($f1) values ($v1)";
		else
			$Query= "UPDATE $tb SET $fv where $PrimaryKey= $PrimaryKeyValue";
		//echo $Query."<br/>";
		
		return $Query;
		
	}
	
	  function isfield($key,$tb)
	{
		
		$Query="select *  from information_schema.COLUMNS  where table_name='$tb' and column_name='$key'";
		$obj=new DyamicClass();
		
		$rows=$obj->getQuery($Query);
		
			if(count($rows)>0)
			return true;
		else
			return false;
		
	}
	  function GetPrimaryKey($tableName)
	{
		
		
		$obj=new DyamicClass();
	$Query=$obj->getPrimaryKey($tableName);
	//echo $Query;
		$rows=$obj->getQuery($Query);
			
			if(count($rows)>0)
			return $rows[0]['COLUMN_NAME'];
		else
			return "";
		
	}
		function isVirtualTable($tableName)
		{
			//echo "TestisVirtualTable  :".$tableName."   ".substr($tableName,0,7)."<br/>";
			
			if(substr($tableName,0,7)=="Virtual")
			{
				
				return true;
				/*
			$tableName=substr($tableName,6)
			
		$Query="select *  from information_schema.tables where table_Name='$tableName'";
		
		$obj=new DyamicClass();
		$rows=$obj->getQuery($Query);
	
	
			if(count($rows)>0)
			return true;
		else
			return false;
		*/
			}
			else
				return false;
		}
	
	  function isTable($key)
	{
		$Query="select *  from information_schema.tables where table_Name='$key'";
		
		$obj=new DyamicClass();
		$rows=$obj->getQuery($Query);
	
	
			if(count($rows)>0)
			return true;
		else
			return false;
		
		
	}
	  function isTables($key)
	{
		return false;
	}

?>
