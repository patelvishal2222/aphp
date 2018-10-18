

myApp.controller('TranDyamic_Control', function ($scope, $state, $http, $location,$stateParams,$filter) {
    var vm = this;
  
    
	vm.dbdata={};
     vm.dbdata.tran = {};
	 vm.dbdata.tran.TranId=$stateParams.TranId;
	 vm.dbdata.tran.VoucherTypeId=$stateParams.VoucherTypeId;
	 vm.dbdata.tran.TranDetailsIds="";
	 vm.dbdata.tran.TranfinIds="";
	 
	  vm.dbdata.tran.BillDate=new Date();
	  
	 
	 
	   //Menu
	    $http.get('php/DyamicOperation.php?Query=select *  from vouchertype' ).then(function (response) {
           $scope.menulist = response.data.listdata;
           $scope.selmenu = $filter('filter')( $scope.menulist , {VoucherTypeId: vm.dbdata.tran.VoucherTypeId})[0];
		   if(vm.dbdata.tran.VoucherTypeId>0 )
		   {
			vm.color=$scope.selmenu.Color;
			vm.Title=$scope.selmenu.Name;
			vm.jsonFileName=$scope.selmenu.jsonFileName;
			vm.tablename=$scope.selmenu.tablename;
			 $http.get('json/'+vm.jsonFileName+'.js' ).then(function (response) {
           
		     vm.trandata = $scope.$eval( response.data);
			 if( vm.dbdata.tran.TranId>0)
			 {
				 vm.GetObject(vm.dbdata.tran.TranId);
			 }
			
			});
	
			}
			
       });
	      
	
	  
		
			
			
	
	
//    addTran & InsertUpdate

    this.addTran = function () {
		
		   $http.post('php/DyamicOperation.php', vm.dbdata).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("sales_frm").reset();
            $location.path('transcation');
           

        });
    };
	
	
//GetObject
    this.GetObject = function (TranId) {
		
		if(TranId>0)
		{
			
				var MainObject={PrimaryValue:TranId,PrimaryKey:'TranId',TableNames:{TableName:'tran', Relation:[{TableName:'trandetails'},{TableName:'tranfin'}]}};
        $http.get('php/DyamicOperation.php?getObject1=' +angular.toJson( MainObject)).then(function (response) {
            vm.dbdata.tran = response.data;
			console.log(vm.dbdata.tran);
			 vm.dbdata.tran.BillDate=new Date(vm.dbdata.tran.BillDate);
			 //vm.dbdata.tran.TranDetailsIds="";
			  //vm.dbdata.tran.TranfinIds="";
			 
			 
			
        });
		}
    };




//deleteObject

    this.deleteObject = function (TranId) {
		                    var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
					
							var MainObject={PrimaryValue:TranId,PrimaryKey:'TranId',TableNames:[{TableName:'TranDetails'},{TableName:'TranFin'},{TableName:'Tran'}]};
			$http.get('php/DyamicOperation.php?deleteObject1=' +angular.toJson(MainObject)).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.loadData($scope.currentPage);
        });
				}
    };


    

});

