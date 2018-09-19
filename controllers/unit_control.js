myApp.controller('unit_control', function ($scope, $state, $http, $location) {
    var vm = this;
	vm.hideform=false;
	 vm.Query="Select *  from UnitMaster";
	  vm.title="unit Master";
	vm.dbdata={};
	
	 
	 vm.load=function ()
	 {
	$http.get('php/DyamicOperation.php?Query=Select *  from UnitMaster').then(function (response) {
		
		 
           vm.listdata = response.data.listdata;
		
        		
			
       });
	 }
	
	    $http.get('json/UnitMaster.js').then(function (response) {
		  vm.hideform=false;
           vm.formFields = $scope.$eval( response.data);
		  
	
		 
        		
			
       });
	 vm.hideform=false;
	vm.addmode=function ()
	 { 	
		 vm.dbdata.UnitMaster={};
		   
		  
			vm.showform=!	vm.showform;
			console.log('addmode');
	 }
	  
	 vm.editmode=function (object,index)
	 {
		 
		   $http.get('php/DyamicOperation.php?getObject=UnitMaster&PrimaryKey=UnitMasterId&PrimaryValue='+ object.UnitMasterId).then(function (response) {
             vm.dbdata.UnitMaster= response.data;
			vm.showform=!	vm.showform;
			 
			 
        });
		 
		   
		    

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
        $http.get('php/DyamicOperation.php?deleteObject=UnitMaster&PrimaryKey=UnitMasterId&PrimaryValue='+object.UnitMasterId).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
           vm.load();
        });
				}
	 }
	 
	   vm.load();

	vm.hideform=false;
	
	
  
});