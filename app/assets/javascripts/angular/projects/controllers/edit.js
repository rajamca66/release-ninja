(function() {
  EditCtrl.$inject = ["$scope", "project", "hooks", "toaster", "SideMenu", "$state"];
  function EditCtrl($scope, project, hooks, toaster, SideMenu, $state) {
    var self = this;
    self.project = project;
    self.hooks = hooks;

    self.save = function() {
      self.project.put().then(function() {
        toaster.pop("success", "Save Successful");
      });
    };

    self.installHook = function(repo_id) {
      self.project.all("hooks").customPOST({repository_id: repo_id}).then(function(newHook) {
        toaster.pop("success", "Hook Installed");
        var index = _(self.hooks).findIndex(function(hook) {
          return hook.repo_id === repo_id;
        });
        self.hooks[index] = newHook;
      }, function(error) {
        toaster.pop("error", "Hook Error", error);
      });
    };

    self.removeHook = function(id, repo_id) {
      self.project.one("hooks", id).customDELETE("", {repository_id: repo_id}).then(function(newHook) {
        var index = _(self.hooks).findIndex(function(hook) {
          return hook.repo_id === repo_id;
        });
        self.hooks[index] = newHook;
      });
    };

    SideMenu.addItem("Edit Workflow", function() {
      $state.go("projects.workflow", { id: self.project.id });
    });

    SideMenu.addItem("Back to Project", function() {
      $state.go("projects.show", { id: self.project.id });
    });
  }

  angular.module("projects").controller('ProjectsEditController', EditCtrl);
})();
