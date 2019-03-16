
var myApp = angular.module('DeluxSystem', ['ui.router', 'ui.bootstrap','masterMind']);

myApp.constant('Version','1.0.0.3');
myApp.config(function ($stateProvider, $locationProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');
	 $stateProvider
            .state('/', {
                url: '/',
                templateUrl: 'templates/tran/transcation.html',
				controller: 'tran_control',
				
                  controllerAs: "tran_con",
				  resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Transcation";
                        }]
                }

            })
			
			$stateProvider
            .state('deluxstate', {
                url: '/deluxstate/:ParentMenuMasterId/:MenuMasterId',
                templateUrl: 'delux/control/DeluxTemplate.html',
				 controller: 'delux_control',
				  controllerAs: "del_con",
				  
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Delux System";
                        }]
                }

            })
			
			$stateProvider
            .state('deluxform', {
                url: '/deluxform/:VoucherTypeId/:TranId',
                templateUrl: 'delux/control/DeluxForm.html',
				 controller: 'DeluxForm',
				  controllerAs: "tran_con",
				  
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Delux System";
                        }]
                }

            })
			
			 $stateProvider
            .state('master', {
                url: '/master',
                templateUrl: 'templates/control/master.html',
				controller: 'master_control',
				
                  controllerAs: "mas_con",
				  resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Master";
                        }]
                }

            })
			
			$stateProvider
            .state('delux', {
                url: '/delux/:masterId',
                templateUrl: 'templates/control/master.html',
				controller: 'master_control',
				
                  controllerAs: "mas_con",
				  resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Master";
                        }]
                }

            })
			
			 $stateProvider
			.state('master.account', {
            url: '/account',
              templateUrl: 'templates/master/accountmaster.html',
		  controller: 'account_control',
             controllerAs: "acc_con"
        })
		$stateProvider
			.state('master.item', {
            url: '/item',
              
		   templateUrl: 'templates/master/item.html',
				 controller: 'item_control',
                 controllerAs: "item_con"
        })
		
			$stateProvider
            .state('/backup', {
                url: '/backup',
                templateUrl: 'templates/backup.html',
				controller: 'backup_control',
				
                  controllerAs: "back_con",
				  resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "backup";
                        }]
                }

            })
	
	
   
			
			
	
			
			 $stateProvider
            .state('/transcation', {
                url: '/transcation',
                templateUrl: 'templates/tran/transcation.html',
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
                templateUrl: 'templates/tran/Inventory.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con",
				  
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Inventory";
                        }]
                }

            })
			 $stateProvider
            .state('Tran', {
                url: '/Tran/:VoucherTypeId/:TranId',
                templateUrl: 'templates/control/TranDyamic.html',
				 controller: 'TranDyamic_Control',
				  controllerAs: "tran_con",
				  
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Dyamic Form";
                        }]
                }

            })
			 $stateProvider
            .state('cash', {
                url: '/cash/:VoucherTypeId/:TranId',
                templateUrl: 'templates/tran/cash.html',
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
                templateUrl: 'templates/tran/bank.html',
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
                templateUrl: 'templates/tran/jv.html',
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
                templateUrl: 'templates/tran/salesprint.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "InventaryView";
                        }]
                }
                

            })
			$stateProvider
            .state('CashPrint', {
                url: '/CashPrint/:TranId',
                templateUrl: 'templates/tran/cashprint.html',
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
                templateUrl: 'templates/master/itemdetails.html',
				 controller: 'itemdetailsControl',
				  controllerAs: "itemdet_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Item Details";
                        }]
                }
                

            })
			
			$stateProvider
			.state('master.itemdetails', {
            url: '/itemdetails/:ItemMasterId',
              
		   templateUrl: 'templates/master/itemdetails.html',
				 controller: 'itemdetailsControl',
                 controllerAs: "itemdet_con"
        })
			
			$stateProvider
			.state('master.accountdetails', {
            url: '/accountdetails/:AccountMasterId',
              
		   templateUrl: 'templates/master/accountdetails.html',
				 controller: 'accountdetailsControl',
                 controllerAs: "accdet_con"
        })
			
			$stateProvider
            .state('accountdetails', {
                url: '/accountdetails/:AccountMasterId',
                templateUrl: 'templates/master/accountdetails.html',
				 controller: 'accountdetailsControl',
				  controllerAs: "accdet_con",
				   resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Account Details";
                        }]
                }
                

            })
			
			$stateProvider
            .state('/Report', {
                url: '/Report',
                templateUrl: 'templates/report/Report.html',
				controller: 'report_control',
				
                  controllerAs: "rpt_con",
				  resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Report";
                        }]
                }

            })
			
			 $stateProvider
			.state('/Report.account', {
            url: '/Report',
              templateUrl: 'templates/master/accountmaster.html',
		  controller: 'account_control',
             controllerAs: "acc_con"
        })
			
    $locationProvider.html5Mode({
        enabled: true,
        requireBase: false
    });




});



