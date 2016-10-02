'use strict';

var path = require('path');
var gulp = require('gulp');
var conf = require('./conf');
var mainBowerFiles = require('main-bower-files');

var $ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'del']
});

gulp.task('fonts', function () {
  return gulp.src(mainBowerFiles({
      paths: {
        bowerDirectory: conf.paths.bower,
        bowerJson: '../bower.json',
        bowerrc: '../.bowerrc'
      }
    }))
    .pipe($.filter('**/*.{eot,svg,ttf,woff,woff2}'))
    .pipe($.flatten())
    .pipe(gulp.dest(path.join(conf.paths.dist, '/fonts/')));
});

gulp.task('clean', function () {
  return $.del([path.join(conf.paths.dist, '/'), path.join(conf.paths.tmp, '/')]);
});

gulp.task('build', ['scripts', 'styles', 'fonts']);
