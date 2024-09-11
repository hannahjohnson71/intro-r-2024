library(dplyr)
library(ggplot2)

detectors <- read.csv("data/portal_detectors.csv", stringsAs
                      Factors = FALSE)
stations <- read.csv("data/portal_stations.csv", stringsAsFactors = FALSE)
data <- read.csv("data/agg_data.csv", stringsAsFactors = FALSE)

head(data)
table(data$detector_id)
table(detectors$detectorid)

data_detectors <- data |>
  distinct(detector_id)

data_detectors_meta <- data_detectors |>
  left_join(detectors, by = c("detector_id" = "detectorid"))

data_detectors_missing <- detectors |>
  anti_join(data_detectors, by = c("detectorid" = "detector_id")) |>
  distinct(detectorid)
