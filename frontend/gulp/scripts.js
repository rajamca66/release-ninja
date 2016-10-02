'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var merge = require('merge-stream');
var mainBowerFiles = require('main-bower-files');

var $ = require('gulp-load-plugins')();

gulp.task('scripts', ['markups'], function() {
  return merge(
      getApplicationJSStream(),
      getVendorJSStream()
    )
    .pipe($.sourcemaps.init())
    .pipe($.order([
      'vendor.js',
      'application.js'
    ]))
    .pipe($.concat('application.js'))
    .pipe($.uglify())
    .pipe($.sourcemaps.write())
    .pipe($.rev())
    .pipe(gulp.dest(path.join(conf.paths.dist, '/scripts')));
});

function getApplicationJSStream() {
  return gulp.src([
      path.join(conf.paths.src, '/javascripts/angular/**/*.js'),
      path.join(conf.paths.tmp, '/templateCacheHtml.js'),
      path.join(conf.paths.src, '/javascripts/angular-app.js')
    ])
    .pipe($.sourcemaps.init())
    .pipe($.eslint())
    .pipe($.eslint.format())
    .pipe($.size())
    .pipe($.order([
      "**/module.js",
      'templateCacheHtml.js',
      "!angular-app.js",
      "angular-app.js"
    ]))
    .pipe($.concat('application.js'));
}

function getVendorJSStream() {
  return gulp.src(mainBowerFiles({
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
    }))
    .pipe($.filter("**/*.js"))
    .pipe($.concat('vendor.js'));
}
