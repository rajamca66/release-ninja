(function() {
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
  NewCtrl.$inject = ["$scope", "Restangular", "$state"];

  angular.module("projects").controller('ProjectsNewController', NewCtrl);
})();
