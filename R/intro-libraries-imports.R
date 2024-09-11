# Read in csv file using base R
sta_meta <- read.csv("data/portal_stations.csv", stringsAsFactors = F)

str(sta_meta) # structure of data

head(sta_meta) # first six rows of data
tail(sta_meta) # last six rows of data

nrow(sta_meta) # count number of rows
ncol(sta_meta) # count number of columns
summary(sta_meta) # summary of data, can get some info on NA's

# Using Import shortcut in Environment window to read in xlsx and
# copy/paste code here in the R file
library(readxl)
icebreaker_answers <- read_excel("data/icebreaker_answers.xlsx")
View(icebreaker_answers)

library(dplyr)

# Make new dataset named odot_meta, pulling data from sta_meta where
# the agency is ODOT and the highway is I-5 (id = 1).
odot_meta <- sta_meta |> # old pipe notation is %>%, use new |>
  filter(agency == "ODOT"
         , highwayid == 1)


notodot_meta <- sta_meta |>
  filter(
    agency != "ODOT"
  )

# look for n/a values
nas_meta <- sta_meta |>
  filter(
    is.na(detectorlocation) # is.na is to find null values
  )

# exlude n/a values
real_meta <- sta_meta |>
  filter(
    !is.na(detectorlocation) # !is.na finds everything that is not null
  )
