myApp.controller('accountdetailsControl', function ($scope, $state, $http, $location,$stateParams) {
	
	  var vm = this;
	  vm.dbdata={};
	  vm.AccountMasterId=$stateParams.AccountMasterId;
	  //AccountMaster
	   $http.get('php/DyamicOperation.php?getObject=AccountMaster&PrimaryKey=AccountMasterId&PrimaryValue='+   vm.AccountMasterId).then(function (response) {
			
             vm.dbdata.AccountMaster= response.data;
			
       });
	   console.log(vm.AccountMasterId);
	   //AccountDetails
	     $http.get("php/DyamicOperation.php?Query=select *, if((@balance:=@balance%2Bbal)>0,concat(round(@balance,2),' Cr'),concat( round(@balance*-1,2),' Dr')) as Balance from vwaccountdetails join (Select @balance:=0) x where AccountMasterId="+ vm.AccountMasterId.toString()).then(function (response) {
		
           vm.AccountDetails= response.data.listdata;
		
            
		
			
       });
	
});