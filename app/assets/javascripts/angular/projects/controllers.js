(function() {
  var ListCtrl = function(projects, $scope) {
    this.projects = projects;
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

  var ShowCtrl = function($scope, project, notes) {
    var self = this;
    this.project = project;
    this.notes = notes;
    this.releases = [];
    this.severityLevels = {
      major: "Major",
      minor: "Minor",
      fix: "Fix"
    };

    this.newNote = function() {
      this.notes.unshift({new: true, show: true});
    };

    this.save = function(note) {
      if (note.new) {
        self.project.all("notes").post(note).then(function(createdNote) {
          self.notes = _.map(self.notes, function(el) {
            return el == note ? createdNote : el;
          });
        });
      } else {
        note.put().then(function() {
          note.show = false;
        });
      }
    };

    this.remove = function(note) {
      self.project.one("notes", note.id).remove().then(function() {
        _.remove(self.notes, function(el) {
          return el == note;
        });
      });
    };
  };

  ListCtrl.$inject = ["projects", "$scope"];
  NewCtrl.$inject = ["$scope", "Restangular", "$state"];
  ShowCtrl.$inject = ["$scope", "project", "notes"];

  angular.module("projects").controller('ProjectsListController', ListCtrl)
                            .controller('ProjectsNewController', NewCtrl)
                            .controller('ProjectsShowController', ShowCtrl);
})();
