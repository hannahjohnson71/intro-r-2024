#### Practice Problem: Loading and manipulating a data frame ####
# Don't forget: Comment anywhere the code isn't obvious to you!

# Load the readxl and dplyr packages
library(readxl)
library(dplyr)

# Use the read_excel function to load the class survey data
icebreaker_stuff <- read_excel("data/icebreaker_answers.xlsx")

# Take a peek!
View(icebreaker_stuff)
colnames(icebreaker_stuff)

# Create a travel_speed column in your data frame using vector operations and 
#   assignment
icebreaker_stuff$travel_speed <- icebreaker_stuff$travel_distance / (icebreaker_stuff$travel_time / 60)

# Look at a summary of the new variable--seem reasonable?
summary(icebreaker_stuff$travel_speed)

# Choose a travel mode, and use a pipe to filter the data by your travel mode
filter(icebreaker_stuff, icebreaker_stuff$travel_mode == "car")

# Note the frequency of the mode (# of rows returned)
nrow(filter(icebreaker_stuff, icebreaker_stuff$travel_mode == "car"))

# Repeat the above, but this time assign the result to a new data frame
car_data <- icebreaker_stuff |>
  filter(
    travel_mode == "car"
  )

# Look at a summary of the speed variable for just your travel mode--seem 
#   reasonable?
summary(car_data$travel_speed)

# Filter the data by some arbitrary time, distance, or speed threshold
filter(car_data, car_data$travel_time > 100)

# Stretch yourself: Repeat the above, but this time filter the data by two 
#   travel modes (Hint: %in%)
modes_list <-list("car", "bus")
carandbus_data <- icebreaker_stuff |>
  filter(
     icebreaker_stuff$travel_mode %in% modes_list
  )
