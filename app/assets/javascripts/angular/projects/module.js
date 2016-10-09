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
        projects: ['Restangular', function(Restangular) {
          return Restangular.all("projects").getList();
        }]
      }
    })
    .state('projects.new', {
      url: "/new",
      templateUrl: "projects/new.html",
      controller: "ProjectsNewController as ctrl"
    })
    .state('projects.show', {
      url: "/:id?filter",
      templateUrl: "projects/show.html",
      controller: "ProjectsShowController as ctrl",
      resolve: {
        project: ['Restangular', '$stateParams', function(Restangular, $stateParams) {
          return Restangular.one("projects", $stateParams.id).get();
        }],
        notes: ['Restangular', '$stateParams', function(Restangular, $stateParams) {
          $stateParams.filter = $stateParams.filter || "github";
          return Restangular.one("projects", $stateParams.id).all("notes").getList({ filter: $stateParams.filter });
        }]
      }
    })
    .state("projects.edit", {
      url: "/:id/edit",
      templateUrl: "projects/edit.html",
      controller: "ProjectsEditController as ctrl",
      resolve: {
        project: ['Restangular', '$stateParams', function(Restangular, $stateParams) {
          return Restangular.one("projects", $stateParams.id).get();
        }],
        hooks: ['Restangular', '$stateParams', function(Restangular, $stateParams) {
          return Restangular.one("projects", $stateParams.id).all("hooks").getList();
        }]
      }
    })
    .state("projects.workflow", {
      url: "/:id/workflow",
      templateUrl: "projects/workflow.html",
      controller: "ProjectsWorkflowController as ctrl",
      resolve: {
        project: ['Restangular', '$stateParams', function(Restangular, $stateParams) {
          return Restangular.one("projects", $stateParams.id).get();
        }],
        reviewers: ['Restangular', '$stateParams', function(Restangular, $stateParams) {
          return Restangular.one("projects", $stateParams.id).all("reviewers").getList();
        }]
      }
    })
    .state("projects.github_sync", {
      url: "/:id/github_sync",
      templateUrl: "projects/comment_sync.html",
      controller: "CommentSyncController as ctrl",
      resolve: {
        project: ['Restangular', '$stateParams', function(Restangular, $stateParams) {
          return Restangular.one("projects", $stateParams.id).get();
        }]
      }
    });
}]);
