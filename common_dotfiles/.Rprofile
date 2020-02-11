local({
  repos <- c(CRAN = "https://cloud.r-project.org", download.file.method = 'libcurl')
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
})
