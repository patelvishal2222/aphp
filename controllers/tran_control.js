
	
myApp.controller('tran_control', function ($scope, $state, $http, $location,$stateParams,$filter) {
    var vm = this;
  
    $scope.ModelButton="Add";
    $scope.currentPage = 1;
    $scope.maxSize = 3;
	vm.TempTrandetails = {};
	vm.dbdata={};
     vm.dbdata.tran = {};
	 vm.dbdata.tran.TranId=$stateParams.TranId;
	 vm.dbdata.tran.VoucherTypeId=$stateParams.VoucherTypeId;
	 vm.dbdata.tran.TranDetailsIds="";
	 vm.dbdata.tran.TranfinIds="";
	 
	  vm.dbdata.tran.BillDate=new Date();
	  
	
	 //ItemNames
        $http.get('php/DyamicOperation.php?Query=select *  from ItemMaster' ).then(function (response) {
           $scope.ItemNames = response.data.listdata;
			
       });
	   
	   //AccountMasters
	   $http.get('php/DyamicOperation.php?Query=select *  from AccountMaster' ).then(function (response) {
           $scope.AccountMasters = response.data.listdata;
			
       });
	   //CrDrMasters
	   $http.get('php/DyamicOperation.php?Query=select *  from CrDrMaster' ).then(function (response) {
           $scope.CrDrMasters = response.data.listdata;
			
       });
	   //Menu
	    $http.get('php/DyamicOperation.php?Query=select *  from vouchertype' ).then(function (response) {
           $scope.menulist = response.data.listdata;
           $scope.selmenu = $filter('filter')( $scope.menulist , {VoucherTypeId: vm.dbdata.tran.VoucherTypeId})[0];
		   if(vm.dbdata.tran.VoucherTypeId>0 )
		   {
			vm.color=$scope.selmenu.Color;
			vm.Title=$scope.selmenu.Name;
			}
			
       });
	      
		 
	  //AddDirectRecord
	   this.AddDirectRecord=function (TransactionDetails) 
	   {
		    $scope.ModelButton = "Add";
               vm.TempTrandetails = {};
			   vm.TempTrandetails.Srno = 0;
		       vm.TempTrandetails.TranDetailsId=0;
               vm.TempTrandetails.VirtualItemMaster = angular.copy(TransactionDetails.VirtualItemMaster);
			   //vm.TempTrandetails.Height=parseFloat(TransactionDetails.Height);
			   //vm.TempTrandetails.Length= parseFloat(TransactionDetails.Length);
			   //vm.TempTrandetails.Nos= parseFloat(TransactionDetails.Nos);
			   vm.TempTrandetails.Rate= parseFloat(TransactionDetails.Rate);
			   
	   }
	 //AddRecord
            this.AddRecord = function () {
				
            $scope.ModelButton = "Add";
            vm.TempTrandetails = {};
            vm.TempTrandetails.Srno = 0;
			vm.TempTrandetails.TranDetailsId=0;
			vm.TempTrandetails.VirtualItemMaster={};
			vm.TempTrandetails.VirtualItemMaster.QuantityTypeId=2;
			


            }
			//AddAccount
			this.AddAccount = function () {
				
            $scope.ModelButton = "Add";
            vm.TempTranFin = {};
            vm.TempTranFin.Srno = 0;
			vm.TempTranFin.TranfinId=0;
			vm.TempTranFin.VirtualCrDrMaster={};
			vm.TempTranFin.VirtualAccountMaster={};
			
				if(vm.dbdata.tran.VoucherTypeId==7  ||vm.dbdata.tran.VoucherTypeId==8)
			vm.TempTranFin.VirtualCrDrMaster=$filter('filter')( $scope.CrDrMasters , {CrDrMasterId: vm.dbdata.tran.VoucherTypeId-6})[0];


            }
            //EditRecord
            this.EditRecord = function (TransactionDetails) {
                $scope.ModelButton = "Edit";
               vm.TempTrandetails = {};
			  
               vm.TempTrandetails = angular.copy(TransactionDetails);
			   vm.TempTrandetails.Height=parseFloat(TransactionDetails.Height);
			   vm.TempTrandetails.Length= parseFloat(TransactionDetails.Length);
			   vm.TempTrandetails.Nos= parseFloat(TransactionDetails.Nos);
			   vm.TempTrandetails.Rate= parseFloat(TransactionDetails.Rate);
			   
			   
               
            }
			 //EditAccount
            this.EditAccount = function (TranFin) {
                $scope.ModelButton = "Edit";
               vm.TempTranFin = {};
			  
               vm.TempTranFin = angular.copy(TranFin);
			   vm.TempTranFin.Amount=parseFloat(TranFin.Amount);
			   
            }
            //pushRecord
            this.PushRecord = function (formIndex) {
				if(vm.TempTrandetails.VirtualItemMaster.QuantityTypeId==2)
				{
				vm.TempTrandetails.Quantity=vm.countdata(vm.TempTrandetails.Height)*vm.countdata(vm.TempTrandetails.Length);
				vm.TempTrandetails.TotalQuantity=vm.countdata(vm.TempTrandetails.Height)*vm.countdata(vm.TempTrandetails.Length)*vm.TempTrandetails.Nos;
				vm.TempTrandetails.Amount=vm.countdata(vm.TempTrandetails.Height)*vm.countdata(vm.TempTrandetails.Length)*vm.TempTrandetails.Nos*vm.TempTrandetails.Rate;
				}
				else if(vm.TempTrandetails.VirtualItemMaster.QuantityTypeId==1)
				{
					vm.TempTrandetails.Amount=vm.TempTrandetails.TotalQuantity*vm.TempTrandetails.Rate;
				}
				else
				{
				}
				
				if(formIndex==1)
					 $('#myModal').modal('toggle');
					else
					$('#myModalDirect').modal('toggle');
				
				                if (vm.TempTrandetails.Srno == 0) {
									
                    if ( vm.dbdata.tran.trandetails == null)
                        vm.dbdata.tran.trandetails = [];
					 vm.TempTrandetails.TranDetailsId=0;
                     vm.TempTrandetails.Srno = vm.dbdata.tran.trandetails.length + 1;
                    vm.dbdata.tran.trandetails.push(vm.TempTrandetails);
                }
                else {
					
					
                   vm.dbdata.tran.trandetails[vm.TempTrandetails.Srno - 1] = vm.TempTrandetails;
               }
			   vm.Total();

            }
			//PushAccount
			this.PushAccount = function () {
				
				
				
					 $('#myModal').modal('toggle');
				
				
				                if (vm.TempTranFin.Srno == 0) {
									
                    if ( vm.dbdata.tran.tranfin == null)
                        vm.dbdata.tran.tranfin = [];
					 vm.TempTranFin.TranfinId=0;
                     vm.TempTranFin.Srno = vm.dbdata.tran.tranfin.length + 1;
                    vm.dbdata.tran.tranfin.push(vm.TempTranFin);
                }
                else {
					
					
                   vm.dbdata.tran.tranfin[vm.TempTranFin.Srno - 1] = vm.TempTranFin;
               }
			   
			 vm.dbdata.tran.Total= vm.TotalAccount( vm.dbdata.tran.tranfin,"Amount");

            }
			
			
			this.TotalAccount=function(datalist,key)
			{
				var total = 0;


                for (var index = 0; index < datalist.length; index++)
                    total = total + parseFloat(datalist[index][key]);
				return total;
                
			}
            //DeleteRecord
            this.DeleteRecord = function (index) {
					if( vm.dbdata.tran.trandetails[index].TranDetailsId>0)
					{
							if(vm.dbdata.tran.TranDetailsIds=="")
							vm.dbdata.tran.TranDetailsIds=vm.dbdata.tran.trandetails[index].TranDetailsId;
								else
									vm.dbdata.tran.TranDetailsIds=vm.dbdata.tran.TranDetailsIds+","+vm.dbdata.tran.trandetails[index].TranDetailsId;
					}
                 vm.dbdata.tran.trandetails.splice(index, 1);
                for (; index <  vm.dbdata.tran.trandetails.length; index++) {
                     vm.dbdata.tran.trandetails[index].Srno = index + 1;
                }
                 vm.Total();
            }
			//DeleteAccount
			this.DeleteAccount = function (index) {
				
					if( vm.dbdata.tran.tranfin[index].TranfinId>0)
					{
						
							if(vm.dbdata.tran.TranfinIds=="" || vm.dbdata.tran.TranfinIds==undefined)
							vm.dbdata.tran.TranfinIds=vm.dbdata.tran.tranfin[index].TranfinId;
								else
									vm.dbdata.tran.TranfinIds=vm.dbdata.tran.TranfinIds+","+vm.dbdata.tran.tranfin[index].TranfinId;
								
						
					}
					
                 vm.dbdata.tran.tranfin.splice(index, 1);
                for (; index <  vm.dbdata.tran.tranfin.length; index++) {
                     vm.dbdata.tran.tranfin[index].Srno = index + 1;
                }
                 vm.dbdata.tran.Total= vm.TotalAccount( vm.dbdata.tran.tranfin,"Amount");
            }
			//Select Item Rate
			this.SelectAccount = function () {
				vm.TempTrandetails.VirtualItemMaster.QuantityTypeId=parseInt(vm.TempTrandetails.VirtualItemMaster.QuantityTypeId);
				
				if(vm.TempTrandetails.TranDetailsId==0 ||  vm.TempTrandetails.Rate==0  || vm.TempTrandetails.Rate==undefined )
				{
					if(vm.dbdata.tran.VoucherTypeId==1  ||vm.dbdata.tran.VoucherTypeId==3)
						vm.TempTrandetails.Rate =vm.TempTrandetails.VirtualItemMaster.PurRate;
						else if(vm.dbdata.tran.VoucherTypeId==2  ||vm.dbdata.tran.VoucherTypeId==4)
                vm.TempTrandetails.Rate =vm.TempTrandetails.VirtualItemMaster.SaleRate;
				}
            }
			
			//print
			 this.Print = function (divName) {

               var printContents = document.getElementById(divName).innerHTML;
               var originalContents = document.body.innerHTML;

               if (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) {
                   var popupWin = window.open('', '_blank', 'width=600,height=600,scrollbars=no,menubar=no,toolbar=no,location=no,status=no,titlebar=no');
                   popupWin.window.focus();
                   popupWin.document.write('<!DOCTYPE html><html><head>' +
                       '<link rel="stylesheet" type="text/css" href="style.css" />' +
                       '</head><body onload="window.print()"><div class="reward-body">' + printContents + '</div></html>');
                   popupWin.onbeforeunload = function (event) {
                       popupWin.close();
                       return '.\n';
                   };
                   popupWin.onabort = function (event) {
                       popupWin.document.close();
                       popupWin.close();
                   }
               } else {
                   var popupWin = window.open('', '_blank', 'width=800,height=600');
                   popupWin.document.open();
                   popupWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="style.css" /></head><body onload="window.print()">' + printContents + '</html>');
                   popupWin.document.close();
               }
               popupWin.document.close();

               return true;
           }
			 //Total
           this.Total = function () {

                var total = 0;


                for (var index = 0; index < vm.dbdata.tran.trandetails.length; index++)
                    total = total + parseFloat(vm.dbdata.tran.trandetails[index].Amount);
				vm.dbdata.tran.Total=total;
                

            }
			
			
			//addAccount
			   this.addAccount = function (tempAccountMaster) {
        $http.post('php/accountmaster/insert.php', tempAccountMaster).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("create_account_info_frm").reset();
            $('#create_account_info_modal').modal('toggle');
           $http.get('php/accountmaster/select.php?page=0&search_input=' ).then(function (response) {
		
           $scope.AccountMasters = response.data.account_list;
		
       vm.dbdata.tran.AccountMaster= $scope.AccountMasters[ $scope.AccountMasters.length-1];        
		
			
       });
	   
        });
			};
			
			//countdata
			this.countdata =function (a) 
			{
				
				b=0;
				if(a%3==0)
				{
				b=a/12;
				}
				else
				{
					b=3-(a%3);
					b=((a+b)/12);
					
				}
				
				return b;
				
			}
			//getTotal
			this.getTotal=function(indexend,key)
				{
			var sum=0
			var ItemMasterId=vm.dbdata.tran.trandetails[indexend].ItemMasterId;
			for(var index=indexend;index>=0;index--)
				{
				if(ItemMasterId==vm.dbdata.tran.trandetails[index].ItemMasterId)
				sum=sum+parseFloat(vm.dbdata.tran.trandetails[index][key]);
				else
				break;
				}
			return sum;
			}
	//search_data
		this.search_data = function (search_input) {
        if (search_input.length >=0)
            vm.loadData(1);

			};
		//loadData
    this.loadData = function (page_number) {
		var object = document.getElementById("search_input");
		var search_input="";
		if(object==null)
		{
			if(vm.dbdata.tran.TranId>=0)
			vm.GetObject(vm.dbdata.tran.TranId);
		}
	else
	{
		search_input=object.value;
		
        $http.get(encodeURI("php/DyamicOperation.php?List=1&Sql=SELECT * FROM vwTranscation &TableName=vwTranscation&Page="+page_number+"&PageSize=10&OrderBy=TranId   desc&Search=AccountName like '%"+search_input+"%'")).then(function (response) {
            vm.tran_list = response.data.listdata;
            $scope.total_row = response.data.total;
			
        });
	}
		
    };
		//funPrint
   $scope.funPrint=function()
   {
	  var printContents= document.getElementById("sales");
 var popupWin = window.open('', '_blank', 'width=600,height=600,scrollbars=no,menubar=no,toolbar=no,location=no,status=no,titlebar=no');
 popupWin.window.focus();
    popupWin.document.write('<!DOCTYPE html><html><head>' +
                       '<link rel="stylesheet" type="text/css" href="style.css" />' +
					    
   

                       '</head><body onload="window.print()"><div class="reward-body"><div style="height:0px"></div>' + printContents.outerHTML + '</div></html>');
			   
	popupWin.print();
	popupWin.close();
   }
    $scope.$watch('currentPage + numPerPage', function () {
		
	
        vm.loadData($scope.currentPage);

        var begin = (($scope.currentPage - 1) * $scope.numPerPage)
                , end = begin + $scope.numPerPage;


    });
//    addTran & InsertUpdate

    this.addTran = function () {
		//$http.post('php/DyamicOperation.php', vm.dbdata).then(function (response) {
       // $http.post('php/tran/insert.php', vm.dbdata.tran).then(function (response) {
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
			 vm.dbdata.tran.BillDate=new Date(vm.dbdata.tran.BillDate);
			 vm.dbdata.tran.TranDetailsIds="";
			  vm.dbdata.tran.TranfinIds="";
			 vm.rowsdata=[];
			 if ( vm.dbdata.tran.trandetails == null)
               vm.dbdata.tran.trandetails = [];
			 for(i=vm.dbdata.tran.trandetails.length+1;i<=25;i++)
			 {
				   vm.rowsdata.push(i);
			 }
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

