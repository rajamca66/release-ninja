/*
 ==== Standard ====
 = require jquery
 = require bootstrap-sass-official

 ==== Angular ====
 = require angular

 ==== Angular Plugins ====
 = require lodash
 = require restangular
 = require angular-ui-router
 = require angular-sanitize

 = require ./angular/templates
 = require ./angular/shared/module
 = require ./angular/projects/module
 = require_self
 */

var APP = angular.module('CustomerKnow', [
  'ui.router',
  'templates',
  'restangular',
  'projects',
  'ngSanitize'
]);

APP.config(['$urlRouterProvider', '$locationProvider', 'RestangularProvider',
  function($urlRouterProvider, $locationProvider, RestangularProvider) {
    RestangularProvider.setBaseUrl("/api");
    RestangularProvider.setDefaultRequestParams({format: "json"});

    $locationProvider.html5Mode(true);
    $urlRouterProvider.otherwise("/projects");
  }]);
