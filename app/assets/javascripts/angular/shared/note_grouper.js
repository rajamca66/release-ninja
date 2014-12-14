angular.module("shared").service("NoteGrouper", function() {
  /**
   * Group a set of notes by date and by severity level.
   *
   * This will return an array of arrays in the format:
   *  [ [date, grouping], ..., [date, grouping] ]
   */
  return function(notes) {
    grouped = _(notes).groupBy(function(n) {
      return new Date(n.created_at).toDateString();
    });

    grouped = grouped.map(function(group, date) {
      var groupedBySeverity = _(group).groupBy("level").value();
      return [date, groupedBySeverity];
    });

    return grouped.value();
  }
});
