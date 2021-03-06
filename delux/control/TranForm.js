myApp.controller('DeluxForm', function ($scope, myService ,$state, $http, $location,$stateParams,$filter,$timeout,$q,URL) {
    var vm = this;
	vm.dbdata={};
	vm.struct={};
	vm.menu={};
	vm.GetObjectTable={};
	vm.DeleteObjectTable={};
	
	   //Menu
	$http.get(URL+"?Query=select *  from MenuMaster where  MenuMasterId="+$stateParams.MenuMasterId).then(function (response) 
	{
        vm.selmenu= response.data.listdata[0];
		
		
		if(vm.selmenu.FormMasterId!="")
		{	
			$http.get(URL+'?Query=select *  from TableMaster inner join FormTable  on  TableMaster.TableMasterId= FormTable.TableMasterId  Where FormMasterId='+vm.selmenu.FormMasterId).then(function (response) 
			{
				for(vm.i=0;vm.i<response.data.listdata.length;vm.i++)
				{
					if(vm.i==0)
					{
							vm.struct.TableName=response.data.listdata[vm.i].TableName;
							vm.struct.MasterKey=response.data.listdata[vm.i].MasterKey;
							vm.GetObjectTable.PrimaryKey=response.data.listdata[vm.i].MasterKey;
							vm.GetObjectTable.TableNames={};
							vm.GetObjectTable.TableNames.TableName=response.data.listdata[vm.i].TableName;
							vm.GetObjectTable.TableNames.Relation=[];
							vm.struct.TableStruct={};
							vm.dbdata[vm.struct.TableName] = {};
					}
					else
					{
						var TableDetailName={};
								  TableDetailName["TableName"]=response.data.listdata[vm.i].TableName;
								vm.GetObjectTable.TableNames.Relation.push(TableDetailName);
								vm.dbdata[vm.struct.TableName][TableDetailName+"Ids"]="";
								
					}
							var TableMasterId=response.data.listdata[vm.i].TableMasterId;
							var sqlquery='select *  from  vwformcontrolmaster where FormTableId='+response.data.listdata[vm.i].FormTableId+' order by ordernum';
							//var sqlquery='SELECT if(formcontrolmaster.FieldName is null,Tablecontrolmaster.FieldName ,formcontrolmaster.FieldName) AS FieldName,if(formcontrolmaster.FieldName is null,Tablecontrolmaster.ControlTypeName ,formcontrolmaster.ControlTypeName) AS ControlTypeName,if(formcontrolmaster.FieldName is null,Tablecontrolmaster.Caption ,formcontrolmaster.Caption) AS Caption,if(formcontrolmaster.FieldName is null,Tablecontrolmaster.TableName ,formcontrolmaster.TableName) AS TableName,if(formcontrolmaster.FieldName is null,Tablecontrolmaster.Query ,formcontrolmaster.Query) AS Query,if(formcontrolmaster.FieldName is null,Tablecontrolmaster.ComboQuery ,formcontrolmaster.ComboQuery) AS ComboQuery,if(formcontrolmaster.FieldName is null,null ,formcontrolmaster.onchange) AS onchange ,if(formcontrolmaster.FieldName is null,null ,formcontrolmaster.Aggregate) AS Aggregate,if(formcontrolmaster.FieldName is null,null ,formcontrolmaster.WhereCondition) AS WhereCondition,if(formcontrolmaster.FieldName is null,null ,formcontrolmaster.DefaultData) AS DefaultData FROM Tablecontrolmaster inner join formtable on formtable.TableMasterid=Tablecontrolmaster.TableMasterid Left join formcontrolmaster on formcontrolmaster.FormTableId=formtable.FormTableId and formcontrolmaster.FieldName=Tablecontrolmaster.FieldName where formtable.FormTableId='+response.data.listdata[vm.i].FormTableId+' order by Tablecontrolmaster.orderNum';
							
							
							
							var url=URL+'?Query= '+sqlquery;
							var data=vm.getData(url);
							
						if(vm.i==0)
						vm.struct.TableStruct=data;
						else
						{  	if(vm.struct.structDetail==null)
								vm.struct.structDetail=[];
								var TableDetailName={};
								TableDetailName[response.data.listdata[vm.i].TableName]=data;
								vm.struct.structDetail.push(TableDetailName);
								
						}
							
				}
				if( $stateParams.UniqueId>0)
				{
							vm.GetObjectTable.PrimaryValue=$stateParams.UniqueId
							
							vm.dbdata[vm.struct.TableName][vm.struct.MasterKey]=$stateParams.UniqueId;
							vm.GetObject($stateParams.UniqueId);
				}
				vm.dbdata[vm.struct.TableName]["BillDate"]=new Date();
				vm.dbdata[vm.struct.TableName]["VoucherTypeId"]=vm.selmenu.VoucherTypeId;
						
						
			});
		}
	});
	
	 this.getData=function (url)
	 {
		 
					var data={};
							var xhr = new XMLHttpRequest();
							xhr.open("GET",url, false);
							xhr.onload = function (e) {
							if (xhr.readyState === 4) {
							if (xhr.status === 200) {
								data= $scope.$eval(xhr.responseText)["listdata"];
							
							} else {
							console.error(xhr.statusText);
						
							}
								}
							};
							xhr.onerror = function (e) {
							console.error(xhr.statusText);
							};
							xhr.send(null);
							return data;
	 }
	
// addTran & InsertUpdate
    this.addTran = function () 
		{
		   //$http.post(URL, vm.dbdata).then(function (response) 
		   //{
			   $http.get(URL+'?saveObject=' +angular.toJson( vm.dbdata)).then(function (response) {
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
			var MainObject={PrimaryValue:TranId,PrimaryKey:'TranId',TableNames:{TableName:vm.struct.TableName, Relation:[{TableName:'TranDetails'},{TableName:'Tranfin'}]}};
		console.log(MainObject);
			console.log(vm.GetObjectTable);
			$http.get(URL+'?getObject=' +angular.toJson( vm.GetObjectTable)).then(function (response)
			{
				vm.dbdata[vm.struct.TableName] = response.data;
				vm.dbdata[vm.struct.TableName]["BillDate"]=new Date(vm.dbdata[vm.struct.TableName]["BillDate"]);
				
				for(index=0;index<vm.GetObjectTable.TableNames.Relation.length;index++)
				{
					var TableDetailName=vm.GetObjectTable.TableNames.Relation[index]["TableName"];
					vm.dbdata[vm.struct.TableName][TableDetailName+"Ids"]="";
				}
				console.log(vm.dbdata);
				/*
				for(i=0; i<vm.dbdata.Tran.TranDetails.length;i++)
				{
					vm.dbdata.Tran.TranDetails[i].ExpireDate=new Date(vm.dbdata.Tran.TranDetails[i].ExpireDate);
				}
				*/
			});
		}
    };

//deleteObject
    this.deleteObject = function (TranId) 
	{
		var yesno = confirm('Are you sure remove Record1?');
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

