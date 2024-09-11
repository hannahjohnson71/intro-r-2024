#### Transforming Data Part 2 ####

library(readxl)
library(dplyr)

# load in data from Excel
df <- read_excel("data/icebreaker_answers.xlsx")
df
tail(df)

df <- df |> bind_rows(slice_tail(df)) # take last row and add to end of df
tail(df)

df <- df |> distinct() # returns only distinct rows
tail(df)

# selecting columns
df %>% select(travel_mode, travel_distance, travel_time) # selected cols by name
df %>% select(1, 2, 3) # selected cols by column number

df %>% select(-serial_comma) # drop one column by name
df %>% select(-travel_mode, -travel_time) # multiple col exclusions
df %>% select(-4) # drop one column by column number

df %>% select(travel_mode:travel_distance) # group of cols by name, start:end
df %>% select(1:2) # group of columns, by column number, start to end

df %>% select(starts_with("travel_")) # selecting by expression - starts_with
df %>% select(ends_with("e")) # selecting by expression - ends_with

df %>% select(1:2, 4) # group of columns, by range and col number
df %>% select(1:2, serial_comma) # mix-and-match... GROSS
df %>% select(1:4, -serial_comma) # more mix-and-match... GROSS
df %>% select(starts_with("travel_"), -travel_mode) # mix-and-match by name

df_travel <- df |> select(-serial_comma)

# mutate and rename (creating and modifying data frames)
  # version 1: manually add columns
df_travel$travel_speed <- (df_travel$travel_distance / 
                             df_travel$travel_time *60)
  # version 2: mutate to add calculated columns
df_travel <- df_travel |> 
  mutate(travel_speed = travel_distance / travel_time * 60)

# mutate to add more than one calculated columns
df_travel <- df_travel |> 
  mutate(
    travel_speed_mph = travel_distance / travel_time * 60,
    travel_speed_kmh = travel_speed_mph * 1.609344
    )
df_travel

# if just renaming...
df_travel <- df_travel |> # new name then old name, can do more than 1 col
  rename(travel_mph = travel_speed_mph, travel_kmh = travel_speed_kmh)
colnames(df_travel)

# if/else and case where logic ----
  # adding logic to mutate, if/else ==
df_travel <- df_travel |>
  mutate(long_trip = if_else(travel_distance > 20,
                        1, 0)) # set values by condition
  # adding logic to mutate, case when ==
table(df_travel$travel_mode)
df_travel <- df_travel |>
  mutate(slow_trip = 
           case_when(
             travel_mode == "bike" & travel_mph < 12 ~ 1,
             travel_mode == "car" & travel_mph < 25 ~ 1,
             travel_mode == "bus" & travel_mph < 15 ~ 1,
             travel_mode == "light rail" & travel_mph < 20 ~ 1,
             .default = 0 # all FALSE or NA will be assigned this value
           ))
df_travel

  # arrange to order output
df_travel |> arrange(travel_mph) |> print(n=25) # from slowest to fastest
df_travel |> arrange(desc(travel_mph)) |> print(n=25) # reverse sort
df_travel |> arrange(travel_mode, travel_mph) |> print(n=25) # sort by 2 cols

boxplot(df_travel$travel_mph ~ df_travel$long_trip)

