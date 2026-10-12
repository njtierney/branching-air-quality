# Fitting several models at once, outside the pipeline, before branching.
# Run with Sys.setenv(TAR_PROJECT = "finish"), after one tar_make().
source(here::here("finish/packages.R"))
tar_source("finish/R")
tar_load(air_complete)

models <- c("ozone ~ temp", "ozone ~ wind", "ozone ~ temp + wind")

# The same function once per formula. lapply() and map() both return a list.
fits <- lapply(models, \(model) fit_ozone(air_complete, model))
fits <- map(models, \(model) fit_ozone(air_complete, model))

# map2() walks along two lists together: each fit with its own formula.
fits_glance <- map2(fits, models, glance_fit)
list_rbind(fits_glance)

fits_predictions <- map2(
  fits,
  models,
  \(fit, model) predict_ozone(air_complete, fit, model)
)

list_rbind(fits_predictions) |>
  ggplot(aes(x = pred, y = resid)) +
  geom_hline(yintercept = 0) +
  geom_point() +
  facet_wrap(~model)
