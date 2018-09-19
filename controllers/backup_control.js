myApp.controller('backup_control', function ($scope, $state, $http, $location) {
    var vm = this;
	
	 vm.backupdb=function()
	 {
		  
		  
		   
        $http.get('php/DyamicOperation.php?backupdb=account').then(function (response) {
            alert('sucess');
        });
			
	 }
	
	});