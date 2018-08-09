//Reference File app.js

myApp.controller('item_control', function ($scope, $state, $http, $location) {
    var vm = this;
  
    $scope.currentPage = 1;
    $scope.maxSize = 3;
	
    this.search_data = function (search_input) {
		
        if (search_input.length > 0)
            vm.loadData(1);

    };

    this.loadData = function (page_number) {
		
		
        var search_input = document.getElementById("search_input").value;
        $http.get('php/item/select.php?page=' + page_number + '&search_input=' + search_input).then(function (response) {
            vm.item_list = response.data.item_list;
            $scope.total_row = response.data.total;
			
        });
		
    };

    $scope.$watch('currentPage + numPerPage', function () {

        vm.loadData($scope.currentPage);

        var begin = (($scope.currentPage - 1) * $scope.numPerPage)
                , end = begin + $scope.numPerPage;


    });
//    

    this.addItem = function (info) {
        $http.post('php/item/insert.php', info).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("create_item_info_frm").reset();
            $('#create_item_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);

        });
    };

    this.edit_item_info = function (ItemMasterId) {
        $http.get('php/item/selectone.php?ItemMasterId=' + ItemMasterId).then(function (response) {
            vm.item = response.data;
        });
    };


    this.updateStudent = function () {
		
        $http.post('php/item/update.php', vm.item).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            $('#edit_item_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);
        });
    };


    this.get_item_info = function (ItemMasterId) {
        $http.get('php/item/selectone.php?ItemMasterId=' + ItemMasterId).then(function (response) {
            vm.item = response.data;


        });
    };


    this.deleteObject = function (ItemMasterId) {
		         var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
        $http.post('php/item/delete.php?ItemMasterId=' + ItemMasterId).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.loadData($scope.currentPage);
        });
				}
    };


});

