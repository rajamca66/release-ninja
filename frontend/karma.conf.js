'use strict';

/**
 * Setup the Karma runner with vendor files and specs
 *
 * Due to basePath resolution, it must be in this directory and not inside of gulp.
 **/
let conf = require('./gulp/conf');
let path = require('path');
let mainBowerFiles = require('main-bower-files');
let es2015 = require('babel-preset-es2015');

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
    preprocessors: {
      'javascript_tests/**/*.spec.js': ['babel']
    },
    browsers: ['PhantomJS'],
    frameworks: ['jasmine'],
    basePath: conf.paths.src,
    files: vendorFiles.concat([
      'javascripts/**/module.js',
      'javascripts/**/*.js',
      'javascript_tests/**/*.spec.js'
    ]),
    babelPreprocessor: {
      options: {
        presets: [es2015],
        sourceMap: 'inline'
      },
      filename: function (file) {
        return file.originalPath.replace(/\.js$/, '.es5.js');
      },
      sourceFileName: function (file) {
        return file.originalPath;
      }
    },
    phantomjsLauncher: {
      // Have phantomjs exit if a ResourceError is encountered (useful if karma exits without killing phantom)
      exitOnResourceError: true
    }
  });
};
