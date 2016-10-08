'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var runSequence = require('run-sequence').use(gulp);

function isOnlyChange(event) {
  return event.type === 'changed';
}

gulp.task('watch', function () {
  gulp.watch([
    path.join(conf.paths.src, '/stylesheets/**/*.scss')
  ], function() {
    runSequence('clean:styles', 'styles', 'revision', 'files:move');
  });


  gulp.watch([
    path.join(conf.paths.src, '/**/*.html.slim'),
    path.join(conf.paths.src, '/**/*.js')
  ], function() {
    runSequence('clean:scripts', 'scripts', 'revision', 'files:move')
  });
});
