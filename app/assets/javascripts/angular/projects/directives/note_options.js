(function(app) {
  app.component("noteOptions", {
    controllerAs: "ctrl",
    templateUrl: "projects/_note_options.html",
    bindings: {
      note: "=",
      project: "=",
      replaceNote: "=",
      removeNote: "=",
      currentLane: "="
    },
    controller: [function() {
      var self = this;

      this.publish = function() {
        self.note.published = true;
        self.save();
      }

      this.save = function() {
        self.project.one("notes", self.note.id).customPUT(self.note).then(function() {
          self.project.one("notes", self.note.id).customGET("", { filter: self.currentLane }).then(function(note) {
            self.replaceNote(note);
          }, function(err) {
            if (err.status === 404) {
              self.removeNote(self.note);
            }
          });
        });
      };

      this.emailTeam = function() {
        self.project.one("notes", self.note.id).customPOST({}, 'team_emails').then(function(emailAddresses) {
          var emailList = emailAddresses.join(', ');
          alert('Emails sent to team members: ' + emailList);
        }).catch(function() {
          alert('Error sending emails to team members.' );
        });
      };

      this.remove = function() {
        self.project.one("notes", self.note.id).remove().then(function() {
          self.removeNote(self.note);
        });
      };

      this.setLane = function(lane) {
        self.project.one("notes", self.note.id).customPUT({ published: false, filter: lane }).then(function() {
          self.project.one("notes", self.note.id).customGET("", { filter: self.currentLane }).then(function(note) {
            self.replaceNote(note);
          }, function(err) {
            if (err.status === 404) {
              self.removeNote(self.note);
            }
          });
        });
      };
    }]
  });
})(angular.module("projects"));
