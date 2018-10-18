myApp.controller('itemdetailsControl', function ($scope, $state, $http, $location,$stateParams,$filter) {
	  var vm = this;
	  vm.dbdata={};
	  
	  
	  var d=new Date();
	  vm.StartDate=new Date();
	  vm.EndDate=new Date(1900+d.getYear(),d.getMonth()-1,1);
	  vm.ItemMasterId=$stateParams.ItemMasterId;
	  
	  
	  //AccountMaster
	   $http.get('php/DyamicOperation.php?getObject=ItemMaster&PrimaryKey=ItemMasterId&PrimaryValue='+   vm.ItemMasterId).then(function (response) {
			
             vm.dbdata.ItemMaster= response.data;
			
       });
	   
	   
	   //AccountDetails
	   vm.Serach=function()
	   {
		   var sql='select * ,@balance:=@balance%2BStock  as StockQty from vwitemdetails join (Select @balance:=0) x  where ItemMasterId='+ vm.ItemMasterId.toString("yyyy-mm-dd")+'  and BillDate<=\''+$filter('date')( vm.StartDate,'yyyy-MM-dd')  +'\'  and BillDate>=\''+$filter('date')( vm.EndDate,'yyyy-MM-dd')+'\'';
		   //var sql='select * ,@balance:=@balance%2BStock  as StockQty from vwitemdetails join (Select @balance:=0) x  where ItemMasterId='+ vm.ItemMasterId;
		   
	    $http.get('php/DyamicOperation.php?Query='+sql).then(function (response) {
		
           vm.ItemDetails= response.data.listdata;
		
            
		
			
       });
	   
	   
	   
	   
	   }
	   
	   
	   vm.Serach();
});