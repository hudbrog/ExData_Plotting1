library(readr)
library(dplyr)
library(ggplot2)
library(scales)
library(tidyr)

# read the data
data <- tbl_df(read_csv2("household_power_consumption.txt")) %>%
  # filter out everything but 01/02 and 02/02 in 2007
  filter(Date=='1/2/2007'|Date=='2/2/2007') %>%
  # create a new field "newdt" with datetime
  mutate(newdt=as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) %>%
  # 3 columns into 2 key+value columns
  gather(sub_meter_type, sub_meter_value, Sub_metering_1, Sub_metering_2, Sub_metering_3)

q<-ggplot(data,  aes(x=newdt, y=sub_meter_value, color=sub_meter_type)) + 
  labs(y="Energy sub metering", x="")+
  theme_bw()+
  scale_x_datetime(breaks=date_breaks("1 day"), labels=date_format("%a")) +
  geom_line() + 
  # set colors to be like in the task
  scale_color_manual(values=c("#000000", "#FF0000", "#0000FF")) +
  # and put legen like into upper right corner
  theme(legend.position=c(1,1), legend.justification=c(1,1), legend.background=element_rect(linetype=1, colour="black"))

print(q)

#save plot to the file
ggsave("plot3.png", width=6, height=6, dpi=80)