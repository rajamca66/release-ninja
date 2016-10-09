_.mixin(_.str.exports());

angular.module('CustomerKnow', [
  'app',
  'ui.bootstrap',
  'ui.router',
  'templates',
  'restangular',
  'projects',
  'teams',
  'workflows',
  'ngSanitize',
  'toaster',
  'ngAutodisable'
]).

config(['$urlRouterProvider', '$locationProvider', 'RestangularProvider',
function($urlRouterProvider, $locationProvider, RestangularProvider) {
  RestangularProvider.setBaseUrl("/api");
  RestangularProvider.setDefaultRequestParams({format: "json"});

  $locationProvider.html5Mode(true);
  $urlRouterProvider.otherwise("/projects");
}]).

run(['$rootScope', '$stateParams', '$state',
function($rootScope, $stateParams, $state) {
  $rootScope.$state = $state;
  $rootScope.$stateParams = $stateParams;
}]);
