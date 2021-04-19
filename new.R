library(tidyverse)
IsTrue <- function(x) { !is.na(x) & x }
googlesheets4::gs4_deauth()
link <- "https://docs.google.com/spreadsheets/d/1lXGSoKHMQu6NBG3-rzjzDt9e_MKjWP8EXP-4X1BhAzg/edit?usp=sharing"
initial <- googlesheets4::read_sheet(link, sheet = "initial")
load("_data/LSCMWG_working_class.RData", verbose = TRUE)
df <- unique(df[!is.na(df$class), c("country", "period", "health_class", "gender_class", "health_class_alt", "gender_class_alt", "class", "class_vv")])
df$period <- str_sub(df$period, 7, 10)
df <- df[!is.na(df$class) & df$period != 2020, ]
df <- df %>%
  arrange(country, period) %>%
  group_by(country) %>%
  mutate(data_start = min(period),
         data_end = max(period),
         lag_gender = lag(gender_class),
         lag_health = lag(health_class))
df <- df %>%
  mutate(gender = gender_class - lag_gender,
         health = health_class - lag_health)
df$gender[df$gender < 0] <- "-"
df$gender[df$gender > 0] <- "+"
df$gender[df$gender == 0] <- ""
df$health[df$health < 0] <- "-"
df$health[df$health > 0] <- "+"
df$health[df$health == 0] <- ""
df <- df[, c("country", "period", "data_start", "data_end", "gender_class", "health_class", "class", "gender", "health")]
start <- df[df$period == df$data_start, c("country", "data_start", "class", "gender_class", "health_class")]
start$vv[start$gender_class > start$health_class] <- "G > H"
start$vv[start$gender_class < start$health_class] <- "H > G"
start$vv[start$gender_class == start$health_class] <- "middle"
start$vv[start$gender_class < 3 & start$health_class < 3] <- "vicious"
start$vv[start$gender_class > 3 & start$health_class > 3] <- "virtuous"
names(start)[-c(1:2)] <- paste(names(start)[-c(1:2)], "start", sep = "_")
end <- df[df$period == df$data_end, c("country", "class", "gender_class", "health_class")]
end$vv[end$gender_class > end$health_class] <- "G > H"
end$vv[end$gender_class < end$health_class] <- "H > G"
end$vv[end$gender_class == end$health_class] <- "middle"
end$vv[end$gender_class < 3 & end$health_class < 3] <- "vicious"
end$vv[end$gender_class > 3 & end$health_class > 3] <- "virtuous"
names(end)[-1] <- paste(names(end)[-1], "end", sep = "_")
new <- merge(start, end, by = "country", all = TRUE)
new$overall <- ifelse(new$class_end == new$class_start, "same", "")
new$gender[new$gender_class_end > new$gender_class_start] <- "G+"
new$gender[new$gender_class_end < new$gender_class_start] <- "G-"
new$gender[is.na(new$gender)] <- ""
new$health[new$health_class_end > new$health_class_start] <- "H+"
new$health[new$health_class_end < new$health_class_start] <- "H-"
new$health[is.na(new$health)] <- ""
new$overall <- paste(new$overall, new$health, new$gender, sep = "")
new <- new[, c( "country", "data_start", "class_start", "class_end", "overall", "vv_start", "vv_end")]
df <- df[, c("country", "period", "gender", "health")]
df_gender <- pivot_wider(df[, c("country", "period", "gender")], names_from = period, values_from = gender)
df_gender$dimension <- "gender"
df_health <- pivot_wider(df[, c("country", "period", "health")], names_from = period, values_from = health)
df_health$dimension <- "health"
df <- rbind(df_health, df_gender)
df[is.na(df)] <- ""
df <- merge(new, df, by = "country")
df <- df %>% arrange(country)
initial <- initial[, c("country", "sequence_type")]
initial$vv[str_detect(initial$sequence_type, "vicious")] <- "vicious"
initial$vv[str_detect(initial$sequence_type, "virtuous")] <- "virtuous"
initial$vv[str_detect(initial$sequence_type, "middle")] <- "middle"
initial$vv[str_detect(initial$sequence_type, "G > H")] <- "G > H"
initial$vv[str_detect(initial$sequence_type, "H > G")] <- "H > G"
initial$sequence_type <- str_replace(initial$sequence_type, " vicious", "")
initial$sequence_type <- str_replace(initial$sequence_type, " virtuous", "")
initial$sequence_type <- str_replace(initial$sequence_type, " middle", "")
initial$sequence_type <- str_replace(initial$sequence_type, " G > H", "")
initial$sequence_type <- str_replace(initial$sequence_type, " H > G", "")
names(initial) <- str_replace(names(initial), "sequence_type", "change")
initial[is.na(initial)] <- ""
df <- merge(df, initial, by = "country")
df <- df[, c("country", "data_start", "class_start", "class_end", "dimension",
             "1965", "1970", "1975", "1980", "1985", "1990", "1995", "2000", "2005", "2010", "2015",
             "overall", "vv_start", "vv_end", "change", "vv")]
df <- df %>% arrange(country, dimension)
current <- googlesheets4::read_sheet(link, sheet = "current")
current <- current[, names(current) %in% c("country", "dimension", "change", "vv_end", "vv")]
names(current)[names(current) == "change"] <- "change_old"
names(current)[names(current) %in% c("vv", "vv_end")] <- "vv_old"
current[is.na(current)] <- ""
df <- merge(df, current, by = c("country", "dimension"))
# df[IsTrue(df$change != df$change_old), ]
# tibble(df)
# googlesheets4::gs4_auth()
# googledrive::drive_find(type = "spreadsheet")
# googlesheets4::write_sheet(df, ss = "1lXGSoKHMQu6NBG3-rzjzDt9e_MKjWP8EXP-4X1BhAzg", sheet = "new")

current <- googlesheets4::read_sheet(link, sheet = "current")
current <- unique(current[, c("country", "vv_start", "vv_end", "class_start", "class_end", "overall", "sequence_original")])
current$sequence <- current$sequence_original
current$sequence[current$sequence == "="] <- "stable"

googlesheets4::write_sheet(current, ss = "1lXGSoKHMQu6NBG3-rzjzDt9e_MKjWP8EXP-4X1BhAzg", sheet = "new")
(table(current$sequence_original))

current <- googlesheets4::read_sheet(link, sheet = "new")
table(current[, c("overall", "sequence")])
