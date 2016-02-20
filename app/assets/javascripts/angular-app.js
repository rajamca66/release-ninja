/*
 ==== Standard ====
 = require jquery
 = require bootstrap-sass-official/assets/javascripts/bootstrap-sprockets.js

 ==== Angular ====
 = require angular

 ==== Angular Plugins ====
 = require lodash
 = require underscore.string
 = require restangular
 = require angular-ui-router
 = require angular-sanitize
 = require angularjs-toaster
 = require angular-animate
 = require angular-autodisable

 = require ./angular/templates
 = require ./angular/app/module
 = require ./angular/shared/module
 = require ./angular/projects/module
 = require ./angular/teams/module
 = require ./angular/workflows/module
 = require_self
 */

_.mixin(_.str.exports());

angular.module('CustomerKnow', [
  'app',
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
