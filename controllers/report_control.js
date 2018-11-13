myApp.controller('report_control', function ($scope, $state, $http, $location,$filter,URL) {
    var vm = this;
	
			$http.get(URL+'?Query=Select *  from report').then(function (response) {
		
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
		
		 
	/*
	    $http.get('json/'+vm.MasterTableName+'.js').then(function (response) {
		
           vm.formFields = $scope.$eval( response.data);
			
       });
	   
	  */
	  
	 vm.load(report.ProcedureName);
	 }
	
	 
	 vm.load=function (ProcedureName)
	 {
	
		$http.get(URL+'?Query=call '+ProcedureName).then(function (response) {
		
		vm.listdata= response.data.listdata;
		
        
			
       });
	   
		 
		 
			
	 }
	  
	 
	 

	  
	
	 
	 
	
	
	 
	
	  
	
	
	});