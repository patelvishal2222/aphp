myApp.controller('delux_control', function ($scope, $state, $http, $location,$filter,$stateParams,$timeout,URL) {
	
	var del_con = this;
	del_con.editDialog = new EditPersonDialogModel();
	del_con.editindex=-1;
	del_con.dbdata={};
	$http.get(URL+"?Query=select *  from MenuMaster where   MenuMasterId<>ParentMenuMasterId and ParentMenuMasterId in (select ParentMenuMasterId From MenuMaster where MenuMasterId="+$stateParams.MenuMasterId+")").then(function (response) 
	{
	        del_con.menulist= response.data.listdata;
			if($stateParams.MenuMasterId==100)
			{
			del_con.addbutton=false;
			del_con.editbutton=true;
			del_con.deletebutton=true;
			}
			else
			{
			del_con.addbutton=true;
			del_con.editbutton=true;
			del_con.deletebutton=true;
			}
       });
	   $http.get(URL+"?Query=select *  from MenuMaster where  MenuMasterId="+$stateParams.MenuMasterId).then(function (response) {
			
            del_con.selmenu= response.data.listdata[0];
			if(del_con.selmenu.Query!="")
			{
				del_con.loadReport();
			}
			if(del_con.selmenu.FormMasterId!=""  &&  del_con.selmenu.FormMasterId !=null)
			{
			del_con.loadForm();
			}
       });
	del_con.loadForm=function ()
	 {
		$http.get(URL+'?Query= select * FROM FormMaster  where FormMasterid='+ del_con.selmenu.FormMasterId).then(function (response) {
			
           del_con.FormMaster = response.data.listdata[0];
		   if(del_con.FormMaster!=undefined)
		   {
				$http.get(URL+'?Query= select * FROM TableMaster  where TableMasterId='+ del_con.FormMaster.TableMasterId).then(function (response) {
				del_con.TableMaster= response.data.listdata[0];
				});
				$http.get(URL+'?Query= call  getFormFields('+del_con.FormMaster.TableMasterId+')').then(function (response) {
				del_con.formFields=response.data.listdata;
				});
			}
		});
		
		
	 }
	 del_con.loadReport=function ()
	 {
		 var  Query=del_con.selmenu.Query;
		 if($stateParams.UniqueId>0)
			Query=Query.replace("{{UniqueId}}",$stateParams.UniqueId) 
			$http.get(URL+'?Query='+ Query).then(function (response) {
           del_con.listdata = response.data.listdata;
		   if(del_con.selmenu.ReportMasterId>0 )
		   {
		    var  Query="Select * FROM ReportControlMaster  where ReportMasterId="+del_con.selmenu.ReportMasterId;
				$http.get(URL+'?Query='+ Query).then(function (response) {
					var  fieldList={};
					for(var index=0;index<response.data.listdata.length;index++)
					{
						
						var  tempObject={
							Caption:response.data.listdata[index]['Caption'],
							Visible:response.data.listdata[index]['Visible']
						};
						fieldList[response.data.listdata[index]['FieldName']]=tempObject;
					}
				del_con.TableStruct =fieldList ;
				
				});
		  
			}
       });
	 }
	 del_con.addmode=function ()
	 { 	
		del_con.dbdata[del_con.TableMaster.TableName]={}; 
			del_con.editDialog.open2();
	 }
	 del_con.editmode=function (object,index)
	 { if(del_con.TableMaster==null ||del_con.TableMaster==undefined  )
		 {
		 $timeout(function() { $state.go('deluxform',{MenuMasterId:object["MenuMasterId"].toString(),UniqueId:object["TranId"].toString()}); }); 
		 
			  
		 }
		 else
			{
		 var MainObject={PrimaryValue:object[del_con.TableMaster.MasterKey],PrimaryKey:del_con.TableMaster.MasterKey,TableNames:{TableName:del_con.TableMaster.TableName}};
			  $http.get(URL+'?getObject=' +angular.toJson( MainObject)).then(function (response) {
             del_con.dbdata[del_con.TableMaster.TableName]= response.data; 
			del_con.editDialog.open();
			del_con.index=index;
			 
        });
			}
	 }
	  del_con.InsertUpdate=function ()
	 {
		 $http.post(URL,del_con.dbdata).then(function (response) {
            del_con.msg = response.data.message;
            del_con.alert_class = 'custom-alert';
			 del_con.editDialog.close();
           if(del_con.dbdata[del_con.TableMaster.TableName][del_con.TableMaster.MasterKey]==0 ||del_con.dbdata[del_con.TableMaster.TableName][del_con.TableMaster.MasterKey]==undefined )
		   {
				del_con.dbdata[del_con.TableMaster.TableName]={}; 
		   }
		   else
		   {
			    del_con.dbdata[del_con.TableMaster.TableName]={};
				del_con.editindex=-1;
		   }
			//del_con.loadReport(); 
			var Id=del_con.dbdata[del_con.TableMaster.TableName][del_con.TableMaster.MasterKey];
			if(Id>0)
			{
				$scope.Query=del_con.Query+"  Where "+del_con.TableMaster.MasterKey+"="+Id;
			}
			else if(Id==undefined  ||  Id==0)
			{
				$scope.Query=del_con.Query+" Order by "+del_con.TableMaster.MasterKey+" desc";
				Id=0;
			}
			$http.get(URL+'?Query='+$scope.Query).then(function (response) 
			{
				if(response.data.listdata.length>0  &&  Id >0)
				{
				del_con.Index=del_con.findIndex(del_con.listdata ,del_con.TableMaster.MasterKey ,Id);
					if(del_con.Index>=0)
					{
					del_con.listdata[del_con.Index] =response.data.listdata[0];
					}
				    else
        		    del_con.listdata.push(response.data.listdata[0]);
				}
				else if(Id ==0)
				{ del_con.listdata.push(response.data.listdata[0]);
				}
			
			});
			//
        });
	 }
	  del_con.deletemode=function(object,index)
	 {	var yesno = confirm('Are you sure remove Record?');
		if (yesno == true)
			{
				if(del_con.TableMaster==null ||del_con.TableMaster==undefined  )
					{
						var MainObject={PrimaryValue:object['TranId'],PrimaryKey:'TranId',TableNames:[{TableName:'TranDetails'},{TableName:'TranFin'},{TableName:'Tran'}]};
						$http.get(URL+'?deleteObject=' +angular.toJson(MainObject)).then(function (response) {
						del_con.msg = response.data.message;
						del_con.alert_class = 'custom-alert';
						del_con.loadReport()
						});
					}
					else
					{
						$http.get(URL+'?deleteObject1='+del_con.TableMaster.TableName+'&PrimaryKey='+del_con.TableMaster.MasterKey+'&PrimaryValue='+object[del_con.TableMaster.MasterKey]).then(function (response) 
						{
						del_con.msg = response.data.message;
						del_con.alert_class = 'custom-alert';
						del_con.Index=del_con.findIndex(del_con.listdata ,del_con.TableMaster.MasterKey,object[ del_con.TableMaster.MasterKey]);
						if(del_con.Index>=0)
						del_con.listdata.splice(del_con.Index, 1); 
						});
					}
			}
	 }
	del_con.doubleclick=function (object,index)
		{
			if(del_con.TableMaster==undefined || del_con.TableMaster.MasterKey==null)
			{
				var	TranId=object["TranId"];
				var MenuMasterId=object["MenuMasterId"];
				$timeout(function() { 
				$state.go('TranForm',{MenuMasterId:MenuMasterId,UniqueId:TranId}); 
				});
			}
			else
			{
				var	UniqueId=object[del_con.TableMaster.MasterKey];
				var NextMenuMasterId=del_con.selmenu.VoucherTypeId;
				$timeout(function() { 
				$state.go('ReportDetail',{MenuMasterId:NextMenuMasterId,UniqueId:UniqueId}); 
					}); 
			}
	 }
	 del_con.findIndex=function (arraydata,PrimaryKey,PrimaryKeyValue)
		{
			var index=-1;
			var ans=-1;
			angular.forEach(arraydata,function(object)
			{
				index++;
				if(object[PrimaryKey].toString()==PrimaryKeyValue.toString())
					ans=index;
			});
			  
		return ans;
		}

});
