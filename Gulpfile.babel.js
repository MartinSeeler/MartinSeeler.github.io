const gulp = require('gulp');
const browserSync = require('browser-sync');
const sass = require('gulp-sass');
const sourcemaps = require('gulp-sourcemaps');
const gzip = require('gulp-gzip');
const plumber = require('gulp-plumber');
const uncss = require('gulp-uncss');
const prefix = require('gulp-autoprefixer');
const cp = require('child_process');

const messages = {
  jekyllBuild: '<span style="color: grey">Running:</span> $ jekyll build'
};

/**
 * Build the Jekyll Site
 */
gulp.task('jekyll-build', (done) => {
  browserSync.notify(messages.jekyllBuild);
  return cp.spawn('jekyll', ['build'], {stdio: 'inherit'})
      .on('close', done);
});

/**
 * Rebuild Jekyll & do page reload
 */
gulp.task('jekyll-rebuild', ['jekyll-build'], () => {
  browserSync.reload();
});

/**
 * Wait for jekyll-build, then launch the Server
 */
gulp.task('browser-sync', ['sass', 'jekyll-build'], () => {
  browserSync({server: {baseDir: '_site'}});
});

/**
 * Compile files from _scss into both _site/css (for live injecting) and site (for future jekyll builds)
 */
gulp.task('sass', () => {
  return gulp.src('_scss/main.scss')
      .pipe(plumber())
      .pipe(sourcemaps.init())
      .pipe(sass.sync({includePaths: ['scss'], outputStyle: 'compressed'}).on('error', sass.logError))
      .pipe(prefix(['last 5 versions', '> 5%'], {cascade: true}))
      .pipe(uncss({
        html: ['_site/**/*.html']
      }))
      .pipe(sourcemaps.write())
      .pipe(gzip())
      .pipe(gulp.dest('_site/css'))
      .pipe(browserSync.reload({stream: true}))
      .pipe(gulp.dest('css'));
});

/**
 * Watch scss files for changes & recompile
 * Watch html/md files, run jekyll & reload BrowserSync
 */
gulp.task('watch', () => {
  gulp.watch('_scss/**/*.scss', ['sass']);
  gulp.watch(['*.html', '_layouts/*.html', '_posts/*'], ['jekyll-rebuild']);
});

/**
 * Default task, running just `gulp` will compile the sass,
 * compile the jekyll site, launch BrowserSync & watch files.
 */
gulp.task('default', ['browser-sync', 'watch']);
