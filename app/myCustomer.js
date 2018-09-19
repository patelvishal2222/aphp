angular.module('example_codeenable').
 directive('myCustomer', function() {
  return {
    restrict: 'E',
	  
    scope: {
		title:'=',
      listdata: '=',
	  
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
    templateUrl: 'templates/table.html'
  };
});


    