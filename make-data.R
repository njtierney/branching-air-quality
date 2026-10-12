# Writes R's airquality data (New York, May to September 1973) as one CSV a
# month, the way a monitoring station might send it. May to August go in
# data-raw/monthly/. September goes in data-raw/new/, for students to copy in
# during the lesson.
#
# Run from the root of this repository. Writes into start/, then copies the
# same files into finish/.
library(tidyverse)
library(fs)
library(here)

air <- as_tibble(airquality)

may <- air |> filter(Month == 5)
june <- air |> filter(Month == 6)
july <- air |> filter(Month == 7)
august <- air |> filter(Month == 8)
september <- air |> filter(Month == 9)

monthly_dir <- here("start/data-raw/monthly")
new_dir <- here("start/data-raw/new")
dir_create(c(monthly_dir, new_dir))

write_csv(may, path(monthly_dir, "air-quality-1973-05.csv"), na = "")
write_csv(june, path(monthly_dir, "air-quality-1973-06.csv"), na = "")
write_csv(july, path(monthly_dir, "air-quality-1973-07.csv"), na = "")
write_csv(august, path(monthly_dir, "air-quality-1973-08.csv"), na = "")
write_csv(september, path(new_dir, "air-quality-1973-09.csv"), na = "")

dir_copy(
  here("start/data-raw"),
  here("finish/data-raw"),
  overwrite = TRUE
)
