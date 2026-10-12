# Every day the model was fitted to, with the ozone it predicts for that day
# and the residual: what was measured, minus the prediction.
predict_ozone <- function(air, fit, model) {
  air |>
    add_predictions(fit) |>
    add_residuals(fit) |>
    mutate(model = model, .before = 1)
}
