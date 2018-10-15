var myApp = angular.module("masterMind",[]);

angular.module('masterMind').directive('masterForm',  ['$http', function($http) {
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

		scope.getData=function (Query,TableName,ComboQuery,OptionTableName)
		{
			$http.get('php/DyamicOperation.php?Query='+Query ).then(function (response) {
           scope[TableName]= response.data.listdata;
		
       });
  

		}
		
		scope.$watch('showform', function(newVal,oldVal){
		$('#formmodel').modal({ show: 'true'});
	});
	scope.$watch('hideform', function(newVal,oldVal){
   	$('#formmodel').modal('toggle');
	});
	},
    templateUrl: 'delux/js/masterform.html'
  };
}]);



angular.module('masterMind').
 directive('tableReport', function() {
  return {
    restrict: 'E',
	  
    scope: {
		title:'=',
      listdata: '=',
	  tableview:'=',
	  addmode:'&',
	  editmode:'&',
	  deletemode:'&',
	  doubleclick1:'&'
	  
	
    },
	
    
	link: function (scope, element, attrs) {
		
		
	
		
		


	
	

 scope.clearAll=function(record)
 {
	
	 	for (column in record) 
					{
						if(column!='$$hashKey')
							 record[column]='';
	        			
							
	        		}
 }
		scope.adddata=function()
		{
			 
			scope.addmode();
			//console.log('add mode');
		}
		
		scope.editedata1=function(object,index)
		{
			//console.log('editedata1');
			scope.editmode({object:object,index:index});
		}
		scope.deletemode1=function(object,index)
		{
			//console.log('deletemode');
			scope.deletemode({object:object,index:index});
		}
		scope.viewdata1=function(object,index)
		{
			console.log('viewdata');
			 scope.doubleclick1({object:object,index:index});
			 
		}
	
  scope.rowIndex = -1;
		scope.selectRow = function(index){
			
			 if(index == scope.rowIndex)
        scope.rowIndex = -1;
        else
          scope.rowIndex = index;
		}
		
		scope.dblclick = function(object,index){
			
			
			 if(index == scope.rowIndex)
        scope.rowIndex = -1;
        else
          scope.rowIndex = index;
	  console.log('doubleclick');
	  scope.doubleclick1({object:object,index:index});
	
		}
		 scope.clicked = '';
  scope.ShowContextMenu = function(){
   // alert('hello');
  };
  scope.edit = function() {
    scope.clicked = 'edit was clicked';
	scope.dataone();
    console.log("edit");
  };
  
  scope.properties = function() {
    scope.clicked = 'properties was clicked';
    //console.log(scope.clicked);
  };
  
  scope.link = function() {
    scope.clicked = 'link was clicked';
   // console.log(scope.clicked);
  };
  
  scope.delete = function() {
    scope.clicked = 'delete was clicked';
   // console.log(scope.clicked);
  };
		
		
	},
    templateUrl: 'delux/js/tableReport.html'
  };
});



