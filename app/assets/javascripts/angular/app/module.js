/*
 = require_self
 = require_tree .
 */

angular.module("app", ["ui.router"])
  .run(["$rootScope", "SideMenu", function($rootScope, SideMenu) {
    $rootScope.$on("$stateChangeSuccess", function() {
      SideMenu.clear();
    });
  }]);
