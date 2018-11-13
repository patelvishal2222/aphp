myApp.controller('backup_control', function ($scope, $state, $http, $location,URL) {
    var vm = this;
	
	 vm.backupdb=function()
	 {
		  
		  
		   
        $http.get(URL+'?backupdb=account').then(function (response) {
            alert('sucess');
        });
			
	 }
	
	});