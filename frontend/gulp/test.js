var gulp = require('gulp');
var karma = require('karma').Server;

/**
 * Run test once and exit
 */
gulp.task('test', function (done) {
  karma.start({
    configFile: __dirname + '/../karma.conf.js',
    singleRun: true
  }, function() {
    done();
  });
});

gulp.task('tdd', function (done) {
  new karma({
    configFile: __dirname + '/../karma.conf.js'
  }, done).start();
});
