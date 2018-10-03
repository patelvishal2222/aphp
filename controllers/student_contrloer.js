//Reference File app.js
//https://stackoverflow.com/questions/24248098/angularjs-dynamic-form-from-json-data-different-types
myApp.controller('student_contrloer', function ($scope, $state, $http, $location) {
    var vm = this;
		vm.dbdata={};
    $scope.currentPage = 1;
    $scope.maxSize = 3;
    this.search_data = function (search_input) {
        if (search_input.length >= 0)
            vm.loadData(1);

    };

    this.loadData = function (page_number) {
        var search_input = document.getElementById("search_input").value;
        $http.get(encodeURI("php/DyamicOperation.php?List=1&Sql=select *  from  students&TableName=students&Page="+page_number+"&PageSize=10&OrderBy=student_id desc&Search=student_name like '%"+search_input+"%'")).then(function (response) {
            vm.student_list = response.data.listdata;
            $scope.total_row = response.data.total;
        });
    };

    $scope.$watch('currentPage + numPerPage', function () {

        vm.loadData($scope.currentPage);

        var begin = (($scope.currentPage - 1) * $scope.numPerPage)
                , end = begin + $scope.numPerPage;


    });
//    

    this.addStudent = function (info) {
        $http.post('php/student/insert.php', info).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            document.getElementById("create_student_info_frm").reset();
            $('#create_student_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);

        });
    };

    this.edit_student_info = function (student_id) {
        $http.get('php/DyamicOperation.php?getObject=students&PrimaryKey=student_id&PrimaryValue='+ student_id).then(function (response) {
             vm.dbdata.students  = response.data;
			 console.log(vm.dbdata);
			 console.log(vm.dbdata.students.student_id);
        });
    };


    this.updateStudent = function () {
		console.log(vm.dbdata);
        $http.post('php/DyamicOperation.php',vm.dbdata).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            $('#edit_student_info_modal').modal('toggle');
            vm.loadData($scope.currentPage);
        });
    };


    this.get_student_info = function (student_id) {
        $http.get('php/DyamicOperation.php?getObject=students&PrimaryKey=student_id&PrimaryValue='+ student_id).then(function (response) {
            vm.view_student_info = response.data;


        });
    };


    this.delete_student_info = function (student_id) {
        $http.get('php/DyamicOperation.php?deleteObject=students&PrimaryKey=student_id&PrimaryValue='+ student_id).then(function (response) {
            vm.msg = response.data.message;
            vm.alert_class = 'custom-alert';
            vm.loadData($scope.currentPage);
        });
    };


});

