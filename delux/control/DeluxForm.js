myApp.controller('DeluxForm', function ($scope, $state, $http, $location,$stateParams,$filter,URL) {
    var vm = this;
	vm.dbdata={};
    vm.dbdata.tran = {};
	vm.dbdata.tran.TranId=$stateParams.UniqueId;
	vm.menu={};
	vm.dbdata.tran.BillDate=new Date();
	vm.menu.tablename="TranFin";
	   //Menu
	$http.get(URL+"?Query=select *  from MenuMaster where  MenuMasterId="+$stateParams.MenuMasterId).then(function (response) 
	{
        vm.selmenu= response.data.listdata[0];
		vm.dbdata.tran.VoucherTypeId=vm.selmenu.VoucherTypeId;
		
		if(vm.selmenu.FormMasterId!="")
		{	
			$http.get(URL+'?Query=select *  from FormMaster WHERE FormMasterId='+vm.selmenu.FormMasterId ).then(function (response) 
			{
				vm.selFormMaster = response.data.listdata[0];
				if( vm.selFormMaster.TableMasterId>0 )
				{
					$http.get(URL+'?Query= call  getFormFields('+vm.selFormMaster.TableMasterId+')').then(function (response) 
					{
					vm.trandata={};
					//vm.trandata.TranscationEntry = response.data.listdata;
					vm.trandata.TranscationEntry = response.data[1];
					vm.trandata.TransctionTable=response.data[2];
					
						if( vm.dbdata.tran.TranId>0)
						{
						vm.GetObject(vm.dbdata.tran.TranId);
						}
					});
				}
				else
				{
					$http.get('json/'+vm.selFormMaster.jsonFileName ).then(function (response)
					{
					vm.trandata = $scope.$eval( response.data);
					});
					if( vm.dbdata.tran.TranId>0)
						{
						vm.GetObject(vm.dbdata.tran.TranId);
						}
				}
				
			});
			
		}
		
	});
	
	
	
// addTran & InsertUpdate
    this.addTran = function () 
		{
		   $http.post(URL, vm.dbdata).then(function (response) 
		   {
			   //$http.get(URL+'?saveObject=' +angular.toJson( vm.dbdata)).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("sales_frm").reset();
            $location.path('deluxstate/100/0');
			});
		};
	//GetObject
    this.GetObject = function (TranId) 
	{	if(TranId>0)
		{
			var MainObject={PrimaryValue:TranId,PrimaryKey:'TranId',TableNames:{TableName:'tran', Relation:[{TableName:'TranDetails'},{TableName:'Tranfin'}]}};
			$http.get(URL+'?getObject=' +angular.toJson( MainObject)).then(function (response)
			{
				vm.dbdata.tran = response.data;
				vm.dbdata.tran.BillDate=new Date(vm.dbdata.tran.BillDate);
				vm.dbdata.tran[ vm.menu.tablename+"Ids"]="";
				for(i=0; i<vm.dbdata.tran.TranDetails.length;i++)
				{
					vm.dbdata.tran.TranDetails[i].ExpireDate=new Date(vm.dbdata.tran.TranDetails[i].ExpireDate);
				}
			});
		}
    };

//deleteObject
    this.deleteObject = function (TranId) 
	{
		var yesno = confirm('Are you sure remove Record?');
        if (yesno == true) 
		{
			var MainObject={PrimaryValue:TranId,PrimaryKey:'TranId',TableNames:[{TableName:'TranDetails'},{TableName:'TranFin'},{TableName:'Tran'}]};
			$http.get(URL+'?deleteObject=' +angular.toJson(MainObject)).then(function (response) 
			{
				vm.msg = response.data.message;
				vm.alert_class = 'custom-alert';
				vm.loadData($scope.currentPage);
			});
		}
    };

});

