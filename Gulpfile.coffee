# Load all required libraries
gulp = require 'gulp'
sass = require 'gulp-sass'
prefix = require('gulp-autoprefixer');

# Create CSS from Sass
gulp.task 'css', ->
  gulp.src '_sass/*.scss'
  .pipe sass()
  .pipe prefix("last 1 version", "> 1%", "ie 8", "ie 7")
  .pipe gulp.dest 'css'

# Default executes all dependencies
gulp.task 'default', ['css']