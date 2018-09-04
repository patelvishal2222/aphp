//Reference File app.js

myApp.controller('account_control', function ($scope, $state, $http, $location) {
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
        $http.get(encodeURI("php/DyamicOperation.php?List=1&Sql=select *  from  vwAccountMaster&TableName=AccountMaster&Page="+page_number+"&PageSize=10&OrderBy=AccountMasterId desc&Search=AccountName like '%"+search_input+"%'")).then(function (response) {
			
            vm.account_list = response.data.listdata;
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
	vm.dbdata.AccountMaster={};
	vm.dbdata.AccountMaster.AccountMasterId=0;
	
}

    this.addAccount = function (info) {
        $http.post('php/DyamicOperation.php', vm.dbdata).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("create_account_info_frm").reset();
            $('#create_account_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);

        });
    };

    this.edit_item_info = function (AccountMasterId) {
        $http.get('php/DyamicOperation.php?getObject=AccountMaster&PrimaryKey=AccountMasterId&PrimaryValue='+  AccountMasterId).then(function (response) {
			console.log( 'two');
             vm.dbdata.AccountMaster= response.data;
			 console.log( vm.dbdata);
        });
    };


    this.updateAccount = function () {
        $http.post('php/DyamicOperation.php', vm.dbdata).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            $('#edit_item_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);
        });
    };


   


    this.deleteObject = function (AccountMasterId) {
		         var yesno = confirm('Are you sure remove Record?');
                if (yesno == true) {
        $http.get('php/DyamicOperation.php?deleteObject=AccountMaster&PrimaryKey=AccountMasterId&PrimaryValue='+ AccountMasterId).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.loadData($scope.currentPage);
        });
				}
    };


});

