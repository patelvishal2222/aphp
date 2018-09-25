/*
$stateProvider
			.state('master.itemdetails', {
            url: '/itemdetails/:ItemMasterId',
              
				  views: {
			'@master': {
		   templateUrl: 'templates/master.itemdetails.html',
				 controller: 'itemdetailsControl',
                 controllerAs: "itemdet_con"
			}
				  }
        })
		
			
			$stateProvider
			.state('master.accountdetails', {
            url: '/accountdetails/:AccountMasterId',
               views: {
			'@master': {
		   templateUrl: 'templates/accountdetails3.html',
				 controller: 'accountdetailsControl',
                 controllerAs: "accdet_con"
			}
			   }
        })


*/


var myApp = angular.module('example_codeenable', ['ui.router', 'ui.bootstrap']);

myApp.config(function ($stateProvider, $locationProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');
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
            .state('/master', {
                url: '/master',
                templateUrl: 'templates/master.html',
				controller: 'master_control',
				
                  controllerAs: "mas_con",
				  resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Master";
                        }]
                }

            })
			
			 $stateProvider
			.state('/master.account', {
            url: '/account',
              templateUrl: 'templates/accountmaster.html',
		  controller: 'account_control',
             controllerAs: "acc_con"
        })
		$stateProvider
			.state('/master.item', {
            url: '/item',
              
		   templateUrl: 'templates/item.html',
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
            .state('unit', {
                url: '/unit',
                templateUrl: 'templates/unitmaster.html',
                controller: 'unit_control',
                 controllerAs: "uni_con",
                 resolve: {
                    'title': ['$rootScope', function ($rootScope) {
                            $rootScope.title = "Unit";
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
            .state('CashPrint', {
                url: '/CashPrint/:TranId',
                templateUrl: 'templates/cashprint.html',
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
			.state('/master.itemdetails', {
            url: '/itemdetails/:ItemMasterId',
              
		   templateUrl: 'templates/itemdetails.html',
				 controller: 'itemdetailsControl',
                 controllerAs: "itemdet_con"
        })
			
			$stateProvider
			.state('/master.accountdetails', {
            url: '/accountdetails/:AccountMasterId',
              
		   templateUrl: 'templates/accountdetails3.html',
				 controller: 'accountdetailsControl',
                 controllerAs: "accdet_con"
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
						if(data=='$$hashKey' ||  data.endsWith('Id') )
							;
							else
	        			csvString = csvString + data+ ",";
							
	        		}
					csvString = csvString.substring(0,csvString.length - 1);
	        		csvString = csvString + "\n";
				}
						for (data in rowData) 
					{
						if(data=='$$hashKey'  ||  data.endsWith('Id'))
							;
						else
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


myApp.directive('exportToExcel',function(){
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
			
					var csvString = '<table >';
						
	        	for(var i=0; i<scope.details.length;i++){
	        		var rowData =  scope.details[i];
					
				if(i==0)
				{
					csvString = csvString + "<tr>";
	        		for (data in rowData) 
					{
						if(data=='$$hashKey'  ||  data.endsWith('Id'))
							;
						else
	        			csvString = csvString +"<td>"+data+ " </td>";
							
	        		}
					
	        		csvString = csvString + "</tr>";
				}
				csvString = csvString + "<tr>";
						for (data in rowData) 
					{
						if(data=='$$hashKey'  ||  data.endsWith('Id'))
							;
						else
	        			csvString = csvString +"<td> " +rowData[data]+ " </td>";
							
	        		}
	        		
	        		csvString = csvString + " </tr>";
			    }
	         	
				csvString=csvString+"</table>";
				
				
					
                       
                        var fileName = 'report.xls'                            
                        var exceldata = new Blob([csvString], { type: "application/vnd.ms-excel;charset=utf-8" }) 

                        if (window.navigator.msSaveBlob) { // IE 10+
                            window.navigator.msSaveOrOpenBlob(exceldata, fileName);
                            //$scope.DataNullEventDetails = true;
                        } else {
                            var link = document.createElement('a'); //create link download file
                            link.href = window.URL.createObjectURL(exceldata); // set url for link download
                            link.setAttribute('download', fileName); //set attribute for link created
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
							
							
                        }   
						
						
	        });
    	}
  	}
});

myApp.directive('exportToJson',function(){
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
				var data = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(scope.details));
	console.log(data);
            var downloader = document.createElement('a');

            downloader.setAttribute('href', data);
            downloader.setAttribute('download', 'file.json');
			document.body.appendChild(downloader);
			downloader.click();
			document.body.removeChild(downloader);
				
	        
			
				
						
						
			 });
		}
    	
  	}
});


myApp.directive('exportToXml',function(){
  	return {
    	restrict: 'A',
    	link: function (scope, element, attrs) {
    		var el = element[0];
			if(attrs.details){
				scope.details = attrs.details;
                
				
            }
	        element.bind('click', function(e){
				
				
					
	function objectToXml(obj) {
        var xml = '';

        for (var prop in obj) {
            if (!obj.hasOwnProperty(prop)) {
                continue;
            }

            if (obj[prop] == undefined)
                continue;

            xml += "<" + prop + ">";
            if (typeof obj[prop] == "object")
                xml += objectToXml(new Object(obj[prop]));
            else
                xml += obj[prop];

            xml += "<!--" + prop + "-->";
        }

        return xml;
    }
					var table = e.target.nextElementSibling;
				 scope.details = scope.$eval(attrs.details);
			 var data= encodeURIComponent(objectToXml( scope.details));
	var data = "data:text/xml;charset=utf-8," +data;
	console.log(data);
            var downloader = document.createElement('a');

            downloader.setAttribute('href', data);
            downloader.setAttribute('download', 'file.xml');
			document.body.appendChild(downloader);
			downloader.click();
			document.body.removeChild(downloader);
				
	        
			
				
						
						
			 });
		}
    	
  	}
});


myApp.directive('exportToPrint',function(){
  	return {
    	restrict: 'A',
    	link: function (scope, element, attrs) {
    		var el = element[0];
			if(attrs.details){
				//scope.details = attrs.details;
                
				
            }
	        element.bind('click', function(e){
				
					  var printContents= document.getElementById(attrs.details);
 var popupWin = window.open('', '_blank', 'width=600,height=600,scrollbars=no,menubar=no,toolbar=no,location=no,status=no,titlebar=no');
 popupWin.window.focus();
    popupWin.document.write('<!DOCTYPE html><html><head>' +
                       '<link rel="stylesheet" type="text/css" href="style.css" />' +
					    
   

                       '</head><body onload="window.print()"><div class="reward-body"><div style="height:70px"></div>' + printContents.outerHTML + '</div></html>');
			   
	popupWin.print();
	popupWin.close();
	        	
						
	        });
    	}
  	}
});

myApp.directive('exportToPdf',function(){
  	return {
    	restrict: 'A',
    	link: function (scope, element, attrs) {
    		var el = element[0];
			if(attrs.details){
				//scope.details = attrs.details;
                
				
            }
			  element.bind('click', function(e){
			
	        html2canvas(document.getElementById('printdata'), {
            onrendered: function (canvas) {
                var data = canvas.toDataURL();
                var docDefinition = {
                    content: [{
                        image: data,
                        width: 500,
                    }]
                };
                pdfMake.createPdf(docDefinition).download("test.pdf");
            }
 
			 });
 
	        	
						
	        });
    	}
  	}
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
		 
		// scope.sorting({data:scope.by});
	//	 console.log(scope.by);
		 
		// scope.$apply();
		
		scope.$watch('reverse', function(newVal,oldVal){
   
	  //scope.listdata=newVal;
			//if(newVal)
			//scope.$parent.reverse= scope.reverse ;
      });
      }
    }
}
});

