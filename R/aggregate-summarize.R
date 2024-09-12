#### Aggregating and Summarizing Data ####

# Load packages
library(readxl)
library(dplyr)
library(ggplot2)

# Read in the Excel file
df <- read_excel("data/icebreaker_answers.xlsx")
df
summary(df)

# custom summaries of an entire data frame ----
df |> summarize(
  avg_dist = mean(travel_distance),
  sd_dist = sd(travel_distance),
  min_time = min(travel_time),
  max_time = max(travel_time),
  avg_time = mean(travel_time, )
  pct60_dist = quantile(travel_distance, prob = 0.6)
)

# you can put the custom summary variables into a table ----
df_summ <- df |> summarize(
  avg_dist = mean(travel_distance),
  sd_dist = sd(travel_distance),
  min_time = min(travel_time),
  max_time = max(travel_time),
  pct60_dist = quantile(travel_distance, prob = 0.6)
)

# an aside, if you want to see an integer, you must specify so
df_summ |> mutate(avg_dist = as.integer(avg_dist))

# use View() or click in Environment to open the data frame 
View(df_summ)

# custom summaries of a subset of a data frame ----

  # make new column for travel_speed
df <- df |> mutate(travel_speed = travel_distance / travel_time * 60)
  # view average travel_speed for whole data frame
df |> summarize(avg_speed = mean(travel_speed))
  # average speed by mode (auto sort by travel_mode alphabetically)
df |> group_by(travel_mode) |>
  summarize(avg_speed = mean(travel_speed))
  # average speed by mode, sorted by avg_speed
df |> group_by(travel_mode) |>
  summarize(avg_speed = mean(travel_speed)) |>
  arrange(desc(avg_speed))

# grouped data frame ----
# see "Groups:  travel_mode [5]" message in tibble
df_mode_grp <- df |> group_by(travel_mode)
str(df_mode_grp) # "gropd_df [21 × 5]"

  # group by multiple variables and custom summarize variable
df |> group_by(travel_mode, serial_comma) |>
  summarize(avg_speed = mean(travel_speed)) 

df_mode_comma_grp <- df |> group_by(travel_mode, serial_comma) |>
  summarize(avg_speed = mean(travel_speed)) 

  # by default, summarize will leave data grouped by next higher level
  # you would have to explicitly ungroup() after a pipe
df_mode_comma_ungrp <- df |> group_by(travel_mode, serial_comma) |>
  summarize(avg_speed = mean(travel_speed)) |>
  ungroup()

# frequencies ----
df |> group_by(serial_comma) |> 
  summarize(n = n()) |>
  arrange(desc(n))

df |> group_by(serial_comma) |> 
  tally() |>
  arrange(desc(n))

df |> count(serial_comma) |>  arrange(desc(n))
df |> count(serial_comma, sort=T)

  # calculate a mode split (percentage using each travel mode)
df |> group_by(travel_mode) |>
  summarize(split = n() / nrow(df) * 100) |>
  arrange(desc(split))

