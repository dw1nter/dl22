# Title     : DL-22 Reader
# Objective : Read table DL-22 from Highway Statistics website and save as a machine readable .CSV file.
# Created by: David.Winter
# Created on: 10/30/2020

library (tidyverse)
library(readxl)

startRow <- 12

# Reading input Excel file from OHPI website.
dl22_url <- 'https://www.fhwa.dot.gov/policyinformation/statistics/2018/xls/dl22.xls'
destination_file <- "dl22-download-fhwa.xls"

if (!file.exists(destination_file)){
  download.file(dl22_url, destfile = destination_file, mode="wb")
}
# Read data from Male tab
dl_male_raw <- read_excel(destination_file, sheet="MALES", col_types = "text", skip=startRow)

colnames (dl_male_raw) <- c("state_name",
                       "male_u19",
                       "male_20-24",
                       "male_25-29",
                       "male_30-34",
                       "male_35-39",
                       "male_40-44",
                       "male_45-49",
                       "male_50-54",
                       "male_55-59",
                       "male_60-64",
                       "male_65-69",
                       "male_70-74",
                       "male_75-79",
                       "male_80-84",
                       "male_85+",
                       "male_total",
                       "blank",
                       "state2_name",
                       "male_u16",
                       "male_16",
                       "male_17",
                       "male_18",
                       "male_19",
                       "male_20",
                       "male_21",
                       "male_22",
                       "male_23",
                       "male_24"
)
# Deleting blank row at top, total columns, and rows.
dl_male_raw = dl_male_raw[-1,]
dl_male_raw <- dl_male_raw %>% select(-c('male_u19','male_20-24','male_total','blank','state2_name'))
# dl_raw <- dl_raw[-c(54,55), ]

#remove total
dl_male_raw <- dl_male_raw %>% filter(state_name != 'Total')

# Taking cleaned up data table and pivoting to machine readable format.
dl_male_tidy <- dl_male_raw %>%
  pivot_longer('male_25-29':'male_24', names_to="COLUMN_KEY", values_to='Drivers') %>%
  separate(COLUMN_KEY, into = c("Gender", "Age"), sep='_')
# dl_male_tidy <- filter(dl_male_tidy,RuralUrbanCode != 'grand')

# Read data from Female tab
dl_female_raw <- read_excel(destination_file, sheet="FEMALES", col_types = "text", skip=startRow)

colnames (dl_female_raw) <- c("state_name",
                            "female_u19",
                            "female_20-24",
                            "female_25-29",
                            "female_30-34",
                            "female_35-39",
                            "female_40-44",
                            "female_45-49",
                            "female_50-54",
                            "female_55-59",
                            "female_60-64",
                            "female_65-69",
                            "female_70-74",
                            "female_75-79",
                            "female_80-84",
                            "female_85+",
                            "female_total",
                            "blank",
                            "state2_name",
                            "female_u16",
                            "female_16",
                            "female_17",
                            "female_18",
                            "female_19",
                            "female_20",
                            "female_21",
                            "female_22",
                            "female_23",
                            "female_24"
)
# Deleting blank row at top, total columns, and rows.
dl_female_raw = dl_female_raw[-1,]
dl_female_raw <- dl_female_raw %>% select(-c('female_u19','female_20-24','female_total','blank','state2_name'))
# dl_raw <- dl_raw[-c(54,55), ]

#remove total
dl_female_raw <- dl_female_raw %>% filter(state_name != 'Total')

# Taking cleaned up data table and pivoting to machine readable format.
dl_female_tidy <- dl_female_raw %>%
  pivot_longer('female_25-29':'female_24', names_to="COLUMN_KEY", values_to='Drivers') %>%
  separate(COLUMN_KEY, into = c("Gender", "Age"), sep='_')
# dl_female_tidy <- filter(dl_female_tidy,RuralUrbanCode != 'grand')

dl_tidy <- rbind(dl_male_tidy, dl_female_tidy)

# Saving machine readable file.
write.csv(dl_tidy,file = "2018_dl22.csv")