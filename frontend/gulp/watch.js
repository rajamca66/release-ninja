'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var runSequence = require('run-sequence').use(gulp);
var $ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'del']
});
var fs = require('fs');

gulp.task('watch:clean:styles', function () {
  return $.del(path.join(conf.paths.dist, '/styles'));
});

gulp.task('watch:clean:scripts', function () {
  return $.del(path.join(conf.paths.dist, '/scripts'));
});

gulp.task('watch', ['build:watching'], function () {
  $.livereload.listen();

  gulp.watch([
    path.join(conf.paths.src, '/stylesheets/**/*.scss')
  ], function() {
    runSequence('watch:clean:styles', 'styles', 'revision', 'files:move', function() {
      // this is technically static while watching, but
      fs.readFile(path.join(conf.paths.dist, 'rev-manifest.json'), 'utf8', function(err, contents) {
        let blob = JSON.parse(contents);
        let path = blob['styles/application.css'];
        console.log("Reloading", path);
        $.livereload.changed(path); // hot reload the CSS
      });
    });
  });

  gulp.watch([
    path.join(conf.paths.src, '/**/*.html.slim'),
    path.join(conf.paths.src, '/**/*.js')
  ], function() {
    runSequence('watch:clean:scripts', 'scripts', 'revision', 'files:move', function() {
      $.livereload.reload(); // full page refresh, cannot be hot reloaded
    })
  });
});