angular.module('masterMind').directive('cellHighlight', function() {
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
  
  angular.module('masterMind').directive('context', [

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


angular.module('masterMind').directive('exportToCsv',function(){
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


angular.module('masterMind').directive('exportToExcel',function(){
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

angular.module('masterMind').directive('exportToJson',function(){
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
	//console.log(data);
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


angular.module('masterMind').directive('exportToPdf',function(){
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


angular.module('masterMind').directive('exportToPrint',function(){
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


angular.module('masterMind').directive('exportToXml',function(){
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
	//console.log(data);
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


angular.module('masterMind').directive("sort", function() {
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



angular.module('masterMind')

.filter('convertToWord', function() {
    return function(amount) {
        var words = new Array();
        words[0] = '';
        words[1] = 'One';
        words[2] = 'Two';
        words[3] = 'Three';
        words[4] = 'Four';
        words[5] = 'Five';
        words[6] = 'Six';
        words[7] = 'Seven';
        words[8] = 'Eight';
        words[9] = 'Nine';
        words[10] = 'Ten';
        words[11] = 'Eleven';
        words[12] = 'Twelve';
        words[13] = 'Thirteen';
        words[14] = 'Fourteen';
        words[15] = 'Fifteen';
        words[16] = 'Sixteen';
        words[17] = 'Seventeen';
        words[18] = 'Eighteen';
        words[19] = 'Nineteen';
        words[20] = 'Twenty';
        words[30] = 'Thirty';
        words[40] = 'Forty';
        words[50] = 'Fifty';
        words[60] = 'Sixty';
        words[70] = 'Seventy';
        words[80] = 'Eighty';
        words[90] = 'Ninety';
        amount = amount.toString();
        var atemp = amount.split(".");
        var number = atemp[0].split(",").join("");
        var n_length = number.length;
        var words_string = "";
        if (n_length <= 9) {
            var n_array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0);
            var received_n_array = new Array();
            for (var i = 0; i < n_length; i++) {
                received_n_array[i] = number.substr(i, 1);
            }
            for (var i = 9 - n_length, j = 0; i < 9; i++, j++) {
                n_array[i] = received_n_array[j];
            }
            for (var i = 0, j = 1; i < 9; i++, j++) {
                if (i == 0 || i == 2 || i == 4 || i == 7) {
                    if (n_array[i] == 1) {
                        n_array[j] = 10 + parseInt(n_array[j]);
                        n_array[i] = 0;
                    }
                }
            }
            value = "";
            for (var i = 0; i < 9; i++) {
                if (i == 0 || i == 2 || i == 4 || i == 7) {
                    value = n_array[i] * 10;
                } else {
                    value = n_array[i];
                }
                if (value != 0) {
                    words_string += words[value] + " ";
                }
                if ((i == 1 && value != 0) || (i == 0 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Crores ";
                }
                if ((i == 3 && value != 0) || (i == 2 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Lakhs ";
                }
                if ((i == 5 && value != 0) || (i == 4 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Thousand ";
                }
                if (i == 6 && value != 0 && (n_array[i + 1] != 0 && n_array[i + 2] != 0)) {
                    words_string += "Hundred and ";
                } else if (i == 6 && value != 0) {
                    words_string += "Hundred ";
                }
            }
            words_string = words_string.split("  ").join(" ");
        }
        return words_string;
    };
});
		
		
function controlEntryController($scope, $element, $attrs,$http) {
	
	var ctrl = this;
	ctrl.getData=function (Query,TableName,ComboQuery,OptionTableName)
		{
			$http.get('php/DyamicOperation.php?Query='+Query ).then(function (response) {
           $scope[TableName]= response.data.listdata;
		   
		
       });
	   
	   ctrl.SelectCombox=function(TableName,fieldvalue,selectvalue)
	   {
		     console.log(selectvalue);
		    if(selectvalue==undefined)
			   return;
		   else
		   {
			   //object=$scope.$eval(selectvalue);
			     
				 var objectkeys=selectvalue.split('|');
				 for(i=0;i<objectkeys.length;i++)
				 {
					 var key=objectkeys[i].split(",");
					 
					 ctrl.datamodel[key[0]]= ctrl.datamodel[fieldvalue][key[1]]
				 }
			   
		   }
		   
	   }
	   ctrl.textboxchage=function(onchange)
	   {
		 
		   if(onchange==undefined)
			   return;
		   else{
			var values=onchange.split('=');
			var selfobject=values[0];
			var value=values[1].split('*');
				ctrl.datamodel[selfobject]=1;
				
				for(i=0;i<value.length;i++)
				{
					
					ctrl.datamodel[selfobject]=ctrl.datamodel[selfobject]*ctrl.datamodel[value[i]];
					
				}
		   }
							
		   
	   }
	   
	   
		}
	   
  
}

angular.module('masterMind').component('controlEntry', {
  templateUrl: 'delux/js/controlEntry.html',
  
   controller:controlEntryController,
  bindings: {
    
	
      datamodel: '=',
	  formfields:'='
	  
  }
});


function tableEntryController($scope, $element, $attrs,$http) {
	
	
}
angular.module('masterMind').component('tableEntry', {
  templateUrl: 'delux/js/tableEntry.html',
  
   controller:tableEntryController,
  bindings: {
    
	editrecord:'&',
	deleterecord:'&',
      datamodel: '=',
	  formfields:'='
	  
  }
});

function dynamicDetailsController($scope, $element, $attrs,$http) {
	
	var ctrl = this;
		ctrl.editDialog = new EditPersonDialogModel();
		 //AddRecord
            ctrl.AddRecord = function () {
				
            $scope.ModelButton = "Add";
            ctrl["Temp"+ctrl.tablename] = {};
			ctrl["Temp"+ctrl.tablename]["Srno"]=0;
			ctrl["Temp"+ctrl.tablename][ctrl.tablename+"Id"]=0;
			
			ctrl.editDialog.open(ctrl["Temp"+ctrl.tablename] , ctrl.modelfields,"Add Item","Add");



            } 
			
			this.editrecord1=function(object,index)
	{
            
                $scope.ModelButton = "Edit";
               ctrl.TempTrandetails = {};
			  ctrl["Temp"+ctrl.tablename] = {};
             ctrl["Temp"+ctrl.tablename]= angular.copy(object);
			   /*
			   vm.TempTrandetails.Height=parseFloat(TransactionDetails.Height);
			   vm.TempTrandetails.Length= parseFloat(TransactionDetails.Length);
			   vm.TempTrandetails.Nos= parseFloat(TransactionDetails.Nos);
			   vm.TempTrandetails.Rate= parseFloat(TransactionDetails.Rate);
			   
			   */
               
            
		   ctrl.editDialog.open(  ctrl["Temp"+ctrl.tablename], ctrl.modelfields,"Edit Item","Edit");
		
	}
	this.deleterecord1=function(object,index)
	{
		console.log('deleterecord1');
					if(ctrl.detailsIds!=undefined)
					{
						if( ctrl.datamodel[index][ctrl.tablename+"Id"]>0)
						{
							if(ctrl.detailsIds=="")
							ctrl.detailsIds=ctrl.dbdata.tran.trandetails[index].TranDetailsId;
								else
									ctrl.detailsIds=ctrl.detailsIds+","+ctrl.datamodel[index][ctrl.tablename+"Id"];
							}
					}
                 ctrl.datamodel.splice(index, 1);
                for (; index <  ctrl.datamodel.length; index++) {
						ctrl.datamodel[index].Srno = index + 1;
                }
                 
				 //ctrl.dbdata.tran.Total= sm.TotalArrayObject( ctrl.dbdata.tran.trandetails,"Amount");
	}
	  
	  
	   //pushRecord
            ctrl.pushrecord = function (object) {
					ctrl.editDialog.close();
				
				
				                if (ctrl["Temp"+ctrl.tablename]["Srno"] == 0) {
									
                    if ( ctrl.datamodel == null)
                       ctrl.datamodel = [];
					 
                  ctrl["Temp"+ctrl.tablename]["Srno"] =  ctrl.datamodel.length + 1;
                    ctrl.datamodel.push(ctrl["Temp"+ctrl.tablename]);
                }
                else {
					
					
                   ctrl.datamodel[ctrl["Temp"+ctrl.tablename]["Srno"]- 1] =ctrl["Temp"+ctrl.tablename];
               }
			   
			  //  ctrl.dbdata.tran.Total= sm.TotalArrayObject( ctrl.dbdata.tran.trandetails,"Amount");
			   

            }
	  
	  
	  
}

angular.module('masterMind').component('dynamicDetails', {
  templateUrl: 'delux/js/DynamicDetails.html',
  
   controller: dynamicDetailsController,
  bindings: {
    
	detailsIds:'=',
	tablename:'=',
      datamodel: '=',
	  modelfields:'=',
	  formfields:'='
	  
  }
});


angular.module('masterMind').directive('dynamicModel', ['$compile', '$parse', function ($compile, $parse) {
    return {
        restrict: 'A',
        terminal: true,
        priority: 100000,
        link: function (scope, elem) {
            var name = $parse(elem.attr('dynamic-model'))(scope);
            elem.removeAttr('dynamic-model');
            elem.attr('ng-model', name);
            $compile(elem)(scope);
        }
    };
}]);


	var EditPersonDialogModel = function () {
  this.visible = false;
};
EditPersonDialogModel.prototype.open = function(object, modelFields,title,ActionName) {
   this.title=	title;
  this.object = object;
  this.modelFields=modelFields;
  this.ActionName=ActionName
  this.visible = true;
};
EditPersonDialogModel.prototype.close = function() {
  this.visible = false;
};

angular.module('masterMind').directive('editPersonDialog', [function() {
  return {
    restrict: 'E',
    scope: {
	   modelaction:'&',
      model: '=',
	  
    },
    link: function(scope, element, attributes) {
		
      scope.$watch('model.visible', function(newValue) {
        var modalElement = element.find('.modal');
        modalElement.modal(newValue ? 'show' : 'hide');
      });
      
      element.on('shown.bs.modal', function() {
        scope.$apply(function() {
          scope.model.visible = true;
        });
      });

      element.on('hidden.bs.modal', function() {
        scope.$apply(function() {
          scope.model.visible = false;
        });
      });
      
    },
    templateUrl: 'delux/js/dialog.html',
  };
}]);


angular.module('masterMind').service("ServiceMaster",function()
{
	  return function()
	  {
		  
			this.TotalArrayObject=function(datalist,key)
			{
				var total = 0;


                for (var index = 0; index < datalist.length; index++)
                    total = total + parseFloat(datalist[index][key]);
				
				return total;
                
			}
	  };
});


     angular.module('masterMind').filter("mathoperation", function () {

            return function (object,values) {
				
				var value=values.split('*');
				
				
				var sum=1;
				for(i=0;i<value.length;i++)
				{
				
					sum=sum*object[value[i]];
					
				}

                return sum;
            }
        });
		
		
		angular.module('masterMind').filter("arraysum", function () {

            return function (object,fieldName) {
				
			
				if(fieldName==undefined || object==undefined )
				return 0;
			else{
				
				var sum=0;
				for(i=0;i<object.length;i++)
				{
					
					
					sum=sum+parseFloat(object[i][fieldName]);
				
				}

                return sum;
			}
            }
        });
 angular.module('masterMind').filter("MyCondition", function () {

            return function (object,values) {
				
				
				if(values==undefined ||  object==undefined)
				{
					return true;
				}
					else
					{
							var value=values.split('==');
							var value1=object;
							
							var keyobject=value[0].split('.');
							for(i=0;i<keyobject.length;i++)
							{
								value1=value1[keyobject[i]];
							}
							
							var  value2=value[1];
						
				
					if(value1==undefined || value2==undefined)
						return true;
					else if(value1==value2)
						return true;
					else
				
				

                return false;
					}
            }
        });
		
	
angular.module('masterMind').directive('ngRightClick', function($parse) {
    return function(scope, element, attrs) {
	 console.log("ngRightClick");
        var fn = $parse(attrs.ngRightClick);
        element.bind('contextmenu', function(event) {
            scope.$apply(function() {
                event.preventDefault();
                fn(scope, {$event:event});
            });
        });
    };
});


    
