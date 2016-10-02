(function(app) {
  app.service("User", ["$window", function($window) {
    var service = {
      isLoggedIn: isLoggedIn,
      getUser: getUser
    };
    return service;

    function getUser() {
      return $window.current_user;
    }

    function isLoggedIn() {
      return !!$window.current_user;
    }
  }]);
})(angular.module("shared"));
