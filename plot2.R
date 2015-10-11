library(readr)
library(dplyr)
library(ggplot2)
library(scales)

# read the data
data <- tbl_df(read_csv2("household_power_consumption.txt")) %>%
  # filter out everything but 01/02 and 02/02 in 2007
  filter(Date=='1/2/2007'|Date=='2/2/2007') %>%
  # create a new field "newdt" with datetime
  mutate(newdt=as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) 

q <- ggplot(data, aes(newdt, Global_active_power)) +
  geom_line() +
  labs(y="Global Active Power(kilwatts)", x="") + 
  # X axis should have breaks every day and mark them with day name
  scale_x_datetime(breaks=date_breaks("1 day"), labels=date_format("%a"))+
  theme_bw()

print(q)

#save plot to the file
ggsave("plot2.png", width=6, height=6, dpi=80)