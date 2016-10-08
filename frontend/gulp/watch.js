'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var runSequence = require('run-sequence').use(gulp);

gulp.task('watch', ['build:development'], function () {
  gulp.watch([
    path.join(conf.paths.src, '/stylesheets/**/*.scss')
  ], function() {
    runSequence('styles', 'revision', 'files:move');
  });

  gulp.watch([
    path.join(conf.paths.src, '/**/*.html.slim'),
    path.join(conf.paths.src, '/**/*.js')
  ], function() {
    runSequence('scripts', 'revision', 'files:move')
  });
});
