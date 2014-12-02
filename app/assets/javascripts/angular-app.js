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
 = require ./angular/shared/module
 = require ./angular/projects/module
 = require ./angular/teams/module
 = require_self
 */

_.mixin(_.str.exports());

var APP = angular.module('CustomerKnow', [
  'ui.router',
  'templates',
  'restangular',
  'projects',
  'teams',
  'ngSanitize',
  'toaster',
  'ngAutodisable'
]);

APP.config(['$urlRouterProvider', '$locationProvider', 'RestangularProvider',
  function($urlRouterProvider, $locationProvider, RestangularProvider) {
    RestangularProvider.setBaseUrl("/api");
    RestangularProvider.setDefaultRequestParams({format: "json"});

    $locationProvider.html5Mode(true);
    $urlRouterProvider.otherwise("/projects");
  }]);
