# Project 1 week 2 : ReproductibleResearch 
library(data.table)
library(ggplot2)

fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
tmp<-paste(getwd(), 'act.zip', sep='/')
download.file(fileUrl, destfile = tmp, method = "curl")
unzip("act.zip", exdir = "data")
if (file.exists(tmp)) file.remove(tmp)

activity <- data.table::fread(input = "data/activity.csv")

# preprocssing
data<-aggregate(activity$steps, by = list(activity$date), FUN=sum)
names(data)<-c("date", "steps")

ggplot(data, aes(x = steps)) +
  geom_histogram(fill = "Gold") +
  labs(title = "Daily Steps", x = "Days", y = "Frequency")

