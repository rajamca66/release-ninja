(function() {
  var ReviewCtrl = function($scope, Restangular, toaster, $stateParams, project, repository) {
    var self = this;
    self.pull_request_id = "#" + $stateParams.pull_request_id;
    self.pull_request_url = repository.url + "/pull/" + $stateParams.pull_request_id;
    self.project = project;

    self.process = function() {
      var params = {
        project_id: project.id,
        repository_id: repository.id,
        pull_request_id: $stateParams.pull_request_id
      };

      return Restangular.all("reviews").post(params).then(function(data) {
        toaster.pop("success", "Success!", data.message);
        self.finished = true;
      }, function(e) {
        toaster.pop("error", "Oh no!", e.data.message);
      });
    };
  };

  ReviewCtrl.$inject = ["$scope", "Restangular", "toaster", "$stateParams", "project", "repository"];

  angular.module("workflows").controller("WorkflowReviewController", ReviewCtrl);
})();
