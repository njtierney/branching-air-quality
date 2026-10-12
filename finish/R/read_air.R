# Every month's file from the monitoring station, read into one data frame.
read_air <- function(paths) {
  read_csv(paths, show_col_types = FALSE) |>
    clean_names()
}
