myApp.controller('itemdetailsControl', function ($scope, $state, $http, $location,$stateParams) {
	  var vm = this;
	  vm.dbdata={};
	  vm.ItemMasterId=$stateParams.ItemMasterId;
	  //AccountMaster
	   $http.get('php/DyamicOperation.php?getObject=ItemMaster&PrimaryKey=ItemMasterId&PrimaryValue='+   vm.ItemMasterId).then(function (response) {
			
             vm.dbdata.ItemMaster= response.data;
			
       });
	   
	   //AccountDetails
	    $http.get('php/DyamicOperation.php?Query=select * ,@balance:=@balance@plus@Stock  as StockQty from vwitemdetails join (Select @balance:=0) x  where ItemMasterId='+ vm.ItemMasterId.toString()).then(function (response) {
		
           vm.ItemDetails= response.data.listdata;
		
            
		
			
       });
});