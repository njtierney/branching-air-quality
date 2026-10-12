# Run with Sys.setenv(TAR_PROJECT = "finish"), from the repository root.
source(here::here("finish/packages.R"))
tar_source("finish/R")

tar_assign({
  # ---- every month, read together ----
  # tar_files_input() lists the folder when this script is read, so a new
  # month is noticed on the next tar_make(). It makes two targets:
  # air_files_files, the list of paths, and air_files, one branch per path.
  air_files <- dir_ls("finish/data-raw/monthly") |> tar_files_input()
  # air_files without a pattern is every path, so read_air() reads them all.
  air <- read_air(air_files) |> tar_target()
  # Only the days with every measurement, so every model is fitted to the
  # same days and their AIC and BIC can be compared.
  air_complete <- drop_na(air) |> tar_target()

  # ---- one branch per model ----
  ozone_models <- c(
    "ozone ~ temp",
    "ozone ~ wind",
    "ozone ~ temp + wind",
    "ozone ~ temp + wind + solar_r"
  ) |>
    tar_target()
  # A model isn't a row of a data frame, so its branches are kept as a list.
  ozone_fit <- fit_ozone(air_complete, ozone_models) |>
    tar_target(pattern = map(ozone_models), iteration = "list")
  # map() over two targets pairs them up: each fit with its own formula.
  ozone_fit_glance <- glance_fit(ozone_fit, ozone_models) |>
    tar_target(pattern = map(ozone_fit, ozone_models))
  ozone_predictions <- predict_ozone(air_complete, ozone_fit, ozone_models) |>
    tar_target(pattern = map(ozone_fit, ozone_models))

  # ---- report ----
  gg_ozone_residuals <- tar_target(
    ggplot(ozone_predictions, aes(x = pred, y = resid)) +
      geom_hline(yintercept = 0) +
      geom_point() +
      facet_wrap(~model)
  )

  report <- tar_quarto(path = "finish/report.qmd")
})
