# Load all required libraries
gulp       = require 'gulp'
sass       = require 'gulp-sass'

# Create CSS from Sass
gulp.task 'css', ->
  gulp.src '_sass/*.scss'
    .pipe sass()
    .pipe gulp.dest 'css'

# Default executes all dependencies
gulp.task 'default', ['css']