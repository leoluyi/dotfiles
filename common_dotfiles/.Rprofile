# https://csgillespie.github.io/efficientR/3-3-r-startup.html#rprofile)
# On start-up R will look for the R-Profile in the following places:
# 1. `R_HOME`: the directory in which R is installed. Find out where your R_HOME with the `R.home()` command.
# 2. `HOME`, the user's home directory. Can ask R where this is with, `path.expand("~")`
# 3. R's current working directory. This is reported by `getwd()`.

# Site-wide .Rprofile:
# ```
# site_path = R.home(component = "home")
# fname = file.path(site_path, "etc", "Rprofile.site")
# ```

local({
  # Set CRAN repo
  repos <- c(CRAN = "https://cran.rstudio.com")
  if (.Platform$OS.type == "windows") {
    repos["CRANextra"] <- "https://www.stats.ox.ac.uk/pub/RWin"
  }
  options(repos = c(repos, getOption("repos")))

  # Configure httr to perform out-of-band authentication if HTTR_LOCALHOST
  # is not set since a redirect to localhost may not work depending upon
  # where this Docker container is running.
  if(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) {
    options(httr_oob_default = TRUE)
  }

  try(dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE))
  .libPaths(c(Sys.getenv("R_LIBS_USER"),.libPaths()))

  # Disable stringsAsFactors
  options(stringsAsFactors=FALSE)

  # Prompt display
  options(prompt="#> ")
})
