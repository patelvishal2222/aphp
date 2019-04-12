var myApp = angular.module("masterMind",[]);
//myApp.constant('URL','delux/dataLayer/php/EntiryJson.php');
myApp.constant('URL','delux/dataLayer/asp/DataLayer.ashx');

//http://plnkr.co/edit/z2nXgXyGi6LhSHth8ZNi?p=preview
angular.module('masterMind').directive('barcode', function(){
  return{
    restrict: 'AE',
    template: '<img id="barcodeImage" style="border: solid 1px black;" src="{{src}}"/>',
    scope: {
      food: '='
    },
    link: function($scope){
      $scope.$watch('food', function(food){
        console.log($scope.food);
        var barcode = new bytescoutbarcode128();
        var space= "  ";

            barcode.valueSet([$scope.food.TranId].join(space));
            barcode.setMargins(5, 5, 5, 5);
            barcode.setBarWidth(2);

            var width = barcode.getMinWidth();

            barcode.setSize(width, 100);

            $scope.src = barcode.exportToBase64(width, 100, 0);
      }, true);
    }
  }
});

//directive
angular.module('masterMind').directive('masterForm',  ['$http','URL', function($http,URL) {
	return {
    restrict: 'EA',
	  
    scope: {
		title:"=",
      datamodel: '=',
	  formfields:'=',
	  insertupdate:'&',
	  showform:'=',
	  hideform:'=',
	  model:'='
	 },
	link: function (scope, element, attrs) {

		scope.getData=function (Query,TableName,ComboQuery,OptionTableName)
		{
			$http.get(URL+'?Query='+Query ).then(function (response) {
           scope[TableName]= response.data.listdata;
				});
		}
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
    templateUrl: 'delux/js/masterform.html'
  };
}]);

angular.module('masterMind').
 directive('tableReport', function() {
  return {
    restrict: 'E',
    scope: {
	addbutton:'=',
	editbutton:'=',
  deletebutton:'=',
		title:'=',
      listdata: '=',
	  displaydata:'=',
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
		}
		scope.editedata1=function(object,index)
		{
			scope.editmode({object:object,index:index});
		}
		scope.deletemode1=function(object,index)
		{
			scope.deletemode({object:object,index:index});
		}
		scope.viewdata1=function(object,index)
		{
		
			 scope.doubleclick1({object:object,index:index});
			 
		}
		scope.rowIndex = -1;
		scope.selectRow = function(index){
			
          scope.rowIndex = index;
		}
		scope.dblclick = function(object,index){
	  scope.doubleclick1({object:object,index:index});
		}
		 scope.clicked = '';
		scope.ShowContextMenu = function(){
  };
  scope.edit = function() {
    scope.clicked = 'edit was clicked';
	scope.dataone();
  };
  
  scope.properties = function() {
    scope.clicked = 'properties was clicked';

  };
  scope.link = function() {
    scope.clicked = 'link was clicked';
  };
  scope.delete = function() {
    scope.clicked = 'delete was clicked';
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
	
		
      }
    }
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

angular.module('masterMind').directive('ngRightClick', function($parse) {
    return function(scope, element, attrs) {
	 
        var fn = $parse(attrs.ngRightClick);
        element.bind('contextmenu', function(event) {
            scope.$apply(function() {
                event.preventDefault();
                fn(scope, {$event:event});
            });
        });
    };
});


		
//	component
function controlEntryController($scope, $element, $attrs,$http,$parse,URL) {
	
	var ctrl = this;
	ctrl.getData=function (Query,TableName,ComboQuery,OptionTableName)
		{
			$http.get(URL+'?Query='+Query ).then(function (response) {
           $scope[TableName]= response.data.listdata;
		   
		
       });
	   
	   ctrl.SelectCombox=function(TableName,fieldvalue,selectvalue,onchange)
	   {
		     
		    if(selectvalue==undefined)
			   return;
		   else
		   {
			   
			  var object=$scope.$eval(selectvalue); 
			
				 for(  key in object)
				 
				 {
				

					 if(key=='Rate' && ctrl.rate!=undefined )
					 {
						 
							ctrl.datamodel[key]= ctrl.datamodel[fieldvalue][ctrl.rate];
							
					 }
					 else
					 {
						 ctrl.datamodel[key]= ctrl.datamodel[fieldvalue][object[key]];
					 }
					 
				 }
				 if(onchange!=undefined)
				 { 
						ctrl.textboxchage(onchange);
				 }
			   
		   }
		   
	   }
	ctrl.countdata =function (a) 
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
	 
	  ctrl.QuantityCountFormula=function (height,length, width,QuantityTypeId)
	  {
		  
		  var ans=1;
		  if(QuantityTypeId==2)
		  {
				
			  ans=ctrl.countdata(height)*ctrl.countdata(length);
			  width=0;
		  }
			  else
				  ans=height*length*width;
		  return ans;
	  }
	 
	   
	   ctrl.textboxchage=function(onchange)
	   {
		 
		   if(onchange==undefined)
			   return;
		   else{
			   
			   var formula=onchange.split("|");
			   
			   for(i=0;i<formula.length;i++)
			   {
			   
					var equation=formula[i].split('=');
					var selfobject=equation[0];
					var formulaobject=equation[1];
					var parseFun = $parse(formulaobject);
					ctrl.datamodel[selfobject]= parseFun(ctrl,ctrl.datamodel);
			   }
			
				
		   }
							
		   
	   }
	   
	   
		}
	   
  
}

angular.module('masterMind').component('controlEntry', {
  templateUrl: 'delux/js/controlEntry.html',
  
   controller:controlEntryController,
  bindings: {
    
	  rate:'=',
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
function tableEntryController2($scope, $element, $attrs,$http) {
	var ctrl = this;
	
	ctrl.editerecord=function (object,index)
	{
		
		
		ctrl.editindex=index;
		
	}
	ctrl.cancelmode=function ()
	{
		
		ctrl.editindex=-1;
		
	}
	
}
angular.module('masterMind').component('tableEntry2', {
  templateUrl: 'delux/js/tableEntry2.html',
  
   controller:tableEntryController2,
  bindings: {
	  editindex:'=',
    title:'=',
	tempmodel:'=',
	updatemode:'&',
	deleterecord:'&',
	addmode:'&',
      datamodel: '=',
	  formfields:'=',
	  
	  
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
			if(ctrl.crdrmasterid!=undefined)
			{
				ctrl["Temp"+ctrl.tablename]["VirtualCrDrMaster"]={};
				ctrl["Temp"+ctrl.tablename]["VirtualCrDrMaster"]["CrDrMasterId"]=ctrl.crdrmasterid;
				if(ctrl.crdrmasterid==1)
				ctrl["Temp"+ctrl.tablename]["VirtualCrDrMaster"]["CrDrName"]="Cr";
				if(ctrl.crdrmasterid==2)
				ctrl["Temp"+ctrl.tablename]["VirtualCrDrMaster"]["CrDrName"]="Dr";
			
			}
			ctrl.editDialog.open(ctrl["Temp"+ctrl.tablename] , ctrl.modelfields,"Add Item","Add");
            } 
			
			this.editrecord1=function(object,index)
			{
              $scope.ModelButton = "Edit";
              ctrl.TempTrandetails = {};
			  ctrl["Temp"+ctrl.tablename] = {};
              ctrl["Temp"+ctrl.tablename]= angular.copy(object);
		      ctrl.editDialog.open(  ctrl["Temp"+ctrl.tablename], ctrl.modelfields,"Edit Item","Edit");
			}
			this.deleterecord1=function(object,index)
			{
					if(ctrl.detailsids==undefined)
						ctrl.detailsids="";
			
				if(ctrl.detailsids!=undefined)
					{
						if( ctrl.datamodel[index][ctrl.tablename+"Id"]>0)
						{
							if(ctrl.detailsids=="")
							ctrl.detailsids=ctrl.datamodel[index][ctrl.tablename+"Id"];
							else
							ctrl.detailsids=ctrl.detailsids+","+ctrl.datamodel[index][ctrl.tablename+"Id"];
						}
					}
				ctrl.datamodel.splice(index, 1);
                for (; index <  ctrl.datamodel.length; index++) {
						ctrl.datamodel[index].Srno = index + 1;
                }
                ctrl.total= ctrl.TotalAccount(ctrl.datamodel,"Amount");
				console.log(ctrl.detailsids);
			}
	   //pushRecord
           ctrl.pushrecord = function (object) 
		   {
				ctrl.editDialog.close();
				//default  data push text
				angular.forEach(ctrl.formfields,function(object)
			{
				if(object.DefaultData!=undefined &&  object.DefaultData!="" )
				{
					/*
					if(object["FieldName"]=="VirtualCrDrMaster")
					{
						ctrl["Temp"+ctrl.tablename]["VirtualCrDrMaster"]={};
				ctrl["Temp"+ctrl.tablename]["VirtualCrDrMaster"]["CrDrMasterId"]=object.DefaultData;
				if(object.DefaultData==1)
				ctrl["Temp"+ctrl.tablename]["VirtualCrDrMaster"]["CrDrName"]="Cr";
				if(object.DefaultData==2)
				ctrl["Temp"+ctrl.tablename]["VirtualCrDrMaster"]["CrDrName"]="Dr";
					}
					else 
						*/
						if(object["FieldName"].startsWith("Virtual"))
					{
						var FieldName=object["FieldName"].replace("Virtual","")+"Id";
						if(ctrl["Temp"+ctrl.tablename][FieldName]==undefined ||ctrl["Temp"+ctrl.tablename][FieldName]=="")
						ctrl["Temp"+ctrl.tablename][FieldName]=object.DefaultData;
					}
					else
						{
						if(ctrl["Temp"+ctrl.tablename][FieldName]==undefined ||ctrl["Temp"+ctrl.tablename][FieldName]=="")
						ctrl["Temp"+ctrl.tablename][object["FieldName"]]=object.DefaultData;
						}
					
				}
				
			});
			//End Default Data
				if (ctrl["Temp"+ctrl.tablename]["Srno"] == 0) {
				    if ( ctrl.datamodel == null)
                       ctrl.datamodel = [];
                  ctrl["Temp"+ctrl.tablename]["Srno"] =  ctrl.datamodel.length + 1;
                    ctrl.datamodel.push(ctrl["Temp"+ctrl.tablename]);
                }
                else {
                   ctrl.datamodel[ctrl["Temp"+ctrl.tablename]["Srno"]- 1] =ctrl["Temp"+ctrl.tablename];
				}
			    ctrl.total=ctrl.TotalAccount(ctrl.datamodel,"Amount");
				angular.forEach(ctrl.formfields,function(object)
					{
						if(object.Aggregate!=undefined )
							{
								
							}
					});
            }
	  
		this.TotalAccount=function(datalist,key)
			{
				var total = 0;
                for (var index = 0; index < datalist.length; index++)
				{
					 if(ctrl.crdrmasterid==undefined)
					 {
						 total = total + parseFloat(datalist[index][key]);
					 }
					 else
					 {
						 if(datalist[index]["VirtualCrDrMaster"]["CrDrMasterId"]==ctrl.crdrmasterid )
							 total = total + parseFloat(datalist[index][key]);
					 }
				}
				return total;
			}
}

angular.module('masterMind').component('dynamicDetails', {
  templateUrl: 'delux/js/DynamicDetails.html',
  controller: dynamicDetailsController,
  bindings: {
	  crdrmasterid:'=',
	  rate:'=',
    total:'=',
	detailsids:'=',
	tablename:'=',
      datamodel: '=',
	  modelfields:'=',
	  formfields:'='
	  }
});

	var EditPersonDialogModel = function () {
  this.visible = false;
};
EditPersonDialogModel.prototype.open = function(object, modelFields,title,ActionName) {
   this.title=	title;
  this.object = object;
  this.modelFields=modelFields;
  this.ActionName=ActionName;
  this.visible = true;
  
};

EditPersonDialogModel.prototype.open2 = function() {
   
  this.visible = true;
  
};
EditPersonDialogModel.prototype.close = function() {
  this.visible = false;
};

angular.module('masterMind').directive('editPersonDialog', [function() {
  return {
    restrict: 'E',
    scope: {
		rate:'=',
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
//filter
angular.module('masterMind')
.filter('convertToWord', function() {
    return function(amt) {
		if(amt==undefined)
			return "";
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
       var amount = amt.toString();
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

     angular.module('masterMind').filter("mathoperation", function ($parse) {

            return function (object,values) {
				
			 var parseFun = $parse(values);
						 var   sum= parseFun(object);
                return sum;
            }
        });
		angular.module('masterMind').filter("arraysum", function ($parse) {
            return function (object,fieldName,Condition) {
				if(fieldName==undefined || object==undefined )
				return 0;
			else{
				var sum=0;
				for(i=0;i<object.length;i++)
				{
					if(Condition==undefined)
					{
							if(object[i][fieldName]!=undefined)
							sum=sum+parseFloat(object[i][fieldName]);
					}
				     else 
					 {
						 var parseFun = $parse(Condition);
						 var   flag= parseFun(object[i]);
						 if(flag)
							 sum=sum+parseFloat(object[i][fieldName]);
						 
					 }
				
				}

                return sum;
			}
            }
        });
		angular.module('masterMind').filter("countNotAggregate", function () {
            return function (object) {
				if( object==undefined )
				return 0;
			else{
				
				var count=0;
				for(i=0;i<object.length;i++)
				{
					
					if(object[i]["ControlTypeName"]=='Hideen'  ||  object[i]["ControlTypeName"]==false )
					{
					}
					else if(object[i]["ControlTypeName"]=='text' || object[i]["ControlTypeName"]=='Text'|| object[i]["ControlTypeName"]=='Label'|| object[i]["ControlTypeName"]=='TableText' ||  object[i]["ControlTypeName"]=='ComboBox')
					 {
						 if (object[i]["Aggregate"]=='sum')
							 return count;
							 else
						 count++;
					 }
					else 
					{
						
					}
				
				}
                return count;
			}
            }
        });
 angular.module('masterMind').filter("MyCondition", function ($parse) {
            return function (object,values) {
				if(values==undefined ||  object==undefined  ||  values=='')
				{
					return true;
				}
					else
					{
						var parseFun = $parse(values);
						    return  flag= parseFun(object);
					}
            }
        });
//service
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
    