myApp.directive('masterForm', function() {
	return {
    restrict: 'EA',
	  
    scope: {
		title:"=",
      datamodel: '=',
	  formfields:'=',
	  insertupdate:'&',
	  showform:'=',
	  hideform:'='
	 },
	link: function (scope, element, attrs) {
  
		scope.$watch('showform', function(newVal,oldVal){
		$('#formmodel').modal({ show: 'true'});
	});
	scope.$watch('hideform', function(newVal,oldVal){
   	$('#formmodel').modal('toggle');
	});
	},
    templateUrl: 'templates/masterform.html'
  };
});


myApp.directive('downloadAsExcel', function($compile, $sce, $templateRequest) {
  return {
    restrict: 'E',
    scope: {
      template: '@',
      object: '='
    },
    replace: true,
    template: '<a class="xls">Download as Excel</a>',
    link: function(scope, element, attrs) {
      var contentType = 'data:application/vnd.ms-excel;base64';
      var htmlS = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" ><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{sheetname}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>';
      var format = function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) };
      
      var blobbed = function(data) {
        var blob = new Blob([format(htmlS, data)], { type: contentType });
        var blobURL = window.URL.createObjectURL(blob);
        if (blobURL) {
          element.attr('href', blobURL);
          element.attr('download', data['name']);
        }
      };
      
      scope.$watch('object', function(nv, ov) {
        var tUrl = $sce.getTrustedResourceUrl(scope.template);
console.log(tUrl);
        $templateRequest(tUrl)
        .then(function(tmpl) {
          var t = $('<div/>').append($compile(tmpl)(scope));
		
          setTimeout(function() {
            scope.$apply();
            blobbed({ 
              sheetname: attrs.sheetname, 
              name: attrs.xlname, 
              table: t.html()
            });
          }, 100);
        });
      }, true);
    }
  };
})

/*

myApp.directive('myTag', ['$http', function($http) {
return {
    restrict: 'E',
    transclude: true,
    replace: true,     
    scope:{
        src:"="       
    },
    controller:function($scope){
        console.info("enter directive controller");
        $scope.gallery = [];

    console.log($scope.src);

        $http({method: 'GET', url:$scope.src}).then(function (result) {
                           console.log(result);                              
                        }, function (result) {
                            alert("Error: No data returned");
                        });
    }
}
}]);
*/


