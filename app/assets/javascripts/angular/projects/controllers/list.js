(function() {
  var ListCtrl = function(projects, $scope, $state) {
    this.projects = projects;

    if(projects.length == 0) {
      $state.go("projects.new")
    }
  };

  ListCtrl.$inject = ["projects", "$scope", "$state"];

  angular.module("projects").controller('ProjectsListController', ListCtrl);
})();
