myApp.controller('master_control', function ($scope, $state, $http, $location,$filter,$stateParams,URL) {
    var vm = this;
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
	
	
	 vm.load=function ()
	 {
	$http.get(URL+'?Query=Select *  from '+ vm.MasterView).then(function (response) {
		
           vm.listdata = response.data.listdata;
		
		 
        		
			
       });
	 }
	 
	 
	 vm.updatemode=function(object)
	 {
		// temp=vm.dbdata[vm.MasterTableName]; 
		 
		 vm.dbdata[vm.MasterTableName]=object; 
		  vm.InsertUpdate();
		 // vm.dbdata[vm.MasterTableName]=temp; 
	 }
	 
	vm.addmode=function ()
	 { 	
	 // vm.InsertUpdate();
	vm.dbdata[vm.MasterTableName]={}; 
			vm.editDialog.open();
			
	 }
	  
	 vm.editmode=function (object,index)
	 {
		 var MainObject={PrimaryValue:object[vm.MasterPrimaryKey],PrimaryKey:vm.MasterPrimaryKey,TableNames:{TableName:vm.MasterTableName}};
		 
		  
			  $http.get(URL+'?getObject1=' +angular.toJson( MainObject)).then(function (response) {
             vm.dbdata[vm.MasterTableName]= response.data; 
			 
			vm.editDialog.open();
			vm.index=index;
			  console.log("idex:"+vm.index);
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
		   //console.log(result);
		  }
		  
		   

	 }
	 
	 
	 vm.InsertUpdate=function ()
	 {
		 
		 $http.post(URL,vm.dbdata).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
			 
			 vm.editDialog.close();
           if(vm.dbdata[vm.MasterTableName][vm.MasterPrimaryKey]==0 ||vm.dbdata[vm.MasterTableName][vm.MasterPrimaryKey]==undefined )
		   {
				vm.dbdata[vm.MasterTableName]={}; 
		   }
		   else
		   {
			    vm.dbdata[vm.MasterTableName]={};
				vm.editindex=-1;
		   }
			vm.load(); //vishal:Load Remove  in Refresh code here
			/*
		   Id=vm.dbdata[vm.MasterTableName][vm.MasterPrimaryKey];
		  
			if(Id>0)
			{
				$scope.Query='php/DyamicOperation.php?Query=Select *  from '+ vm.MasterView+"  Where "+vm.MasterPrimaryKey+"="+Id;
			}
			else if(Id==undefined  ||  Id==0)
			{
				$scope.Query='php/DyamicOperation.php?Query=Select *  from '+ vm.MasterView+" Order by "+vm.MasterPrimaryKey+" desc";
			}
			 console.log($scope.Query+"   "+vm.index);
			
				$http.get($scope.Query).then(function (response) {
		
				if(response.data.listdata.length>0)
				{
					 vm.Index=vm.findIndex(vm.listdata ,vm.MasterPrimaryKey ,Id);
					 console.log(vm.listdata);
						if(vm.index>=0)
						{
							
					vm.listdata[vm.index] =response.data.listdata[0];
					
						}
				     else
        		     vm.listdata.push(response.data.listdata[0]);
				}
			
				});
			*/
            
        });
		 
		  
	 }
	 vm.deletemode=function(object,index)
	 {
		  
		  console.log(index);
		     var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
				$http.get(URL+'?deleteObject='+vm.MasterTableName+'&PrimaryKey='+vm.MasterPrimaryKey+'&PrimaryValue='+object[vm.MasterPrimaryKey]).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
           vm.load(); //vishal:Load Remove  in row Remove Code here
		   /*vm.Index=vm.findIndex(vm.listdata ,vm.MasterPrimaryKey ,object[ vm.MasterPrimaryKey]);
		   if(vm.Index>=0)
			vm.listdata.splice(vm.Index, 1); 
		    */
        });
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
	  
	
	
	});