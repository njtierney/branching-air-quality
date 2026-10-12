# One linear model of ozone, from a formula written as text, like
# "ozone ~ temp".
fit_ozone <- function(air, model) {
  lm(as.formula(model), data = air)
}
