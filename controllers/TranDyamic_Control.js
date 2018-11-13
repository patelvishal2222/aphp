

myApp.controller('TranDyamic_Control', function ($scope, $state, $http, $location,$stateParams,$filter,URL) {
    var vm = this;
  
    
	vm.dbdata={};
     vm.dbdata.tran = {};
	 
	 vm.dbdata.tran.TranId=$stateParams.TranId;
	 vm.dbdata.tran.VoucherTypeId=$stateParams.VoucherTypeId;
	 
	 vm.menu={};
	  vm.dbdata.tran.BillDate=new Date();
	  
	 
	 
	   //Menu
	    $http.get(URL+'?Query=select *  from vouchertype' ).then(function (response) {
           $scope.menulist = response.data.listdata;
           $scope.selmenu = $filter('filter')( $scope.menulist , {VoucherTypeId: vm.dbdata.tran.VoucherTypeId})[0];
		   if(vm.dbdata.tran.VoucherTypeId>0 )
		   {
			 vm.menu=$scope.selmenu;
			
			
			 $http.get('json/'+vm.menu.jsonFileName+'.js' ).then(function (response) {
           
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
		
		   $http.post(URL, vm.dbdata).then(function (response) {
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
			
				var MainObject={PrimaryValue:TranId,PrimaryKey:'TranId',TableNames:{TableName:'tran', Relation:[{TableName:'TranDetails'},{TableName:'Tranfin'}]}};
        $http.get(URL+'?getObject1=' +angular.toJson( MainObject)).then(function (response) {
            vm.dbdata.tran = response.data;
			
			 vm.dbdata.tran.BillDate=new Date(vm.dbdata.tran.BillDate);
			vm.dbdata.tran[ vm.menu.tablename+"Ids"]="";
			 for(i=0; i<vm.dbdata.tran.TranDetails.length;i++)
		{
			console.log(vm.dbdata.tran.TranDetails[i].ExpireDate);
			vm.dbdata.tran.TranDetails[i].ExpireDate=new Date(vm.dbdata.tran.TranDetails[i].ExpireDate);
			console.log("after="+vm.dbdata.tran.TranDetails[i].ExpireDate);
		}
			 
			
        });
		}
    };




//deleteObject

    this.deleteObject = function (TranId) {
		                    var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
					
							var MainObject={PrimaryValue:TranId,PrimaryKey:'TranId',TableNames:[{TableName:'TranDetails'},{TableName:'TranFin'},{TableName:'Tran'}]};
			$http.get(URL+'?deleteObject1=' +angular.toJson(MainObject)).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.loadData($scope.currentPage);
        });
				}
    };


    

});

