(function(app) {
  app.directive("app", function() {
    return {
      restrict: "C",
      templateUrl: "app.html",
      controllerAs: "ctrl",
      controller: function($window) {
        this.user = $window.current_user;
      }
    };
  })
})(angular.module("app"));
