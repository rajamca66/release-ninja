angular.module("workflows", [
  "ui.router",
  "restangular",
  "shared"
])

  .config(['$stateProvider', function($stateProvider) {
    $stateProvider
      .state('workflow', {
        url: "/workflow",
        abstract: true,
        template: "<div ui-view></div>"
      })
      .state('workflow.reviews', {
        url: "/review?project_id&repository_id&pull_request_id",
        templateUrl: "workflows/review.html",
        controller: "WorkflowReviewController as ctrl",
        resolve: {
          repository: ["Restangular", "$stateParams", function(Restangular, $stateParams) {
            return Restangular.one("repositories", $stateParams.repository_id).get();
          }],
          project: ["Restangular", "$stateParams", function(Restangular, $stateParams) {
            return Restangular.one("projects", $stateParams.project_id).get();
          }]
        }
      });
  }]);
