# Run with Sys.setenv(TAR_PROJECT = "start"), from the repository root.
source(here::here("start/packages.R"))
tar_source("start/R")

tar_assign({
  # Each target is written as: name <- command |> tar_target()
})
