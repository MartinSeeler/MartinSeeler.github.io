gulp = require("gulp")
browserSync = require("browser-sync")
sass = require("gulp-sass")
prefix = require("gulp-autoprefixer")
cp = require("child_process")
concat = require("gulp-concat")
messages = jekyllBuild: "<span style=\"color: grey\">Running:</span> $ jekyll build"
bowerSrc = require("gulp-bower-src")


### build jekyll ###
gulp.task "jekyll-build", (done) ->
  browserSync.notify messages.jekyllBuild
  cp.spawn("jekyll", ["build"],
    stdio: "inherit"
  ).on "close", done


### rebuild jekyll ###
gulp.task "jekyll-rebuild", ["jekyll-build"], ->
  browserSync.reload()
  return


### snychronize rebuild of jekyll and browser refresh ###
gulp.task "browser-sync", [
  "sass"
  "jekyll-build"
], ->
  browserSync server:
    baseDir: "_site"
  return


### compile files from _sass into both _site/css (for live injecting) and site (for future jekyll builds) ###
gulp.task "sass", ->
  gulp.src("_sass/main.scss").pipe(sass(
    includePaths: ["scss"]
    onError: browserSync.notify
  )).pipe(prefix([
    "last 15 versions"
    "> 1%"
    "ie 8"
    "ie 7"
  ],
    cascade: true
  )).pipe(gulp.dest("_site/css")).pipe(browserSync.reload(stream: true)).pipe gulp.dest("css")
  return


### copy bower resources to lib ###
gulp.task "bower", ->
  bowerSrc().pipe gulp.dest("libs")
  return


### copy vendor js scripts from bower ###
gulp.task "vendor", ->
  gulp.src("bower_components/jquery/dist/*", "bower_components/bootstrap-sass-official/assets/javascripts/*").pipe gulp.dest("js/vendors")


### watch everything and rebuild + sync ###
gulp.task "watch", ->
  gulp.watch "_sass/*.scss", ["sass"]
  gulp.watch [
    "index.html"
    "theme.html"
    "_layouts/*.html"
    "_includes/*.html"
    "_drafts/*"
    "_posts/*"
    "_config.yml"
  ], ["jekyll-rebuild"]
  return


### default task when running just `gulp` ###
gulp.task "default", [
  "bower"  
  "browser-sync"
  "watch"
]