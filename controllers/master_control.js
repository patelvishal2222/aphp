myApp.controller('master_control', function ($scope, $state, $http, $location,$filter) {
    var vm = this;
	 vm.hideform=false;
			$http.get('php/DyamicOperation.php?Query=Select *  from master').then(function (response) {
		
           vm.master = response.data.listdata;
		  
			  vm.start(vm.master[0]);
			 
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
			  
			 if( vm.HyperLink=="1")
			 {
				  $location.path(vm.selMaster.HyperName);
			 }
			 
		 	 //vm = angular.copy(vm.selMaster);
			
		vm.load();
		   
	
	    $http.get('json/'+vm.MasterTableName+'.js').then(function (response) {
		
           vm.formFields = $scope.$eval( response.data);
		  
	 
		vm.hideform=false;
        		
			
       });
	  
	 }
	
	  vm.hideform=false;
	 vm.load=function ()
	 {
	$http.get('php/DyamicOperation.php?Query=Select *  from '+ vm.MasterView).then(function (response) {
		
           vm.listdata = response.data.listdata;
		
		 
        		
			
       });
	 }
	  
	 
	 
	vm.addmode=function ()
	 { 	
	 
		 vm.dbdata[vm.MasterTableName]={}; //Error
			vm.showform=!	vm.showform;
			
	 }
	  
	 vm.editmode=function (object,index)
	 {
		 
		   $http.get('php/DyamicOperation.php?getObject='+vm.MasterTableName+'&PrimaryKey='+vm.MasterPrimaryKey+'&PrimaryValue='+ object[vm.MasterPrimaryKey]).then(function (response) {
             vm.dbdata[vm.MasterTableName]= response.data; //Error
			 
			vm.showform=!	vm.showform;
        });

	 }
	 vm.doubleclick=function (object,index)
	 {
		
		
		
		  if(vm.LocationPath!='' && vm.LocationPath!=null )
		  {
			 
		  //$location.path("master/itemdetails/9");
		  var result = {'ItemMasterId':9};
		  $state.transitionTo("/master.itemdetails",result,{   reload: true, inherit: false, notify: true});
		 	//$state.reload();
			
		   console.log($state.current);
		  }
		  
		   

	 }
	 
	 
	 vm.InsertUpdate=function ()
	 {
		 
		 $http.post('php/DyamicOperation.php', vm.dbdata).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.hideform=!vm.hideform;
			vm.load();
            
        });
		 
		  
	 }
	 vm.deletemode=function(object,index)
	 {
		  
		  
		     var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
				$http.get('php/DyamicOperation.php?deleteObject='+vm.MasterTableName+'&PrimaryKey='+vm.MasterPrimaryKey+'&PrimaryValue='+object[vm.MasterPrimaryKey]).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
           vm.load();
        });
				}
	 }
	 
	
	  
	
	
	});