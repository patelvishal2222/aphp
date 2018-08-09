//Reference File app.js

myApp.controller('account_control', function ($scope, $state, $http, $location) {
    var vm = this;
  
    $scope.currentPage = 1;
    $scope.maxSize = 3;
	
    this.search_data = function (search_input) {
		
        if (search_input.length > 0)
            vm.loadData(1);

    };

    this.loadData = function (page_number) {
		
		
        var search_input = document.getElementById("search_input").value;
        $http.get('php/accountmaster/select.php?page=' + page_number + '&search_input=' + search_input).then(function (response) {
            vm.account_list = response.data.account_list;
            $scope.total_row = response.data.total;
			
        });
		
    };

    $scope.$watch('currentPage + numPerPage', function () {

        vm.loadData($scope.currentPage);

        var begin = (($scope.currentPage - 1) * $scope.numPerPage)
                , end = begin + $scope.numPerPage;


    });
//    

    this.addAccount = function (info) {
        $http.post('php/accountmaster/insert.php', info).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("create_account_info_frm").reset();
            $('#create_account_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);

        });
    };

    this.edit_item_info = function (AccountMasterId) {
        $http.get('php/accountmaster/selectone.php?AccountMasterId=' + AccountMasterId).then(function (response) {
            vm.account = response.data;
        });
    };


    this.updateAccount = function () {
        $http.post('php/accountmaster/update.php', this.account).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            $('#edit_item_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);
        });
    };


    this.get_item_info = function (AccountMasterId) {
        $http.get('php/accountmaster/selectone.php?AccountMasterId=' + AccountMasterId).then(function (response) {
            vm.item = response.data;


        });
    };


    this.deleteObject = function (AccountMasterId) {
		         var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
        $http.post('php/accountmaster/delete.php?AccountMasterId=' + AccountMasterId).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.loadData($scope.currentPage);
        });
				}
    };


});

