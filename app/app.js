var myApp = angular.module('example_codeenable', ['ui.router', 'ui.bootstrap','angularjs-dropdown-multiselect']);

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

myApp.directive('myCustomer', function() {
  return {
    restrict: 'EA',
	  transclude: true,
    scope: {
      listdata: '=listdata',
	  deleteevent:'&deleteevent',
	  editevent:'&',
	  viewevent:'&'
	
    },
	 
	link: function (scope, element, attrs) {
		
		scope.sorting=function(data)
		{
		//scope.orderdata=data;
			
		}

		scope.$watch('listdata', function(newVal,oldVal){
   
	  scope.listdata=newVal;
      });
	 
	
   
  scope.rowIndex = -1;
		scope.selectRow = function(index){
			
			 if(index == scope.rowIndex)
        scope.rowIndex = -1;
        else
          scope.rowIndex = index;
		}
		
		scope.deletedata=function(object,index){
		  
		  scope.deleteevent({object: object,index:index});
	}
		
	
	scope.editdata=function(object,index){
		  scope.editevent({object: object,index:index});
		
	}
	scope.viewdata=function(object,index){
		
		  scope.viewevent({object: object,index:index});
	}
	
		
		 scope.clicked = '';
  scope.ShowContextMenu = function(){
    alert('hello');
  };
  scope.edit = function() {
    scope.clicked = 'edit was clicked';
    console.log(scope.clicked);
  };
  
  scope.properties = function() {
    scope.clicked = 'properties was clicked';
    console.log(scope.clicked);
  };
  
  scope.link = function() {
    scope.clicked = 'link was clicked';
    console.log(scope.clicked);
  };
  
  scope.delete = function() {
    scope.clicked = 'delete was clicked';
    console.log(scope.clicked);
  };
		
		
	},
    templateUrl: 'templates/table.html'
  };
});




 myApp.directive('cellHighlight', function() {
    return {
      restrict: 'C',
      link: function postLink(scope, iElement, iAttrs) {
        iElement.find('td')
          .mouseover(function() {
            $(this).parent('tr').css('opacity', '0.7');
          }).mouseout(function() {
            $(this).parent('tr').css('opacity', '1.0');
          });
      }
    };
  });
  
  myApp.directive('context', [

    function() {
      return {
        restrict: 'A',
        scope: '@&',
        compile: function compile(tElement, tAttrs, transclude) {
          return {
            post: function postLink(scope, iElement, iAttrs, controller) {
              var ul = $('#' + iAttrs.context),
                last = null;

              ul.css({
                'display': 'none'
              });
              $(iElement).bind('contextmenu', function(event) {
                event.preventDefault();
                 ul.css({
                  position: "fixed",
                  display: "block",
                  left: event.clientX + 'px',
                  top: event.clientY + 'px'
                });
                last = event.timeStamp;
              });
              //$(iElement).click(function(event) {
              //  ul.css({
              //    position: "fixed",
              //    display: "block",
              //    left: event.clientX + 'px',
              //    top: event.clientY + 'px'
              //  });
              //  last = event.timeStamp;
              //});

              $(document).click(function(event) {
                var target = $(event.target);
                if (!target.is(".popover") && !target.parents().is(".popover")) {
                  if (last === event.timeStamp)
                    return;
                  ul.css({
                    'display': 'none'
                  });
                }
              });
            }
          };
        }
      };
    }
  ]);

  myApp.directive("sort", function() {
return {
    restrict: 'EA',
    transclude: true,
    template : 
      '<a ng-click="onClick()">'+
        '<span ng-transclude></span>'+ 
        '<i class="glyphicon" ng-class="{\'glyphicon-sort-by-alphabet\' : order === by && !reverse,  \'glyphicon-sort-by-alphabet-alt\' : order===by && reverse}"></i>'+
      '</a>',
    scope: {
	  sorting:'&',
      order: '=',
      by: '=',
      reverse : '='
	  
    },
    link: function(scope, element, attrs) {
      scope.onClick = function () {
		 
        if( scope.order === scope.by ) {
           scope.reverse = !scope.reverse 
        } else {
          scope.by = scope.order ;
          scope.reverse = false; 
        }
		 
		 scope.sorting({data:scope.by});
	//	 console.log(scope.by);
		 
		// scope.$apply();
		
		scope.$watch('reverse', function(newVal,oldVal){
   
	  //scope.listdata=newVal;
			//if(newVal)
			scope.$parent.reverse= scope.reverse ;
      });
      }
    }
}
});
  
  
  myApp.directive("myEmployee", function() {

		return {
			scope:
			{
				role:"="
			},
			template: 'From Directive : <input type="text" ng-model="role">'
		};
	});
  
  
  myApp.component('counter', {
  bindings: {
    count: '='
  },
  controller: function () {
    function increment() {
      this.count++;
    }
    function decrement() {
      this.count--;
    }
    this.increment = increment;
    this.decrement = decrement;
  },
  templateUrl: 'templates/counter.html'
  /*
  template: `
    <div class="todo">
      <input type="text" ng-model="$ctrl.count">
      <button type="button" ng-click="$ctrl.decrement();">-</button>
      <button type="button" ng-click="$ctrl.increment();">+</button>
    </div>
  `
  */
});
   
