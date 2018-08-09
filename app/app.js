var myApp = angular.module('example_codeenable', ['ui.router', 'ui.bootstrap']);

myApp.config(function ($stateProvider, $locationProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');
	
	
	$stateProvider
            .state('/s1', {
                url: '/s1',
                templateUrl: 'templates/student.html',
                controller: 'student_contrloer',
                controllerAs: "std_ctrl",
              
                resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "ANGULARJS CODEGINITER MySQL CRUD";
                        }]
                }

            })
    $stateProvider
            .state('/account', {
                url: '/account',
                templateUrl: 'templates/accountmaster1.html',
                controller: 'account_control',
                 controllerAs: "acc_con",
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "ANGULARJS CODEGINITER MySQL CRUD";
                        }]
                }

            })
			
			 $stateProvider
            .state('/item', {
                url: '/item',
                templateUrl: 'templates/item1.html',
				 controller: 'item_control',
                 controllerAs: "item_con",
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "ANGULARJS CODEGINITER MySQL CRUD";
                        }]
                }

            })
			 $stateProvider
            .state('/', {
                url: '/',
                templateUrl: 'templates/transcation.html',
				controller: 'tran_control',
				
                  controllerAs: "tran_con"

            })
			 $stateProvider
            .state('/transcation', {
                url: '/transcation',
                templateUrl: 'templates/transcation.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con"
                

            })
			 $stateProvider
            .state('sales', {
                url: '/sales/:TranId',
                templateUrl: 'templates/sales1.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con"
                

            })
			$stateProvider
            .state('salesprint', {
                url: '/salesprint/:TranId',
                templateUrl: 'templates/salesprint1.html',
				 controller: 'tran_control',
				  controllerAs: "tran_con"
                

            })
			$stateProvider
            .state('/student', {
                url: '/student',
                templateUrl: 'templates/student.html',
                controller: 'student_contrloer',
                controllerAs: "std_ctrl",
              
                resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "ANGULARJS CODEGINITER MySQL CRUD";
                        }]
                }

            })
            
    $locationProvider.html5Mode({
        enabled: true,
        requireBase: false
    });




});

