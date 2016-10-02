(function() {
  ShowCtrl.$inject = ["$scope", "project", "notes", "NoteGrouper", "$filter", "$location", "$anchorScroll", "$timeout", "SideMenu", "$state", "$window", "$stateParams"];

  function ShowCtrl($scope, project, notes, NoteGrouper, $filter, $location, $anchorScroll, $timeout, SideMenu, $state, $window, $stateParams) {
    var self = this;
    this.project = project;
    this.notes = notes.plain();
    this.groupedNotes = NoteGrouper(this.notes);
    this.currentLimit = 5;
    this.currentLane = $stateParams.filter;

    if ($location.hash()) {
      $timeout(function() {
        $anchorScroll();
      }, 500);
    }

    this.severityLevels = {
      feature: "Feature",
      enhancement: "Enhancement",
      fix: "Fix"
    };

    this.increaseLimit = function() {
      this.currentLimit += 5;
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
        $scope.note = {};
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

    this.removeNote = function(note) {
      _.remove(self.notes, {id: note.id});
      resetGroupedNotes();
    };

    function replaceNote(note) {
      var index = _(self.notes).findIndex({id: note.id});
      self.notes[index] = note;
      self.groupedNotes = NoteGrouper(self.notes);
      resetGroupedNotes();
    }
    this.replace = replaceNote;

    function resetGroupedNotes() {
      if($scope.filterTitle) {
        var title = $scope.filterTitle.toLowerCase();
        var notes = $filter('filter')(self.notes, function(note) {
          return (note.title || "").toLowerCase().indexOf(title) > -1 || (note.markdown_body || "").toLowerCase().indexOf(title) > -1;
        });
        self.groupedNotes = NoteGrouper(notes);
      } else {
        self.groupedNotes = NoteGrouper(self.notes);
      }
    }

    SideMenu.addItem("Create a New Note", function() {
      $scope.newNote = true;
    });

    SideMenu.addItem("Project Settings", function() {
      $state.go("projects.edit", { id: self.project.id });
    });

    SideMenu.addItem("Public Change Log", function() {
      $window.location.href = self.project.url;
    });

    SideMenu.addItem("Github Sync", function() {
      $state.go("projects.github_sync", { id: self.project.id });
    });
  }

  angular.module("projects").controller('ProjectsShowController', ShowCtrl);
})();
