# load libraries
library(dplyr)
library(ggplot2)
library(readxl)

# load data
df_ice <- read_xlsx("data/icebreaker_answers.xlsx")

# create base figure
tt_mi_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance)) + 
      geom_point()
tt_mi_fig 

# each element is layered on with a "+"
tt_mi_ox_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance,
        color = serial_comma)) +
  geom_point() +
  xlab("Travel Time") +
  ylab("Travel Distance")
tt_mi_ox_fig

# can build off of previously-designed plots
tt_mi_2 <- tt_mi_ox_fig +
  theme_bw()
tt_mi_2

tt_mi_mode_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance,
        color = travel_mode)) +
  geom_point() +
  xlab("Travel Time") +
  ylab("Travel Distance") +
  guides(color = guide_legend(title = "Travel Mode"))
tt_mi_mode_fig

# faceting
ice_facet_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance)) +
  geom_point() +
  facet_wrap(travel_mode ~ .)
ice_facet_fig

# use functions to filter the df, then use ggplot to display
tt_mode_car_fig <- df_ice |>
  filter(travel_mode == "car") |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance)) +
  geom_point() +
  theme_bw()
tt_mode_car_fig
