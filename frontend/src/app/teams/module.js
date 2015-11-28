angular.module("teams", [
  "ui.router",
  "restangular",
  "shared"
])

.config(['$stateProvider', function($stateProvider) {
  $stateProvider
    .state('teams', {
      url: "/team",
      abstract: true,
      template: "<div ui-view></div>"
    })
    .state('teams.invite', {
      url: "/invite",
      templateUrl: "teams/invite.html",
      controller: "TeamsInviteController as ctrl"
    })
}]);
