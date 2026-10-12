# One row per model: its formula, then how well it fits, from broom's glance().
glance_fit <- function(fit, model) {
  glance(fit) |>
    clean_names() |>
    mutate(model = model, .before = 1)
}
