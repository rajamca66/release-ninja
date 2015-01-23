(function() {
  var ListCtrl = function(projects, $scope, $state) {
    this.projects = projects;

    if(projects.length == 0) {
      $state.go("projects.new")
    }
  };

  var NewCtrl = function($scope, Restangular, $state) {
    var self = this;
    $scope.data = {};

    Restangular.all("github/repositories").getList().then(function(repos) {
      self.repos = repos;
    });

    // Checkbox inputs product an object which has falsy values
    // This will remove those so only the true keys are left
    $scope.$watch('data.repos', function(repos) {
      _.each(repos, function(value, key) {
        if (!value) {
          delete repos[key];
        }
      });
    }, true);

    $scope.create = function(data) {
      var postData = cleanCloneData(data);
      $scope.processing = true;

      Restangular.all("projects").post(postData).then(function(project) {
        $state.go("projects.list");
      }).finally(function() {
        $scope.processing = false;
      });
    };

    $scope.isValid = function(data) {
      var data = cleanCloneData(data);
      return data.title && data.repos && data.repos.length > 0;
    };

    function cleanCloneData(data) {
      var clone = _.clone(data);
      clone.repos = _.keys(clone.repos);
      return clone;
    }
  };

  var ShowCtrl = function($scope, project, notes, NoteGrouper, $filter, $location, $anchorScroll, $timeout) {
    var self = this;
    this.project = project;
    this.notes = notes.plain();
    this.groupedNotes = NoteGrouper(this.notes);

    if ($location.hash()) {
      $timeout(function() {
        $anchorScroll();
      }, 500);
    }

    this.severityLevels = {
      feature: "Feature",
      fix: "Fix"
    };

    this.save = function(note) {
      self.project.one("notes", note.id).customPUT(note).then(function() {
        self.project.one("notes", note.id).get().then(function(note) {
          replaceNote(note);
        });
      });
    };

    this.new = function(note) {
      self.project.all("notes").post(note).then(function(createdNote) {
        $scope.newNote = false;
        self.notes.push(createdNote);
        resetGroupedNotes();
      });
    };

    this.remove = function(note) {
      self.project.one("notes", note.id).remove().then(function() {
        _.remove(self.notes, {id: note.id});
        resetGroupedNotes();
      });
    };

    this.anyPublished = function(notes) {
      return _(notes).any({published: true});
    };

    $scope.$watch('filterTitle', function() {
      resetGroupedNotes();
    });

    function replaceNote(note) {
      var index = _(self.notes).findIndex({id: note.id});
      self.notes[index] = note;
      self.groupedNotes = NoteGrouper(self.notes);
      resetGroupedNotes();
    }

    function resetGroupedNotes() {
      if($scope.filterTitle) {
        var title = $scope.filterTitle.toLowerCase();
        var notes = $filter('filter')(self.notes, function(note) {
          return note.title.toLowerCase().indexOf(title) > -1 || note.markdown_body.toLowerCase().indexOf(title) > -1;
        });
        self.groupedNotes = NoteGrouper(notes);
      } else {
        self.groupedNotes = NoteGrouper(self.notes);
      }
    }
  };

  var EditCtrl = function($scope, project, hooks, toaster) {
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
  };

  ListCtrl.$inject = ["projects", "$scope", "$state"];
  NewCtrl.$inject = ["$scope", "Restangular", "$state"];
  ShowCtrl.$inject = ["$scope", "project", "notes", "NoteGrouper", "$filter", "$location", "$anchorScroll", "$timeout"];
  EditCtrl.$inject = ["$scope", "project", "hooks", "toaster"];

  angular.module("projects").controller('ProjectsListController', ListCtrl)
                            .controller('ProjectsNewController', NewCtrl)
                            .controller('ProjectsShowController', ShowCtrl)
                            .controller('ProjectsEditController', EditCtrl);
})();
