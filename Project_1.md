---
title: "CodeR"
author: "Nabil"
date: "25 September 2020"
output:
  html_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Project 1 week 2 : ReproductibleResearch

This is my submission for project 1 in the 5th Course of the 'Data Science: Foundations using R Specialization'.
For more details see the url : <https://www.coursera.org/specializations/data-science-foundations-r>.

Instructions to do this project are here <https://github.com/rdpeng/RepData_PeerAssessment1>


## BEGIN
```{r}
#Import library
# Dont forget to install.packages before the first time
library(data.table)
library(ggplot2)
```

### Loading data
```{r}
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
tmp<-paste(getwd(), 'act.zip', sep='/')
download.file(fileUrl, destfile = tmp, method = "curl")
unzip("act.zip", exdir = "data")
if (file.exists(tmp)) file.remove(tmp)

DT <- data.table::fread(input = "data/activity.csv")
```

### preprocessing
```{r}
head(DT)
```

```{r}
data<-aggregate(DT$steps, by = list(DT$date), FUN=sum)
names(data)<-c("date", "steps")
head(data)
```

### **1.** Make a histogram of the total number of steps taken each day
```{r}
g<-ggplot(data, aes(x = steps))
g<-g + geom_histogram(fill = "salmon") +
  labs(title = "Daily Steps", x = "Days", y = "Frequency")
g
```

### **2.** Calculate and report the mean and median total number of steps taken per day
```{r}
meandANDmedian<-cbind(aggregate(DT$steps, by = list(DT$date),
                    na.rm=TRUE, FUN=median),
          aggregate(DT$steps, by = list(DT$date),
                    FUN=mean)[,"x"])
names(meandANDmedian)<-c("date","mean_st","median_st")
head(meandANDmedian, 10)
```

### What is the average daily activity pattern?
#### 1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
#### 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r}
DT_interval <- aggregate(x=list(meanSteps=DT$steps), by=list(interval=DT$interval), FUN=mean, na.rm=TRUE)
ggplot(data=DT_interval, aes(x=interval, y=meanSteps)) +
    geom_line(color = "Blue") +
    xlab("5-minute interval") +
    ylab("Steps") 
```


```{r}
mostSteps <- DT_interval[max(DT_interval$meanSteps),]
mostSteps
```

### Code to describe and show a strategy for imputing missing data

```{r}
sum(is.na(DT$steps))
```
creating newDataFrame without missing

```{r}
DT$steps[is.na(DT$steps)]=mean(DT$steps,na.rm=TRUE)
newData <- DT
# the same actions but new DT
withoutNA<-aggregate(newData$steps, by = list(newData$date), FUN=sum)
names(withoutNA)<-c("date", "steps")
ggplot(withoutNA, aes(x = steps)) +
  geom_histogram(fill = "blue") +
  labs(title = "Daily Steps (Without missing Values)", x = "Days", y = "Frequency")
```



### Are there differences in activity patterns between weekdays and weekends?

```{r echo=TRUE}
weekend = weekdays(as.Date(newData$date))

weekends=(weekend=="Saturday" | weekend=="Sunday")
weekend[weekends] = "Weekend"
weekend[!weekends] = "Weekday"

newData$weekend=factor(weekend)
```

```{r echo=TRUE}
sumMeans = aggregate(newData$steps,by=list(newData$interval, newData$weekend), mean)

library(lattice)
xyplot(sumMeans$steps ~ sumMeans$interval|sumMeans$dayType,sumMeans,type="l",layout=c(1,2), xlab ="5-Minute Interval", ylab="Average numver of steps")

```
