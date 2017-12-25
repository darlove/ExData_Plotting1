## This code re-constructs plot2.png

hpc <- read.table(
  file = './household_power_consumption.txt',
  header = TRUE,
  sep = ';',
  stringsAsFactors = FALSE,
  na.strings = '?',
  colClasses = c(
    # import only the columns we need ('NULL' = don't import)
    'character', # Date
    'character', # Time
    'numeric', # Global_active_power
    'NULL', # Global_reactive_power
    'NULL', # Voltage
    'NULL', # Global_intensity
    'NULL', # Sum_metering_1
    'NULL', # Sub_metering_2
    'NULL' # Sum_metering_3
  )
)

## load tidyverse to have the nice functions and the pipe handy
require(tidyverse)
## load to use easy date(time)-related functions, should we need it...
require(lubridate)
## change to a tibble for easier display
hpc <- tbl_df(hpc)
## change names of the columns to something easier to type...
require(stringr)
names(hpc) <- names(hpc) %>%
  ## replace '_' with a space
  gsub(pattern = '_', replacement = ' ') %>%
  ## make proper case
  str_to_title %>%
  ## get rid of spaces
  gsub(pattern = ' ', replacement = '')
## change Date from character to date(time) and filter for those 2 days we need
hpc <- hpc %>%
  mutate(
    # this field only for filtering
    Date2 = as.Date(Date, format = '%d/%m/%Y'),
    # this field for plotting
    DateTime = as.POSIXct(paste(Date, Time), format = '%d/%m/%Y %T')) %>%
  filter(Date2 %in% as.Date(c('2007-02-01', '2007-02-02'))) %>%
  # select only what we really need
  select(DateTime, GlobalActivePower)

## initialize the file
png(filename = './plot2.png')
par(mfrow = c(1, 1))
## create an empty plot and then add the lines...
with(
  hpc,
  plot(
    DateTime,
    GlobalActivePower,
    type = 'n',
    xlab = '',
    ylab = 'Global Active Power (kilowatts)'))

with(hpc, lines(DateTime, GlobalActivePower, lwd = 2))
## close the file
dev.off()
