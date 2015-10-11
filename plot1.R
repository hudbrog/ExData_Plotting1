library(readr)
library(dplyr)
library(ggplot2)

# read the data
data <- tbl_df(read_csv2("household_power_consumption.txt")) %>%
  # filter out everything but 01/02 and 02/02 in 2007
  filter(Date=='1/2/2007'|Date=='2/2/2007') %>%
  # create a new field "newdt" with datetime
  mutate(newdt=as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) 

# create a plot
q<-ggplot(data, aes(Global_active_power)) + 
  # barplot
  geom_bar(color="black", binwidth=0.5, fill="red")+
  labs(title="Global Active Power", x="Global Active Power(kilwatts)", y="Frequency")+
  theme_bw()+
  # set limits
  coord_cartesian(xlim=c(0,6), ylim=c(0,1200))

print(q)

#save plot to the file
ggsave("plot1.png", width=6, height=6, dpi=80)