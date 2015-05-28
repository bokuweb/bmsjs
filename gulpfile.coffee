gulp           = require 'gulp'
watchify       = require 'gulp-watchify'
plumber        = require 'gulp-plumber'
rename         = require 'gulp-rename'
mochaPhantomJS = require 'gulp-mocha-phantomjs'
webserver      = require 'gulp-webserver'

watching = off

gulp.task 'enable-watch-mode', -> watching = on

gulp.task 'build:app', watchify (watchify)->
  gulp.src 'src/main.coffee'
    .pipe plumber()
    .pipe watchify
      watch     : watching
      extensions: ['.coffee', '.js']
      transform : ['coffeeify']
    .pipe rename
      extname: ".js"
    .pipe gulp.dest ''

gulp.task 'build:test', watchify (watchify)->
  gulp.src 'test/src/test-main.coffee'
    .pipe plumber()
    .pipe watchify
      watch     : watching
      extensions: ['.coffee', '.js']
      transform : ['coffeeify']
    .pipe rename
      basename: "test-all",
      extname: ".js"
    .pipe gulp.dest 'test'

gulp.task 'test', ['build:test'], ->
  gulp.src './test/runner.html'
    .pipe mochaPhantomJS
      phantomjs:
        viewportSize:
          width: 800
          height: 600
        dump:'test.xml'

gulp.task 'webserver', ->
  gulp.src ''
    .pipe webserver
      directoryListing: true
      open: true

gulp.task 'build', ['build:app', 'build:test']

gulp.task 'watch:app', ['enable-watch-mode', 'build:app']

gulp.task 'watch:test', ['enable-watch-mode', 'build:test']

