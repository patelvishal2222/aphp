myApp.controller('DeluxForm', function ($scope, myService ,$state, $http, $location,$stateParams,$filter,$timeout,$q,URL) {
    var vm = this;
	vm.dbdata={};
	vm.struct={};
	vm.menu={};
	vm.struct.structDetail={};
	
	vm.menu.tablename="Tranfin";
	   //Menu
	$http.get(URL+"?Query=select *  from MenuMaster where  MenuMasterId="+$stateParams.MenuMasterId).then(function (response) 
	{
        vm.selmenu= response.data.listdata[0];
		
		
		if(vm.selmenu.FormMasterId!="")
		{	
			$http.get(URL+'?Query=select *  from FormMaster WHERE FormMasterId='+vm.selmenu.FormMasterId ).then(function (response) 
			{
				vm.selFormMaster = response.data.listdata[0];
				
				
				if( vm.selFormMaster.TableMasterId>0 )
				{
					
					$http.get(URL+'?Query=select *  from TableMaster Where ParentTableMasterId='+vm.selFormMaster.TableMasterId).then(function (response) 
					{
					
						for(vm.i=0;vm.i<response.data.listdata.length;vm.i++)
						{
							if(vm.i==0)
							{
							vm.struct.TableName=response.data.listdata[vm.i].TableName;
							vm.struct.MasterKey=response.data.listdata[vm.i].MasterKey;
							vm.struct.TableStruct={};
							vm.dbdata[vm.struct.TableName] = {};
							}
							else
							{
								vm.struct.structDetail[response.data.listdata[vm.i].TableName]={};
								//vm.struct.structDetail[response.data.listdata[vm.i].TableStruct]={};
								
							}
							
						
							 var TableMasterId=+response.data.listdata[vm.i].TableMasterId;
								var url=URL+'?Query= call  getFormFields('+TableMasterId+')';
								/*
								var	data=vm.getLogData(url);
								  console.log(data);
									if(vm.i==0)
										
							vm.struct.TableStruct=data;
								else
									vm.struct.structDetail[response.data.listdata[vm.i].TableName]=data;
							 
							*/
							
							
								var data={};
							var xhr = new XMLHttpRequest();
							xhr.open("GET",url, false);
							xhr.onload = function (e) {
							if (xhr.readyState === 4) {
							if (xhr.status === 200) {
								data= $scope.$eval(xhr.responseText)["listdata"];
								  console.log(data);
								if(vm.i==0)
										
							vm.struct.TableStruct=data;
								else
									vm.struct.structDetail[response.data.listdata[vm.i].TableName]=data;
								
							//console.log(xhr.responseText);
							} else {
							console.error(xhr.statusText);
							}
								}
							};
							xhr.onerror = function (e) {
							console.error(xhr.statusText);
							};
							xhr.send(null);
								
								
							
								
								
						 
						
							
							
							
						}
						if( $stateParams.UniqueId>0)
						{
							vm.dbdata[vm.struct.TableName][vm.struct.MasterKey]=$stateParams.UniqueId;
							vm.GetObject($stateParams.UniqueId);
						}
							vm.dbdata[vm.struct.TableName]["BillDate"]=new Date();
							vm.dbdata[vm.struct.TableName]["VoucherTypeId"]=vm.selmenu.VoucherTypeId;
						
						
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
	
	 this.getLogData = function(url) {
        return $http({
            url : url,
            method : 'GET',
            async : false,
            cache : false,
            headers : { 'Accept' : 'application/json' , 'Pragma':'no-cache'}
            
        }).success(function(data) {
			
           return data;
        });
	 }
   
	
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

