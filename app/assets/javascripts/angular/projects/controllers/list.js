(function() {

  ListCtrl.$inject = ["projects", "$scope", "$state", "SideMenu"];
  function ListCtrl(projects, $scope, $state, SideMenu) {
    this.projects = projects;

    if(projects.length === 0) {
      $state.go("projects.new");
    }

    SideMenu.addItem("Create Project", function() {
      return $state.go("projects.new");
    });
  }

  angular.module("projects").controller('ProjectsListController', ListCtrl);
})();
