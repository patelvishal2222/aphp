myApp.controller('itemdetailsControl', function ($scope, $state, $http, $location,$stateParams,$filter,URL) {
	  var vm = this;
	  vm.dbdata={};
	  
	  
	  var d=new Date();
	  vm.StartDate=new Date();
	  vm.EndDate=new Date(1900+d.getYear(),d.getMonth()-1,1);
	  vm.ItemMasterId=$stateParams.ItemMasterId;
	  
	  
	  //AccountMaster
	   $http.get(URL+'?getObject=ItemMaster&PrimaryKey=ItemMasterId&PrimaryValue='+   vm.ItemMasterId).then(function (response) {
			
             vm.dbdata.ItemMaster= response.data;
			
       });
	   $http.get("json/vwitemdetails.js").then(function (response) {
			
             vm.displaydata= $scope.$eval(response.data);
			
       });
	   
	   //AccountDetails
	   vm.Serach=function()
	   {
		   var Query='select * ,@balance:=@balance%2BStock  as StockQty from vwitemdetails join (Select @balance:=0) x  where ItemMasterId='+ vm.ItemMasterId+'  and BillDate<=\''+$filter('date')( vm.StartDate,'yyyy-MM-dd')  +'\'  and BillDate>=\''+$filter('date')( vm.EndDate,'yyyy-MM-dd')+'\'';
		   var  Procedure="call PreItemDetdetail("+ vm.ItemMasterId.toString()+")";
		   
		   
	    $http.get(URL+'?Query='+Procedure).then(function (response) {
		
           vm.ItemDetails= response.data.listdata;
		
            
		
			
       });
	   
	   
	   
	   
	   }
	   
	   vm.doubleclick=function (object,index)
	 {

	 console.log('double click go');
	 console.log(object);
		 $state.go(object["TemplateName"].toString(),{VoucherTypeId:object["VoucherTypeId"].toString(),TranId:object["TranId"].toString()});

	 }
	   vm.Serach();
	   
	  
});