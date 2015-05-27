gulp           = require 'gulp'
watchify       = require 'gulp-watchify'
plumber        = require 'gulp-plumber'
rename         = require 'gulp-rename'
mochaPhantomJS = require 'gulp-mocha-phantomjs'
webserver      = require 'gulp-webserver'

gulp.task 'watchify', watchify (watchify)->
  # watch src
  gulp.src 'src/main.coffee'
    .pipe plumber()
    .pipe watchify
      watch     : on
      extensions: ['.coffee', '.js']
      transform : ['coffeeify']
    .pipe rename
      extname: ".js"
    .pipe gulp.dest ''

  # watch test src
  gulp.src 'test/src/test-main.coffee'
    .pipe plumber()
    .pipe watchify
      watch     : on
      extensions: ['.coffee', '.js']
      transform : ['coffeeify']
    .pipe rename
      basename: "test-all",
      extname: ".js"
    .pipe gulp.dest 'test'

gulp.task 'test', [], ->
  gulp
    .src './test/runner.html'
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

gulp.task 'watch', ['watchify']

