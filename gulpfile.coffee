gulp        = require 'gulp'
watchify    = require 'gulp-watchify'
plumber     = require 'gulp-plumber'
rename      = require 'gulp-rename'

gulp.task 'watchify', watchify (watchify)->
  gulp.src 'src/main.coffee'
    .pipe plumber()
    .pipe watchify
      watch     : on
      extensions: ['.coffee', '.js']
      transform : ['coffeeify']
    .pipe rename
      extname: ".js"
    .pipe gulp.dest './'

gulp.task 'watch', ['watchify']

