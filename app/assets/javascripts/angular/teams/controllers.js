(function() {
  InviteCtrl.$inject = ["$scope", "Restangular", "toaster"];

  function InviteCtrl($scope, Restangular, toaster) {
    var self = this;

    self.sendInvite = function(to) {
      return Restangular.all("invites").post({to: to}).then(function(invite) {
        $scope.invite = {};
        toaster.pop('success', "Invited", "We've invited " + invite.to);
      }).catch(function(resp) {
        var errors = _(resp.data.errors);
        var msg = errors.mapValues(function(v) { return v.join(", "); })
                        .map(function(v, k) { return k + " " + v; })
                        .value()
                        .join("\n");

        toaster.pop('error', "Not Invited", _.humanize(msg));
      });
    };
  }

  angular.module("teams").controller("TeamsInviteController", InviteCtrl);
})();
