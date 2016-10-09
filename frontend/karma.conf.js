'use strict';

/**
 * Setup the Karma runner with vendor files and specs
 *
 * Due to basePath resolution, it must be in this directory and not inside of gulp.
 **/
let conf = require('./gulp/conf');
let path = require('path');
let mainBowerFiles = require('main-bower-files');

let vendorFiles = mainBowerFiles({
  includeDev: true,
  paths: {
    bowerDirectory: conf.paths.bower,
    bowerJson: '../bower.json',
    bowerrc: '../.bowerrc'
  },
  overrides: {
    "angular-autodisable": {
      "main": "angular-autodisable.min.js"
    }
  }
}).filter(fileName => fileName.endsWith(".js"));

module.exports = function(config) {
  config.set({
    browsers: ['Chrome'],
    frameworks: ['jasmine'],
    basePath: conf.paths.src,
    files: vendorFiles.concat([
      'javascripts/**/module.js',
      'javascripts/**/*.js',
      'javascript_tests/**/*.spec.js'
    ])
  });
};
