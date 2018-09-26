angular.module('example_codeenable').directive('masterForm',  ['$http', function($http) {
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
    templateUrl: 'templates/masterform.html'
  };
}]);