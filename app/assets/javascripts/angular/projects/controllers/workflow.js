(function() {
  WorkflowCtrl.$inject = ["$scope", "project", "reviewers", "toaster", "SideMenu", "$state"];
  function WorkflowCtrl($scope, project, reviewers, toaster, SideMenu, $state) {
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

    self.autoNotifyChanged = function() {
      self.project.save().then(function() {
        toaster.pop("success", "Auto Notify Saved");
      }, function() {
        toaster.pop("error", "Error Saving Auto Notify");
      });
    };

    SideMenu.addItem("Edit Project", function() {
      $state.go("projects.edit", { id: self.project.id });
    });

    SideMenu.addItem("Back to Project", function() {
      $state.go("projects.show", { id: self.project.id });
    });
  };

  angular.module("projects").controller('ProjectsWorkflowController', WorkflowCtrl);
})();
