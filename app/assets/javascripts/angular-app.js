/*
 ==== Standard ====
 = require jquery
 = require bootstrap

 ==== Angular ====
 = require angular

 ==== Angular Plugins ====
 = require lodash
 = require restangular
 = require angular-ui-router

 = require ./angular/templates
 = require ./angular/shared/module
 = require ./angular/projects/module
 = require_self
 */

var APP = angular.module('CustomerKnow', [
  'ui.router',
  'templates',
  'restangular',
  'projects'
]);

APP.config(['$urlRouterProvider', '$locationProvider', 'RestangularProvider',
  function($urlRouterProvider, $locationProvider, RestangularProvider) {
    RestangularProvider.setBaseUrl("/api");
    RestangularProvider.setDefaultRequestParams({format: "json"});

    $locationProvider.html5Mode(true);
    $urlRouterProvider.otherwise("/projects");
  }]);
