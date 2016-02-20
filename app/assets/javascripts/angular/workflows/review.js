(function() {
  ReviewCtrl.$inject = ["$scope", "Restangular", "toaster", "$stateParams", "project", "repository", "$state", "SideMenu"];
  function ReviewCtrl($scope, Restangular, toaster, $stateParams, project, repository, $state, SideMenu) {
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
        toaster.pop("error", "Oh no!", data.message);
      });
    };

    SideMenu.addItem("View Project", function() {
      $state.go("projects.show", { id: self.project.id });
    });
  };

  angular.module("workflows").controller("WorkflowReviewController", ReviewCtrl);
})();
