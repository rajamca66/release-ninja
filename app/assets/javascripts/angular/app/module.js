/*
 = require_self
 = require_tree .
 */

angular.module("app", ["ui.router", "shared"])

.run(["$rootScope", "SideMenu", "User", "$state", function($rootScope, SideMenu, User, $state) {
  $rootScope.$on("$stateChangeStart", function(event, toState) {
    if (!User.isLoggedIn() && toState.name !== "login") {
      event.preventDefault();
      $state.go("login");
    }
  });

  $rootScope.$on("$stateChangeSuccess", function() {
    SideMenu.clear();
  });
}])

.config(['$stateProvider', function($stateProvider) {
  $stateProvider
    .state('login', {
      url: "/login",
      templateUrl: "login.html"
    });
}]);
