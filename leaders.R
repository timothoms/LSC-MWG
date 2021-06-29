library(tidyverse)
library(stringr)
library(lubridate)

### CFR
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

### IPU
# download.file("https://data.ipu.org/sites/default/files/other-datasets/women_in_parliament-historical_database-1945_to_2018.xlsx", destfile = "_data/women_in_parliament-historical_database-1945_to_2018.xlsx")
hist <- readxl::read_excel("_data/women_in_parliament-historical_database-1945_to_2018.xlsx")
# "https://data.ipu.org/sites/default/files/other-datasets/age-data-historical_export-jan_2009-april_2021-nigeria_correction.xls"
speakers <- readr::read_csv("https://data.ipu.org/women-speakers/export/csv", skip = 4)
names(dates) <- dates <- seq(as_date(zoo::as.yearmon('2019-01')), as_date(zoo::as.yearmon(now())), by = '1 month')
ipu <- lapply(dates, function(date) {
  women <- readr::read_csv(paste("https://data.ipu.org/api/women-ranking.csv?load-entity-refs=taxonomy_term%2Cfield_collection_item&max-depth=2&langcode=en&month=", month(date), "&year=", year(date), sep = ""), locale = readr::locale("ca"))
  specialized <- readr::read_csv(paste("https://data.ipu.org/specialized-bodies/export/csv?region=0&structure=any&sb_theme=0&sb_show_empty=0&year=", year(date), "&month=", month(date), sep = ""), locale = readr::locale("ca"))
  return(list(women = women, specialized = specialized))
})
save(ipu, file = "_data/ipu_temp.RData")
women <- lapply(ipu, function(x) x$women)
special <- lapply(ipu, function(x) x$specialized)
special <- lapply(names(special), function(index) {
  df <- special[[index]]
  df$date <- index
  return(df)
})
special <- do.call(rbind, special)
women <- lapply(women, function(x) {
  header <- paste(x[4, ], x[5, ])
  header <- str_replace(header, "NA","")
  header <- str_trim(header)
  names(x) <- header
  return(x[-c(1:5), ])
})
women <- lapply(names(women), function(index) {
  df <- women[[index]]
  df$date <- index
  return(df)
})
women <- do.call(rbind, women)
