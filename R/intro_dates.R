# datetimes ----

library(dplyr)
library(ggplot2)
library(lubridate)

stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

str(detectors)

# view available time zone names
OlsonNames()

# convert columns to datetime ** must identify time zone ----
head(detectors$start_date)
detectors$start_date <- ymd_hms(detectors$start_date) |>
  with_tz("US/Pacific")

head(detectors$end_date)
detectors$end_date <- ymd_hms(detectors$end_date) |>
  with_tz("US/Pacific")

# find open detectors (will be null in end_date column)
open_det <- detectors |>
  filter(is.na(end_date))
open_det
# find closed detectors
closed_det <- detectors |>
  filter(!is.na(end_date))
closed_det

# total daily volume, average volume, average speed per station for open dets
  # join full data frame "data" to new open_dets metadata frame with only
  # selected columns
data_stid <- data |>
  left_join(open_det, by = c("detector_id" = "detectorid")) |>
  select(detector_id, starttime, volume, speed, countreadings, stationid)

  # convert starttime to datetime format
data_stid$starttime <- ymd_hms(data_stid$starttime) |>
  with_tz("US/Pacific")
str(data_stid)

# data exploration ----
# want info for daily volume, daily obs, and avg speed for each station

  # make new df called "daily_data"
daily_data <- data_stid |>
  # make new column for the day of the observation
  mutate(date = floor_date(starttime, unit = "day")) |>
  # group by stationid and the new date column
  group_by(stationid,
           date) |>
  # summarized columns for the information you want
  summarize(
    daily_volume = sum(volume),
    daily_obs = sum(countreadings),
    mean_speed = mean(speed)
    )  |>
  # multiple layers can get messy, so use at the end:
  as.data.frame()

  # plot the data to check it out
daily_volume_fig <- daily_data |>
  ggplot(aes(x=date, y=daily_volume)) +
  geom_line() +
  geom_point() +
  facet_grid(stationid ~ ., scales = "free")
daily_volume_fig

library(plotly)
ggplotly(daily_volume_fig)
  # there is missing data for some days for some stations
  # how to fix this...

# expecting 31 obs for each station (31 days in March)
# how many unique stations are in the data?
length(unique(daily_data$stationid))
# 23 distinct stations x 31 days = 713
# make a vector of the unique station ids to use later
stids <- unique(daily_data$stationid)

# make new dataframe for each day of the month of March 2023 and unique stids
start_date <- ymd("2023-03-01")
end_date <- ymd("2023-03-31")

date_df <- data.frame(
  date_seq = rep(seq(start_date, end_date, by = "1 day")),
  station_id = rep(stids, each = 31)
)

data_with_gaps <- date_df |>
  left_join(daily_data, by = c("date_seq" = "date",
                               "station_id" = "stationid"))

  # write out df as .csv file
write.csv(data_with_gaps, "data/data_with_gaps.csv", row.names = F)
  # save as R data structure "RDS object"
    # keeps class structures, takes up only a tiny amount of space, etc.
saveRDS(data_with_gaps, "data/data_with_gaps.rds")
