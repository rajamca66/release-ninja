'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');

var $ = require('gulp-load-plugins')();

gulp.task('markups', ['slim']);

gulp.task('slim', function() {
  function renameToHtml(path) {
    path.basename = path.basename.split(".html")[0];
    path.extname = '.html';
  }

  return gulp.src(path.join(conf.paths.src, '/javascripts/angular/templates/**/*.slim'))
    .pipe($.cached('slim'))
    .pipe($.slim({
      options: [
        "code_attr_delims={'(' => ')', '[' => ']'}",
        "attr_list_delims={'(' => ')', '[' => ']'}"
      ]
    }))
    .pipe($.remember('slim'))
    .pipe($.rename(renameToHtml))
    .pipe($.angularTemplatecache('templateCacheHtml.js', {
      module: 'templates',
      standalone: true
    }))
    .pipe(gulp.dest(conf.paths.tmp))
});
