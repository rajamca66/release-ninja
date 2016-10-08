'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var runSequence = require('run-sequence').use(gulp);
var $ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'del']
});

gulp.task('watch:clean:styles', function () {
  return $.del(path.join(conf.paths.dist, '/styles'));
});

gulp.task('watch:clean:scripts', function () {
  return $.del(path.join(conf.paths.dist, '/scripts'));
});

gulp.task('watch', ['build:development'], function () {
  gulp.watch([
    path.join(conf.paths.src, '/stylesheets/**/*.scss')
  ], function() {
    runSequence('watch:clean:styles', 'styles', 'revision', 'files:move');
  });

  gulp.watch([
    path.join(conf.paths.src, '/**/*.html.slim'),
    path.join(conf.paths.src, '/**/*.js')
  ], function() {
    runSequence('watch:clean:scripts', 'scripts', 'revision', 'files:move')
  });
});
