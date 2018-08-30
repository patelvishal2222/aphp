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


//<button export-to-csv details=tran_con.tran_list >Download</button>
myApp.directive('exportToCsv',function(){
  	return {
    	restrict: 'A',
    	link: function (scope, element, attrs) {
    		var el = element[0];
			if(attrs.details){
				scope.details = attrs.details;
                //scope.details = scope.$eval(attrs.details);
				console.log(scope.details);
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
	        			csvString = csvString + data+ ",";
							
	        		}
					csvString = csvString.substring(0,csvString.length - 1);
	        		csvString = csvString + "\n";
				}
						for (data in rowData) 
					{
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


