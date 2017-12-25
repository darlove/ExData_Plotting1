## This code re-constructs plot1.png

hpc <- read.table(
    file = './household_power_consumption.txt',
    header = TRUE,
    sep = ';',
    stringsAsFactors = FALSE,
    na.strings = '?',
    colClasses = c(
      # import only the columns we need ('NULL' = don't import)
      'character', # Date
      'NULL', # Time
      'numeric', # Global_active_power
      'NULL', # Global_reactive_power
      'NULL', # Voltage
      'NULL', # Global_intensity
      'NULL', # Sum_metering_1
      'NULL', # Sub_metering_2
      'NULL' # Sum_metering_3
    )
  )

## load to use easy date(time)-related functions, should we need it...
require(lubridate)
## load tidyverse to have the nice functions and the pipe handy
require(tidyverse)
## change to a tibble for easier display
hpc <- tbl_df(hpc)
## change names of the columns to something easier to type...
require(stringr)
names(hpc) <- names(hpc) %>%
  ## replace '_' with a space
  gsub(pattern = '_', replacement = ' ') %>%
  ## make proper case
  stringr::str_to_title() %>%
  ## get rid of spaces
  gsub(pattern = ' ', replacement = '')

## filter the data and select only the one column we need
hpc <- hpc %>%
  mutate(Date = as.Date(Date, format = '%d/%m/%Y')) %>%
  filter(Date %in% as.Date(c('2007-02-01', '2007-02-02'))) %>%
  select(GlobalActivePower)

## open the png device
png(filename = './plot1.png')
par(mfrow = c(1, 1))
## plot to the device/file
with(hpc,
     hist(x = GlobalActivePower,
          main = 'Global Active Power',
          col = 'red',
          xlab = 'Global Active Power (kilowatts)'
      ),
)
## close the device
dev.off()
