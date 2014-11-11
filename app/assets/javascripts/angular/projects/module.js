/*
 = require_self
 = require_tree .
 */

angular.module("projects", [
  "ui.router",
  "restangular",
  "shared"
])

.config(['$stateProvider', function($stateProvider) {
  $stateProvider
    .state('projects', {
      url: "/projects",
      abstract: true,
      template: "<div ui-view></div>"
    })
    .state('projects.list', {
      url: "",
      templateUrl: "projects/list.html",
      controller: "ProjectsListController as ctrl",
      resolve: {
        projects: function(Restangular) {
          return Restangular.all("projects").getList();
        }
      }
    })
    .state('projects.new', {
      url: "/new",
      templateUrl: "projects/new.html",
      controller: "ProjectsNewController as ctrl"
    })
    .state('projects.show', {
      url: "/:id",
      templateUrl: "projects/show.html",
      controller: "ProjectsShowController as ctrl",
      resolve: {
        project: function(Restangular, $stateParams) {
          return Restangular.one("projects", $stateParams.id).get();
        },
        notes: function(Restangular, $stateParams) {
          return Restangular.one("projects", $stateParams.id).all("notes").getList();
        }
      }
    })
}]);
