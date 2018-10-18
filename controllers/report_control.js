myApp.controller('report_control', function ($scope, $state, $http, $location,$filter) {
    var vm = this;
	
			$http.get('php/DyamicOperation.php?Query=Select *  from report').then(function (response) {
		
           vm.reports = response.data.listdata;
		  
			  vm.start(vm.reports[0]);
			 
       });
	  
	   vm.selectreport=function(report)
	   {
		  
		      
			 
			vm.start(report);
		
	   }
	  vm.dbdata={};
	
	 vm.start=function(report)
	 {
		 console.log(report);
		 /*
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
			
       });
	   $http.get('json/'+vm.MasterView+'.js').then(function (response) {
		
           vm.Tableview = $scope.$eval( response.data);
			
       });
	   */
	  
	 }
	
	 
	 vm.load=function ()
	 {
	$http.get('php/DyamicOperation.php?Query=Select *  from '+ vm.MasterView).then(function (response) {
		
           vm.listdata = response.data.listdata;
		
		 
        		
			
       });
	 }
	  
	 
	 

	  
	
	 
	 
	
	
	 
	
	  
	
	
	});