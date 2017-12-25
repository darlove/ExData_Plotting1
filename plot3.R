## This code re-constructs plot3.png

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
    'NULL', # Global_active_power
    'NULL', # Global_reactive_power
    'NULL', # Voltage
    'NULL', # Global_intensity
    'numeric', # Sum_metering_1
    'numeric', # Sub_metering_2
    'numeric' # Sum_metering_3
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
    DateTime = as.POSIXct(paste(Date, Time), format = '%d/%m/%Y %T'),
    Date = dmy(Date)) %>%
  filter(Date %in% as.Date(c('2007-02-01', '2007-02-02'))) %>%
  select(DateTime, SubMetering1, SubMetering2, SubMetering3)

## initialize the file
png(filename = './plot3.png')
par(mfrow = c(1, 1))
## create an empty plot and then add the lines...
with(
  hpc,
  plot(
    DateTime,
    # in order to have the correct ylim
    pmax(SubMetering1, SubMetering2, SubMetering3),
    type = 'n',
    xlab = '',
    ylab = 'Energy sub metering'))

with(hpc, lines(DateTime, SubMetering1, col = 'black'))
with(hpc, lines(DateTime, SubMetering2, col = 'red'))
with(hpc, lines(DateTime, SubMetering3, col = 'blue'))
## add a legend
legend(
  "topright",
  c("Sub_metering_1","Sub_metering_2", 'Sub_metering_3'),
  lty = c(1,1,1),
  col = c('black', "red", "blue"))
## close the file
dev.off()
