#### Libraries ####

library(tidycensus)   # acts as a gateway to the Census API
                      # for more info: https://walker-data.com/tidycensus/
library(dplyr)
library(tidyr)
library(ggplot2)

#### API Key ####
#### Run on first use if key is not already stored in R
census_api_key("type in API key here", install = T)
readRenviron("~/.Renviron")

#### User Functions ####

#### 

# get a searchable census variable table and explore
v19 <- load_variables(2019, "acs5")
v19 |> filter(grepl("^B08006_", name)) |>
  print(n=25)

# get the data for transit, wfh, and total workers
comm_19_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah",
                       state = "OR",
                       year = 2019,
                       survey = "acs5",
                       geometry = FALSE) # can get spatial geoms pre-joined
comm_19_raw

# using function from tidyr to widen dataset for analysis
comm_19 <- comm_19_raw |>
  pivot_wider(id_cols = GEOID, # could also try GEOID : NAMES ,
              names_from = variable,
              values_from = estimate:moe)
comm_19

#
