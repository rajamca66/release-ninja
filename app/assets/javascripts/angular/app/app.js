(function(app) {
  app.directive("app", function() {
    return {
      restrict: "C",
      templateUrl: "app.html",
      controllerAs: "ctrl",
      controller: ["$window", "SideMenu", function($window, SideMenu) {
        this.user = $window.current_user;
        this.sideMenuItems = SideMenu.getItems;
      }]
    };
  })
})(angular.module("app"));
