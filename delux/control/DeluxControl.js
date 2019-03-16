myApp.controller('delux_control', function ($scope, $state, $http, $location,$filter,$stateParams,$timeout,URL) {
	
	var del_con = this;
del_con.editDialog = new EditPersonDialogModel();
	  
	  del_con.editindex=-1;
	    del_con.dbdata={};
	
	  $http.get(URL+"?Query=select *  from MenuMaster where   MenuMasterId<>ParentMenuMasterId and ParentMenuMasterId in (select ParentMenuMasterId From MenuMaster where MenuMasterId="+$stateParams.MenuMasterId+")").then(function (response) {
			
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
		
			$http.get(URL+'?Query= select * FROM TableMaster  where TableMasterId='+ del_con.FormMaster.TableMasterId).then(function (response) {
				
				del_con.TableMaster= response.data.listdata[0];
				
				
			});
        	/*				 $http.get('json/'+del_con.FormMaster.jsonFileName).then(function (response) {
		
           del_con.formFields = $scope.$eval( response.data);
			console.log( $scope.$eval( response.data));
				});
				*/
				
			$http.get(URL+'?Query= call  getFormFields('+del_con.FormMaster.TableMasterId+')').then(function (response) {
				
				del_con.formFields=response.data.listdata;
				console.log(del_con.formFields);
			});
	   
		});
		 
	 }
	 

	  
	 del_con.loadReport=function ()
	 {
		 
		 var  Query=del_con.selmenu.Query;
		 if($stateParams.UniqueId>0)
			Query=Query.replace("{{UniqueId}}",$stateParams.UniqueId) 
		$http.get(URL+'?Query='+ Query).then(function (response) {
		
           del_con.listdata = response.data.listdata;
		
		 
        		
			
       });
	 }
	 
	 
	 
	 del_con.addmode=function ()
	 { 	
	 
	del_con.dbdata[del_con.TableMaster.TableName]={}; 
			del_con.editDialog.open();
			
			
	 }
	  
	 del_con.editmode=function (object,index)
	 {
	
		 
		 if(del_con.TableMaster==null ||del_con.TableMaster==undefined  )
		 {
		
				  $timeout(function() { $state.go('deluxform',{VoucherTypeId:object["VoucherTypeId"].toString(),TranId:object["TranId"].toString()}); }); 
			  
			
		
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
			del_con.loadReport(); //vishal:Load Remove  in Refresh code here
			
            
        });
		 
		  
	 }
	 
	  del_con.deletemode=function(object,index)
	 {
		  
		  
		     var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
				$http.get(URL+'?deleteObject2='+del_con.TableMaster.TableName+'&PrimaryKey='+del_con.TableMaster.MasterKey+'&PrimaryValue='+object[del_con.TableMaster.MasterKey]).then(function (response) {
            del_con.msg = response.data.message;
            del_con.alert_class = 'custom-alert';
           del_con.loadReport(); //vishal:Load Remove  in row Remove Code here
		  
        });
				}
	 }
	 
	 
	  del_con.doubleclick=function (object,index)
	 {
	
	var	UniqueId=object[del_con.TableMaster.MasterKey];
	var NextMenuMasterId=del_con.selmenu.VoucherTypeId;
		 console.log(NextMenuMasterId);
  $timeout(function() { 
  $state.go('deluxstate',{MenuMasterId:NextMenuMasterId,UniqueId:UniqueId}); 
  }); 
		
		  
		  
		   

	 }
	 
	 

	});myApp.controller('delux_control', function ($scope, $state, $http, $location,$filter,$stateParams,$timeout,URL) {
	
	var del_con = this;
del_con.editDialog = new EditPersonDialogModel();
	  
	  del_con.editindex=-1;
	    del_con.dbdata={};
	
	  $http.get(URL+"?Query=select *  from MenuMaster where   MenuMasterId<>ParentMenuMasterId and ParentMenuMasterId in (select ParentMenuMasterId From MenuMaster where MenuMasterId="+$stateParams.MenuMasterId+")").then(function (response) {
			
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
		
			$http.get(URL+'?Query= select * FROM TableMaster  where TableMasterId='+ del_con.FormMaster.TableMasterId).then(function (response) {
				
				del_con.TableMaster= response.data.listdata[0];
				
				
			});
        	/*				 $http.get('json/'+del_con.FormMaster.jsonFileName).then(function (response) {
		
           del_con.formFields = $scope.$eval( response.data);
			console.log( $scope.$eval( response.data));
				});
				*/
				
			$http.get(URL+'?Query= call  getFormFields('+del_con.FormMaster.TableMasterId+')').then(function (response) {
				
				del_con.formFields=response.data.listdata;
				console.log(del_con.formFields);
			});
	   
		});
		 
	 }
	 

	  
	 del_con.loadReport=function ()
	 {
		 
		 var  Query=del_con.selmenu.Query;
		 if($stateParams.UniqueId>0)
			Query=Query.replace("{{UniqueId}}",$stateParams.UniqueId) 
		$http.get(URL+'?Query='+ Query).then(function (response) {
		
           del_con.listdata = response.data.listdata;
		
		 
        		
			
       });
	 }
	 
	 
	 
	 del_con.addmode=function ()
	 { 	
	 
	del_con.dbdata[del_con.TableMaster.TableName]={}; 
			del_con.editDialog.open();
			
			
	 }
	  
	 del_con.editmode=function (object,index)
	 {
	
		 
		 if(del_con.TableMaster==null ||del_con.TableMaster==undefined  )
		 {
		
				  $timeout(function() { $state.go('deluxform',{VoucherTypeId:object["VoucherTypeId"].toString(),TranId:object["TranId"].toString()}); }); 
			  
			
		
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
			del_con.loadReport(); //vishal:Load Remove  in Refresh code here
			
            
        });
		 
		  
	 }
	 
	  del_con.deletemode=function(object,index)
	 {
		  
		  
		     var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
				$http.get(URL+'?deleteObject2='+del_con.TableMaster.TableName+'&PrimaryKey='+del_con.TableMaster.MasterKey+'&PrimaryValue='+object[del_con.TableMaster.MasterKey]).then(function (response) {
            del_con.msg = response.data.message;
            del_con.alert_class = 'custom-alert';
           del_con.loadReport(); //vishal:Load Remove  in row Remove Code here
		  
        });
				}
	 }
	 
	 
	  del_con.doubleclick=function (object,index)
	 {
	
	var	UniqueId=object[del_con.TableMaster.MasterKey];
	var NextMenuMasterId=del_con.selmenu.VoucherTypeId;
		 console.log(NextMenuMasterId);
  $timeout(function() { 
  $state.go('deluxstate',{MenuMasterId:NextMenuMasterId,UniqueId:UniqueId}); 
  }); 
		
		  
		  
		   

	 }
	 
	 

	});
