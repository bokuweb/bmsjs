gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
watchify    = require 'gulp-watchify'
runSequence = require 'run-sequence' 

gulp.task 'build:coffee', ->
  gulp.src 'src/*.coffee'
    .pipe coffee()
    .pipe gulp.dest 'js'

gulp.task 'watchify', watchify (watchify)->
  gulp.src 'js/main.js'
    .pipe watchify
      watch : off
    .pipe gulp.dest './'

gulp.task 'watch', ['build:coffee'], ->
  gulp.watch 'src/*.coffee', ['watchify']
    .on 'change', ->
      runSequence 'build:coffee', 'watchify'
