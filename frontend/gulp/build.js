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

gulp.task('build:revision', ['build'], function () {
    // by default, gulp would pick `assets/css` as the base,
    // so we need to set it explicitly:
    return gulp.src([
        path.join(conf.paths.dist, "/scripts/application.js"),
        path.join(conf.paths.dist, "/styles/application.css"),
      ], { base: 'assets' })
        .pipe($.rev())
        .pipe(gulp.dest(conf.paths.dist))  // write rev'd assets to build dir
        .pipe($.rev.manifest())
        .pipe(gulp.dest(conf.paths.dist)); // write manifest to build dir
});

gulp.task('build:production', ['build:revision'], function() {
  return gulp.start("files:move");
});

gulp.task('files:move', $.shell.task([
  'mkdir -p ../public/scripts ../public/styles ../public/fonts',
  'rm -f ../public/scripts/* ../public/styles/* ../public/fonts/*',
  'rsync -a dist/scripts/* ../public/scripts --exclude application.js',
  'rsync -a dist/styles/* ../public/styles --exclude application.css',
  'rsync -a dist/fonts/* ../public/fonts',
]));
