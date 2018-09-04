var myApp = angular.module('example_codeenable', ['ui.router', 'ui.bootstrap']);

myApp.config(function ($stateProvider, $locationProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');
	
	
    $stateProvider
            .state('account', {
                url: '/account',
                templateUrl: 'templates/accountmaster.html',
                controller: 'account_control',
                 controllerAs: "acc_con",
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Account ";
                        }]
                }

            })
			
			 $stateProvider
            .state('/item', {
                url: '/item',
                templateUrl: 'templates/item.html',
				 controller: 'item_control',
                 controllerAs: "item_con",
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Item";
                        }]
                }

            })
			 $stateProvider
            .state('/', {
                url: '/',
                templateUrl: 'templates/transcation.html',
				controller: 'tran_control',
				
                  controllerAs: "tran_con",
				  resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Transcation";
                        }]
                }

            })
			 $stateProvider
            .state('/transcation', {
                url: '/transcation',
                templateUrl: 'templates/transcation.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con",
				  resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Transcation";
                        }]
                }
                

            })
			 $stateProvider
            .state('sales', {
                url: '/sales/:VoucherTypeId/:TranId',
                templateUrl: 'templates/Inventory.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con",
				  
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Inventory";
                        }]
                }

            })
			 $stateProvider
            .state('cash', {
                url: '/cash/:VoucherTypeId/:TranId',
                templateUrl: 'templates/cash.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Item";
                        }]
                }
                

            })
			$stateProvider
            .state('bank', {
                url: '/bank/:VoucherTypeId/:TranId',
                templateUrl: 'templates/bank.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "bank";
                        }]
                }
                

            })
			$stateProvider
            .state('jv', {
                url: '/sales/:VoucherTypeId/:TranId',
                templateUrl: 'templates/jv.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Journal Voucher";
                        }]
                }
                

            })
			$stateProvider
            .state('salesprint', {
                url: '/salesprint/:TranId',
                templateUrl: 'templates/salesprint.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "InventaryView";
                        }]
                }
                

            })
			
            $stateProvider
            .state('itemdetails', {
                url: '/itemdetails/:ItemMasterId',
                templateUrl: 'templates/itemdetails.html',
				 controller: 'itemdetailsControl',
				  controllerAs: "itemdet_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Item Details";
                        }]
                }
                

            })
			$stateProvider
            .state('accountdetails', {
                url: '/accountdetails/:AccountMasterId',
                templateUrl: 'templates/accountdetails3.html',
				 controller: 'accountdetailsControl',
				  controllerAs: "accdet_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Account Details";
                        }]
                }
                

            })
    $locationProvider.html5Mode({
        enabled: true,
        requireBase: false
    });




});


//<button export-to-csv details=tran_con.tran_list >Download</button>
myApp.directive('exportToCsv',function(){
  	return {
    	restrict: 'A',
    	link: function (scope, element, attrs) {
    		var el = element[0];
			if(attrs.details){
				scope.details = attrs.details;
                
				
            }
	        element.bind('click', function(e){
				
				
	        	var table = e.target.nextElementSibling;
				 scope.details = scope.$eval(attrs.details);
				
	        	var csvString = '';
	        	for(var i=0; i< scope.details.length;i++){
	        		var rowData =  scope.details[i];
				if(i==0)
				{
	        		for (data in rowData) 
					{
						if(data!='$$hashKey')
	        			csvString = csvString + data+ ",";
							
	        		}
					csvString = csvString.substring(0,csvString.length - 1);
	        		csvString = csvString + "\n";
				}
						for (data in rowData) 
					{
						if(data!='$$hashKey')
	        			csvString = csvString + rowData[data]+ ",";
							
	        		}
	        		csvString = csvString.substring(0,csvString.length - 1);
	        		csvString = csvString + "\n";
			    }
	         	csvString = csvString.substring(0, csvString.length - 1);
	         	var a = $('<a/>', {
		            style:'display:none',
		            href:'data:application/octet-stream;base64,'+btoa(csvString),
		            download:'Export.csv'
		        }).appendTo('body')
		        a[0].click()
		        a.remove();
	        });
    	}
  	}
});
