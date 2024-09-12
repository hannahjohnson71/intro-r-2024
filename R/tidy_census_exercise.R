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

tidy_acs_result <- function(raw_result, include_moe = FALSE){
  # takes a tidycensus acs result and returns a wide and tidy table
  if (isTRUE(include_moe)) {
    new_df <- raw_result |> pivot_wider(id_cols = GEOID:NAME, 
                                        names_from = variable,
                                        values_from = estimate:moe)
  } else {
    new_df <- raw_result |> pivot_wider(id_cols = GEOID:NAME, 
                                        names_from = variable,
                                        values_from = estimate)    
  }
  return(new_df)
}
# tidy_acs_result ***call function without () to simply view your function



# get a searchable census variable table and explore
v19 <- load_variables(2019, "acs5")
v19 |> filter(grepl("^B08006_", name)) |>
  print(n=25)

# get the raw data for transit, wfh, and total workers
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
# use custom-built function to widen dataset for analysis
comm_19 <- tidy_acs_result(comm_19_raw)
comm_19

# get 2022 ACS data, then call custom function
comm_22_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah",
                       state = "OR",
                       year = 2022,
                       survey = "acs5",
                       geometry = FALSE)
comm_22_raw
comm_22 <- tidy_acs_result(comm_22_raw)
comm_22


# join the years 2019 and 2022 on GEOID, drop NAME cols
comm_19_22 <- comm_19 |> inner_join(comm_22, 
                                    by="GEOID",
                                    suffix = c("_19", "_22")) |>
                                    # gives new name to cols with same name
                          select(-starts_with("NAME"))
comm_19_22

# create some change variables and view in a summary
comm_19_22 <- comm_19_22 |>
  mutate(wfh_chg = wfh_22 - wfh_19,
         transit_chg = transit_22 - transit_19)
summary(comm_19_22 |> select(ends_with("_chg")))

# plot the changes
p <- comm_19_22 |>
  ggplot(aes(x = wfh_chg, y = transit_chg)) +
    # starts your plot, based on x and y axises chosen
  geom_point() +
    # scatter plot
  geom_smooth(method = 'lm') +
    # 'lm' for linear model - easy to view, hard to get the equation out!
  labs(x="Change in WFH",
       y="Change in Transit" ,
       title="ACS 2022 vs 2019 (5-year)") +
    # changes to axis and title labels
  annotate("text", x=800, y=50, 
           label = paste("r =",
                         round(cor(comm_19_22$wfh_chg,
                             comm_19_22$transit_chg), 2)))
    # annotation
p

# simple linear (default Peason) correlation in annotation
cor(comm_19_22$wfh_chg, comm_19_22$transit_chg)

# model it...
# dependent variable on left side of ~, independent on right side of ~
# model formula is dependent_variable ~ 1 + var1 + var2 ...
m <- lm(transit_chg ~ wfh_chg,
        data = comm_19_22)
summary(m)

# the model is an object ready for re-use!!
head(m$model)

# scenario 1 where wfh is increased by 50%
scen1 <- comm_19_22 |>
  mutate(wfh_chg = wfh_chg * 1.5)
scen1_pred <- predict(m, newdata = scen1)
# predict function with scenario 1 data
# different in total daily transit impact from 50% increase in WFH
sum(comm_19_22$transit_chg)
sum(scen1_pred)
# would lose about 4000 daily trips if WFH increases by 50%

# update(model, data =) function re-estimates model on new data