'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');

var browserSync = require('browser-sync');

var $ = require('gulp-load-plugins')();

gulp.task('markups', ['slim']);

gulp.task('slim', function() {
  function renameToHtml(path) {
    path.dirname = path.dirname.substring(10);
    path.basename = path.basename.split(".html")[0];
    path.extname = '.html';
  }

  return gulp.src(path.join(conf.paths.src, '/app/**/*.slim'))
    .pipe($.cached('slim'))
    .pipe($.slim({
      options: [
        "code_attr_delims={'(' => ')', '[' => ']'}",
        "attr_list_delims={'(' => ')', '[' => ']'}"
      ]
    }))
    .pipe($.rename(renameToHtml))
    .pipe(gulp.dest(path.join(conf.paths.tmp, '/serve/')))
    .pipe(browserSync.stream());
});

