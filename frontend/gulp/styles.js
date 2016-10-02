'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var merge = require('merge-stream');
var sass = require('gulp-ruby-sass');

var $ = require('gulp-load-plugins')();

var _ = require('lodash');

gulp.task('styles', function() {
  return buildStyles();
});

var buildStyles = function() {
  var sassOptions = {
    style: 'expanded',
    loadPath: [
      '../vendor/assets/components'
    ]
  };

  var src = path.join(conf.paths.src, '/stylesheets/application.scss');

  return merge(
      sass(src, sassOptions),
      gulp.src([
        '../vendor/assets/components/angularjs-toaster/toaster.css'
      ])
    )
    .pipe($.sourcemaps.init())
    .pipe($.concat('application.css'))
    .pipe($.cleanCss())
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest(path.join(conf.paths.dist, '/styles')));
};
