(function() {
  var Ctrl = function($scope, project, reviewers, toaster) {
    var self = this;
    self.project = project;
    self.reviewers = reviewers;

    self.addReviewer = function(params) {
      reviewers.post(params).then(function(reviewer) {
        $scope.showNew = false;
        self.newReviewer = {};
        self.reviewers.push(reviewer);
        toaster.pop("success", "Reviewer Added");
      });
    };

    self.remove = function(reviewer) {
      reviewer.remove().then(function() {
        _.remove(self.reviewers, (function(e) {
          return e.email == reviewer.email;
        }));

        toaster.pop("success", "Reviewer Removed");
      });
    };
  };

  Ctrl.$inject = ["$scope", "project", "reviewers", "toaster"];

  angular.module("projects").controller('ProjectsWorkflowController', Ctrl);
})();
