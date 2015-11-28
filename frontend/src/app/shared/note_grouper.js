angular.module("shared").service("NoteGrouper", function() {
  /**
   * Group a set of notes by date and by severity level.
   *
   * This will return an array of arrays in the format:
   *  [ [date, grouping], ..., [date, grouping] ]
   */
  return function(notes) {
    var grouped = _(notes).groupBy(function(n) {
      var d = new Date(n.created_at);
      d.setHours(0);
      d.setMinutes(0);
      d.setSeconds(0);
      return d;
    });

    grouped = grouped.map(function(group, date) {
      var groupedBySeverity = _(group).groupBy("level").value();
      // wrap in a new date or else it just becomes a string because of lodash
      return [new Date(date), groupedBySeverity];
    }).reverse();

    grouped = grouped.sortBy(function(grouped) {
      return grouped[0];
    }).reverse();

    return grouped.value();
  }
});
