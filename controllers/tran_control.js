//Reference File app.js
 /*
 myApp.directive('datepicker', function () {

        return function(scope,element,attrs)
        {
            element.datepicker({
                inline: true,
                format:'mm-dd-yyyy',
                onSelect :function(dateText)
                {
					
                    var modelPath = $(this).attr('ng-model');
                    scope.$apply();
                }
            
            });

        }
    });
	*/
	
myApp.controller('tran_control', function ($scope, $state, $http, $location,$stateParams) {
    var vm = this;
  
    $scope.ModelButton="Add";
    $scope.currentPage = 1;
    $scope.maxSize = 3;
	vm.TempTrandetails = {};
     vm.tran = {};
	 vm.tran.TranId=$stateParams.TranId;
	 vm.tran.TranDetailsIds="";
	  vm.tran.BillDate=new Date();
	 
	 //ItemMasterId
	 
	 
        $http.get('php/item/select.php' ).then(function (response) {
		
           $scope.ItemNames = response.data.item_list;
		
            
		
			
       });
	   
	   //ItemNames
	   $http.get('php/accountmaster/select.php' ).then(function (response) {
		
           $scope.AccountMasters = response.data.account_list;
		
            
		
			
       });
	   
	   this.AddDirectRecord=function (TransactionDetails) 
	   {
		    $scope.ModelButton = "Add";
               vm.TempTrandetails = {};
			   vm.TempTrandetails.Srno = 0;
		       vm.TempTrandetails.TranDetailsId=0;
               vm.TempTrandetails.ItemMaster = angular.copy(TransactionDetails.ItemMaster);
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
            //pushRecord
            this.PushRecord = function () {
				
				vm.TempTrandetails.Quntity=vm.countdata(vm.TempTrandetails.Height)*vm.countdata(vm.TempTrandetails.Length);
				vm.TempTrandetails.TotalQuntity=vm.countdata(vm.TempTrandetails.Height)*vm.countdata(vm.TempTrandetails.Length)*vm.TempTrandetails.Nos;
				vm.TempTrandetails.Amount=vm.countdata(vm.TempTrandetails.Height)*vm.countdata(vm.TempTrandetails.Length)*vm.TempTrandetails.Nos*vm.TempTrandetails.Rate;
				
				
				
				                if (vm.TempTrandetails.Srno == 0) {
									
                    if ( vm.tran.trandetails == null)
                        vm.tran.trandetails = [];
					 vm.TempTrandetails.TranDetailsId=0;
                     vm.TempTrandetails.Srno = vm.tran.trandetails.length + 1;
                    vm.tran.trandetails.push(vm.TempTrandetails);
                }
                else {
					
					
                   vm.tran.trandetails[vm.TempTrandetails.Srno - 1] = vm.TempTrandetails;
               }
			   vm.Total();

            }
            //DeleteRecord
            this.DeleteRecord = function (index) {
					if( vm.tran.trandetails[index].TranDetailsId>0)
					{
							if(vm.tran.TranDetailsIds=="")
							vm.tran.TranDetailsIds=vm.tran.trandetails[index].TranDetailsId;
								else
									vm.tran.TranDetailsIds=vm.tran.TranDetailsIds+","+vm.tran.trandetails[index].TranDetailsId;
					}
                 vm.tran.trandetails.splice(index, 1);
                for (; index <  vm.tran.trandetails.length; index++) {
                     vm.tran.trandetails[index].Srno = index + 1;
                }
                 vm.Total();
            }
			this.SelectAccount = function () {
				
				if(vm.TempTrandetails.TranDetailsId==0 ||  vm.TempTrandetails.Rate==0  || vm.TempTrandetails.Rate==undefined )
                vm.TempTrandetails.Rate =vm.TempTrandetails.ItemMaster.SaleRate;
            }
			
			
			
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


                for (var index = 0; index < vm.tran.trandetails.length; index++)
                    total = total + parseFloat(vm.tran.trandetails[index].Amount);
				vm.tran.Total=total;
                

            }
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
			
this.getTotal=function(indexend,key)
{
	var sum=0
	var ItemMasterId=vm.tran.trandetails[indexend].ItemMasterId;
	
for(var index=indexend;index>=0;index--)
	{
		
		if(ItemMasterId==vm.tran.trandetails[index].ItemMasterId)
	sum=sum+parseFloat(vm.tran.trandetails[index][key]);
	else
		break;
	
	}
	
	
	return sum;
}
	/*
	this.getAmount=function(indexend)
{
	var sum=0
	var ItemMasterId=vm.tran.trandetails[indexend].ItemMasterId;
	
for(var index=indexend;index>=0;index--)
	{
		
		if(ItemMasterId==vm.tran.trandetails[index].ItemMasterId)
	sum=sum+parseFloat(vm.tran.trandetails[index].Amount);
	else
		break;
	
	}
	
	
	return sum;
}
	*/
    this.search_data = function (search_input) {
		
        if (search_input.length > 0)
            vm.loadData(1);

    };

    this.loadData = function (page_number) {
		
		
        //var search_input = document.getElementById("search_input").value;
		var object = document.getElementById("search_input");
		var search_input="";
		
		if(object==null)
		{
		
			if(vm.tran.TranId>0)
			vm.GetObject(vm.tran.TranId);
		}
	else
	{
		search_input=object.value;
	
		
        $http.get('php/tran/select.php?page=' + page_number + '&search_input=' + search_input).then(function (response) {
		
            vm.tran_list = response.data.tran_list;
		
            $scope.total_row = response.data.total;
		
			
        });
	}
		
    };
   $scope.funPrint=function()
   {
	  var printContents= document.getElementById("sales");
 var popupWin = window.open('', '_blank', 'width=600,height=600,scrollbars=no,menubar=no,toolbar=no,location=no,status=no,titlebar=no');
 popupWin.window.focus();
    popupWin.document.write('<!DOCTYPE html><html><head>' +
                       '<link rel="stylesheet" type="text/css" href="style.css" />' +
					    
   

                       '</head><body onload="window.print()"><div class="reward-body"><div style="height:70px"></div>' + printContents.outerHTML + '</div></html>');
			   
	popupWin.print();
	popupWin.close();
   }
    $scope.$watch('currentPage + numPerPage', function () {
		
	
        vm.loadData($scope.currentPage);

        var begin = (($scope.currentPage - 1) * $scope.numPerPage)
                , end = begin + $scope.numPerPage;


    });
//    

    this.addTran = function () {
		
        $http.post('php/tran/insert.php', vm.tran).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("sales_frm").reset();
            //$('#create_tran_info_modal').modal('toggle');
			
			$location.path('transcation');
           // vm.loadData($scope.currentPage);

        });
    };

    this.GetObject = function (TranId) {
        $http.get('php/tran/selectone.php?TranId=' + TranId).then(function (response) {
            vm.tran = response.data;
			 vm.tran.BillDate=new Date(vm.tran.BillDate);
			 vm.tran.TranDetailsIds="";
			 vm.rowsdata=[];
			 
			 for(i=vm.tran.trandetails.length+1;i<=25;i++)
			 {
				   vm.rowsdata.push(i);
			 }
        });
    };






    this.deleteObject = function (TranId) {
		                    var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
        $http.post('php/tran/delete.php?TranId=' + TranId).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.loadData($scope.currentPage);
        });
				}
    };


});


