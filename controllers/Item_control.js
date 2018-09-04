//Reference File app.js

myApp.controller('item_control', function ($scope, $state, $http, $location) {
    var vm = this;
  
    $scope.currentPage = 1;
    $scope.maxSize = 3;
	vm.dbdata={};
    this.search_data = function (search_input) {
		
        if (search_input.length >= 0)
            vm.loadData(1);

    };

    this.loadData = function (page_number) {
		
		
        var search_input = document.getElementById("search_input").value;
        $http.get(encodeURI("php/DyamicOperation.php?List=1&Sql=select *  from  vwitemmaster&TableName=vwitemmaster&Page="+page_number+"&PageSize=10&OrderBy=ItemMasterId desc&Search=ItemName like '%"+search_input+"%'")).then(function (response) {
			
            vm.item_list = response.data.listdata;
            $scope.total_row = response.data.total;
			
        });
		
    };

    $scope.$watch('currentPage + numPerPage', function () {

        vm.loadData($scope.currentPage);

        var begin = (($scope.currentPage - 1) * $scope.numPerPage)
                , end = begin + $scope.numPerPage;


    });
//    

this.AddData=function()
{
	vm.dbdata.ItemMaster={};
	vm.dbdata.ItemMaster.ItemMasterId=0;
	
}

    this.addItem = function (info) {
        $http.post('php/DyamicOperation.php',  vm.dbdata).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("create_item_info_frm").reset();
            $('#create_item_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);

        });
    };

    this.edit_item_info = function (ItemMasterId) {
        $http.get('php/DyamicOperation.php?getObject=ItemMaster&PrimaryKey=ItemMasterId&PrimaryValue='+ ItemMasterId).then(function (response) {
            vm.dbdata.ItemMaster= response.data;
        });
    };


    this.updateStudent = function () {
		
        $http.post('php/DyamicOperation.php', vm.dbdata).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            $('#edit_item_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);
        });
    };


   

    this.deleteObject = function (ItemMasterId) {
		         var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
        $http.get('php/DyamicOperation.php?deleteObject=ItemMaster&PrimaryKey=ItemMasterId&PrimaryValue='+  ItemMasterId).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.loadData($scope.currentPage);
        });
				}
    };


});

