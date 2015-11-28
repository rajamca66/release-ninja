_.mixin(s.exports());

angular.module('CustomerKnow', [
  'ui.router',
  'restangular',
  'ngSanitize',
  'toaster',
  'ngAutodisable',
  'shared',
  'projects',
  'teams',
  'workflows'
]).

config(function($urlRouterProvider, $locationProvider, RestangularProvider) {
  'injectjs';

  RestangularProvider.setBaseUrl("/api");
  RestangularProvider.setDefaultRequestParams({format: "json"});

  $locationProvider.html5Mode(true);
  $urlRouterProvider.otherwise("/projects");
}).

run(function($rootScope, $stateParams, $state) {
  'injectjs';

  $rootScope.$state = $state;
  $rootScope.$stateParams = $stateParams;
});
