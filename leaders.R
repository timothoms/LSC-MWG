library(tidyverse)
library(stringr)
library(lubridate)
# "https://www.cfr.org/article/womens-power-index"
cfr <- readr::read_csv("https://vallenato-cfr.netlify.com/womens_power_index/export/WFP%20-%20GWLT%20-%20Tracker%20-%20Export.csv")
names(cfr)
vars <- c(country = "Country name",
          cid = "Country code",
          subregion = "Subregion",
          number_female_heads = "Number of elected and appointed female heads of state or governments since 1946",
          female_heads_of_state = "Names of elected and appointed female heads of state or governments with dates")
cfr <- cfr[, vars]
names(cfr) <- names(vars)
# cfr$female_heads_of_state[!is.na(cfr$female_heads_of_state)]
cfr <- cfr %>% separate_rows(female_heads_of_state, sep = "\\), ")
## OR
# cfr <- cfr %>% mutate(female_heads_of_state = str_split(female_heads_of_state, fixed("), "))) %>% unnest(female_heads_of_state)
cfr <- cfr %>% separate(female_heads_of_state, into = c("female_head_of_state", "dates"), sep = "\\s\\(", remove = TRUE)
## OR
# str_split_fixed(cfr$female_heads_of_state, fixed(" ("), 2)
cfr <- cfr %>% separate(dates, into = c("begin", "end"), sep = " to ", remove = TRUE)
cfr$end <- str_replace(cfr$end, fixed(")"), "")
add <- data.frame(country = c("Taiwan", "Kosovo"),
                  cid = c(NA, NA),
                  subregion = c(NA, NA),
                  number_female_heads = c(NA, 2),
                  female_head_of_state = c("Tsai Ing-wen", "Vjosa Osmani"),
                  begin = c("May 20, 2020", "November 5, 2020"),
                  end = c("Incumbent", "Incumbent"))
cfr <- rbind(cfr, add)
now <- format(today(), "%B %e, %Y")
cfr$end <- str_replace(cfr$end, fixed("Incumbent"), "April 6, 2021")
cfr$begin <- as_date(cfr$begin, format = "%B %e, %Y")
cfr$end <- as_date(cfr$end, format = "%B %e, %Y")
