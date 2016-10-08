'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var merge = require('merge-stream');
var sass = require('gulp-sass');

var $ = require('gulp-load-plugins')();

var _ = require('lodash');

gulp.task('styles', function() {
  return buildStyles();
});

function buildStyles() {
  return merge(
      getSASSStream(),
      getSimpleCSSStream()
    )
    .pipe($.concat('application.css'))
    .pipe($.if(conf.opts.minify, $.cleanCss()))
    .pipe($.sourcemaps.write())
    .pipe($.size())
    .pipe(gulp.dest(path.join(conf.paths.dist, '/styles')));
};

function getSimpleCSSStream() {
  return gulp.src([
    path.join(conf.paths.bower, 'angularjs-toaster/toaster.css')
  ])
    .pipe($.sourcemaps.init());
}

function getSASSStream() {
  var sassOptions = {
    outputStyle: 'expanded',
    includePaths: [
      '../vendor/assets/components'
    ]
  };

  return gulp.src([
      path.join(conf.paths.src, '/stylesheets/application.scss')
    ])
    .pipe($.sourcemaps.init())
    .pipe(sass(sassOptions).on('error', conf.errorHandler("Sass")));
}
