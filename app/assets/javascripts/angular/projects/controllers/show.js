(function() {
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
        $scope.note = {};
        resetGroupedNotes();
      });
    };

    this.emailTeam = function(note) {
      self.project.one("notes", note.id).customPOST({}, 'team_emails').then(function(emailAddresses) {
        var emailList = emailAddresses.join(', ');
        alert('Emails sent to team members: ' + emailList);
      }).catch(function() {
        alert('Error sending emails to team members.' );
      });
    }

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

  ShowCtrl.$inject = ["$scope", "project", "notes", "NoteGrouper", "$filter", "$location", "$anchorScroll", "$timeout"];

  angular.module("projects").controller('ProjectsShowController', ShowCtrl);
})();
