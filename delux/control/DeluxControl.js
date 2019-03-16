myApp.controller('delux_control', function ($scope, $state, $http, $location,$filter,$stateParams,$timeout,URL) {
	
	var del_con = this;
del_con.editDialog = new EditPersonDialogModel();
	  
	  del_con.editindex=-1;
	    del_con.dbdata={};
	//if($stateParams.ParentMenuMasterId==$stateParams.MenuMasterId)
	  $http.get(URL+"?Query=select *  from MenuMaster where   MenuMasterId<>ParentMenuMasterId and ParentMenuMasterId="+$stateParams.ParentMenuMasterId).then(function (response) {
			
            del_con.menulist= response.data.listdata;
			
       });
	   
	   $http.get(URL+"?Query=select *  from MenuMaster where  MenuMasterId="+$stateParams.MenuMasterId).then(function (response) {
			
            del_con.selmenu= response.data.listdata[0];
			
			
			if(del_con.selmenu.Query!="")
	   {
		   del_con.loadReport();
	   }
	   
	   if(del_con.selmenu.FormMasterId!=""  &&  del_con.selmenu.FormMasterId !=null)
	   {
		   
		   del_con.loadForm();
	   }
	   
	   
	   
       });
	   
	  
 del_con.loadForm=function ()
	 {
		 
		$http.get(URL+'?Query= select * FROM FormMaster  where FormMasterid='+ del_con.selmenu.FormMasterId).then(function (response) {
		
           del_con.FormMaster = response.data.listdata[0];
		
			$http.get(URL+'?Query= select * FROM TableMaster  where TableMasterId='+ del_con.FormMaster.TableMasterId).then(function (response) {
				
				del_con.TableMaster= response.data.listdata[0];
				
				
			});
        					 $http.get('json/'+del_con.FormMaster.jsonFileName).then(function (response) {
		
           //del_con.formFields = $scope.$eval( response.data);
			console.log( $scope.$eval( response.data));
				});
				
				
			$http.get(URL+'?Query= call  getFormFields('+del_con.FormMaster.TableMasterId+')').then(function (response) {
				
				del_con.formFields=response.data.listdata;
				console.log(del_con.formFields);
			});
	   
		});
		 
	 }
	 

	  
	 del_con.loadReport=function ()
	 {
		$http.get(URL+'?Query='+ del_con.selmenu.Query).then(function (response) {
		
           del_con.listdata = response.data.listdata;
		
		 
        		
			
       });
	 }
	 
	 
	 
	 del_con.addmode=function ()
	 { 	
	 
	del_con.dbdata[del_con.TableMaster.TableName]={}; 
			del_con.editDialog.open2();
			
			
	 }
	  
	 del_con.editmode=function (object,index)
	 {
		 if(del_con.TableMaster==null)
		 {
		
		//$state.go('deluxform',{VoucherTypeId:object["VoucherTypeId"].toString(),TranId:object["TranId"].toString()});
			 		  $timeout(function() { $state.go('deluxform',{VoucherTypeId:object["VoucherTypeId"].toString(),TranId:object["TranId"].toString()}); }); 
		 }
		 else
		 {
		 var MainObject={PrimaryValue:object[del_con.TableMaster.MasterKey],PrimaryKey:del_con.TableMaster.MasterKey,TableNames:{TableName:del_con.TableMaster.TableName}};
		 
		  
			  $http.get(URL+'?getObject=' +angular.toJson( MainObject)).then(function (response) {
             del_con.dbdata[del_con.TableMaster.TableName]= response.data; 
			 
			del_con.editDialog.open();
			del_con.index=index;
			  
			 
        });
		 }

	 }
	 
	  del_con.InsertUpdate=function ()
	 {
		 
		 $http.post(URL,del_con.dbdata).then(function (response) {
            del_con.msg = response.data.message;
            del_con.alert_class = 'custom-alert';
			 
			 del_con.editDialog.close();
           if(del_con.dbdata[del_con.TableMaster.TableName][del_con.TableMaster.MasterKey]==0 ||del_con.dbdata[del_con.TableMaster.TableName][del_con.TableMaster.MasterKey]==undefined )
		   {
				del_con.dbdata[del_con.TableMaster.TableName]={}; 
		   }
		   else
		   {
			    del_con.dbdata[del_con.TableMaster.TableName]={};
				del_con.editindex=-1;
		   }
			del_con.loadReport(); //vishal:Load Remove  in Refresh code here
			
            
        });
		 
		  
	 }
	 
	  del_con.deletemode=function(object,index)
	 {
		  
		  
		     var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
				$http.get(URL+'?deleteObject2='+del_con.TableMaster.TableName+'&PrimaryKey='+del_con.TableMaster.MasterKey+'&PrimaryValue='+object[del_con.TableMaster.MasterKey]).then(function (response) {
            del_con.msg = response.data.message;
            del_con.alert_class = 'custom-alert';
           del_con.loadReport(); //vishal:Load Remove  in row Remove Code here
		  
        });
				}
	 }
/*
    
	vm.editDialog = new EditPersonDialogModel();
	  vm.HyperLink=1;
	  vm.editindex=-1;
			$http.get(URL+'?Query=Select *  from master').then(function (response) {
		
           vm.master = response.data.listdata;
		  if($stateParams.masterId!=undefined)
		  {
			  vm.start(vm.master[$stateParams.masterId]);
		  }
			 
       });
	  
	   vm.selectmaster=function(master)
	   {
		  
		      
			 
			vm.start(master);
		
	   }
	  vm.dbdata={};
	
	 vm.start=function(master)
	 {
		 
		 vm.selMaster =master;
			 vm.title= vm.selMaster.MasterName;
			 vm.MasterTableName= vm.selMaster.MasterTableName;
			 vm.MasterPrimaryKey= vm.selMaster.MasterPrimaryKey;
			 vm.MasterView= vm.selMaster.MasterView;
			 vm.HyperLink= vm.selMaster.HyperLink;
			 vm.HyperLink= vm.selMaster.HyperLink;
			 vm.LocationPath=vm.selMaster.LocationPath;
			   //vm = angular.copy(vm.selMaster);
			 if( vm.HyperLink=="1")
			 {
				  $location.path(vm.selMaster.HyperName);
			 }
			 
		 	
			
		vm.load();
		   
	
	    $http.get('json/'+vm.MasterTableName+'.js').then(function (response) {
		
           vm.formFields = $scope.$eval( response.data);
			
       });
	   vm.Tableview={};
	   $http.get('json/'+vm.MasterView+'.js').then(function (response) {
		
           vm.Tableview = $scope.$eval( response.data);
			
       });
	  
	  
	 }
	
	
	
	 
	 
	
	 
	
	 vm.doubleclick=function (object,index)
	 {
		

		
		  if(vm.LocationPath!='' && vm.LocationPath!=null )
		  {
			 
		 
		 var result={};
		  result[vm.MasterPrimaryKey]=object[vm.MasterPrimaryKey].toString();
		  $state.transitionTo(vm.LocationPath,result,{   reload: true, inherit: false, notify: true});
		 	//$state.reload();
            vm.hideform=!vm.hideform;
			vm.HyperLink=1;
		   
		  }
		  
		   

	 }
	 
	 
	
	
	 
	vm.findIndex=function (arraydata,PrimaryKey,PrimaryKeyValue)
		{
			var index=-1;
			var ans=-1;
			angular.forEach(arraydata,function(object)
			{
				index++;
				  
				if(object[vm.MasterPrimaryKey].toString()==PrimaryKeyValue.toString())
					ans=index;
				
			});
			  
			  return ans;
			 
}
	  
	
	*/
	});
