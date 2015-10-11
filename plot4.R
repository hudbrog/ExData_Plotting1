library(readr)
library(dplyr)
library(ggplot2)
library(scales)
library(tidyr)
library(gridExtra)

data <- tbl_df(read_csv2("household_power_consumption.txt")) %>%
  filter(Date=='1/2/2007'|Date=='2/2/2007') %>%
  mutate(newdt=as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) %>%
  gather(sub_meter_type, sub_meter_value, Sub_metering_1, Sub_metering_2, Sub_metering_3)
q <- ggplot(data, aes(newdt, Global_active_power)) +
  geom_line() +
  labs(y="Global Active Power(kilwatts)", x="") + 
  scale_x_datetime(breaks=date_breaks("1 day"), labels=date_format("%a"))+
  theme_bw()

q2<-ggplot(data,  aes(x=newdt, y=sub_meter_value, color=sub_meter_type)) + 
  labs(y="Energy sub metering", x="")+
  theme_bw()+
  scale_x_datetime(breaks=date_breaks("1 day"), labels=date_format("%a")) +
  geom_line() + 
  scale_color_manual(values=c("#000000", "#FF0000", "#0000FF")) +
  theme(legend.position=c(1,1), legend.justification=c(1,1), legend.background=element_rect(linetype=1, colour="black"))

q3 <- ggplot(data, aes(x=newdt, y=Voltage))+
  theme_bw()+
  scale_x_datetime(breaks=date_breaks("1 day"), labels=date_format("%a")) +
  geom_line()
  
q4 <- ggplot(data, aes(x=newdt, y=Global_reactive_power)) +
  theme_bw()+
  scale_x_datetime(breaks=date_breaks("1 day"), labels=date_format("%a")) +
  geom_line()

grid.arrange(q, q3, q2, q4, ncol=2)
#a dirty hack to make ggplot2 save grobs
ggsave <- ggplot2::ggsave; body(ggsave) <- body(ggplot2::ggsave)[-2]
ggsave(filename="plot4.png", grid.arrange(q, q3, q2, q4, ncol=2),width=6, height=6, dpi=80)

