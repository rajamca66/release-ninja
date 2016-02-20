(function(app) {
  app.directive("app", function() {
    return {
      restrict: "C",
      templateUrl: "app.html",
      controllerAs: "ctrl",
      controller: ["User", "SideMenu", function(User, SideMenu) {
        this.user = User.getUser();
        this.sideMenuItems = SideMenu.getItems;
      }]
    };
  })
})(angular.module("app"));
