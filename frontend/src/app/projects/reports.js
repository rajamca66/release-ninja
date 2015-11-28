angular.module("projects").directive("reportsList", function() {
  return {
    restrict: "E",
    templateUrl: "reports/list.html",
    scope: {
      project: '=',
      selectedNotes: '=',
      selectedMode: '=',
      selection: '='
    },
    replace: true,
    controller: ['$scope', function($scope) {
      $scope.project.all("reports").getList().then(function(reports) {
        $scope.reports = reports;
      });

      $scope.createReport = function(data) {
        $scope.project.all("reports").post(data).then(function(report) {
          $scope.reports.unshift(report);
          $scope.new = false;
        });
      };

      $scope.selection = function(note, remove, $event) {
        $event.stopPropagation();

        if (remove == false) {
          addNote($scope.selectedReport, note);
        } else {
          removeNote($scope.selectedReport, note);
        }
      };

      $scope.toggleSelection = function(report) {
        $scope.selectedMode = true;
        $scope.selectedReport = report;
        $scope.selectedNotes = _(report.notes);
      };

      $scope.finishSelection = function() {
        $scope.selectedReport = null;
        $scope.selectedNotes = [];
        $scope.selectedMode = false;
      };

      function addNote(report, note) {
        report.customPOST({ note_id: note.id }, "add_note").then(function() {
          $scope.selectedNotes.push(note);
        });
      }

      function removeNote(report, note) {
        report.customDELETE("remove_note", { note_id: note.id }).then(function() {
          $scope.selectedNotes.remove({id: note.id});
        });
      }
    }]
  }
});
