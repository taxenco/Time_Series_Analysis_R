install.packages("forecast")
library(forecast)
setwd('C:/Users/carlo/Desktop/Data science/ASDM/Time series')
Thai_tourist_full <-read.csv("Thaitourism.csv", header= TRUE)

# Inspect Dataset

names(Thai_tourist_full) 
head(Thai_tourist_full) 
tail(Thai_tourist_full) 
str(Thai_tourist_full)
summary(Thai_tourist_full)

# Filter data that only contains UK tourists data.
Thai_UK<-subset(Thai_tourist_full,nationality=="UnitedKingdom")
names(Thai_UK) 
head(Thai_UK) 
tail(Thai_UK) 
str(Thai_UK) 
summary(Thai_UK)

# Split data in 2 parts, traning dataset and validation dataset. The traning dataset will contain years 2010,2011,2012,2013,2014,2015 and the validate dataset will only contain year 2016.
UK_2010_2015<-subset(Thai_UK,year %in% c(2010,2011,2012,2013,2014,2015))
head(UK_2010_2015)
tail(UK_2010_2015)

UK_2016<-subset(Thai_UK,year == 2016)
head(UK_2016)
tail(UK_2016)
# Convert data frame into time series object for training and validate datasets.
UK_2010_2015.ts <-ts(UK_2010_2015[,3:5], frequency = 12, start = c(2010,1), end = c(2015,12))
head(UK_2010_2015.ts)
tail(UK_2010_2015.ts)

UK_2016.ts <-ts(UK_2016[,3:5], frequency = 12, start = c(2016,1), end = c(2016,12))
head(UK_2016.ts)
tail(UK_2016.ts)

#Ploting time series Monthly
plot.ts(UK_2010_2015.ts[,3], main = "Monthly UK tourists entering Thailand", xlab = "Year", ylab = "No. of tourists ")

#Ploting time series Quarterly
UK_2010_2015.ts.qtr <-aggregate(UK_2010_2015.ts, nfrequency=4)
plot.ts(UK_2010_2015.ts.qtr[,3], main = "Quarterly  UK tourists entering Thailand", xlab = "Year", ylab = "No. of tourists ")
#Ploting time series Yearly
UK_2010_2015.ts.yr <-aggregate(UK_2010_2015.ts, nfrequency=1)
plot.ts(UK_2010_2015.ts.yr[,3], main = "Yearly  UK tourists entering Thailand", xlab = "Year", ylab = "No. of tourists ")

# Check seasonality 

#A seasonal plot 

seasonplot(UK_2010_2015.ts[,3], year.labels = TRUE, year.labels.left=TRUE, col=1:10,main = "Monthly UK tourists entering Thailand -seasonplot",xlab = "Month", ylab = "No. of tourists")

#Seasonal plot variation
ggseasonplot(UK_2010_2015.ts[,3], year.labels = TRUE, year.labels.left=TRUE,col=1:10,main ="Monthly UK tourists entering Thailand -seasonplot", xlab = "Month", ylab = "No. of tourists",polar=TRUE)

# ggsubseriesplot The  horizontal  lines  indicate  the  means  for  each  month

ggsubseriesplot(UK_2010_2015.ts[,3], main= "Monthly UK tourists entering Thailand -seasonplot", xlab = "Month", ylab = "No. of tourists")

# Boxplot

ggsubseriesplot(UK_2010_2015.ts[,3], main= "Monthly UK tourists entering Thailand -seasonplot", xlab = "Month", ylab = "No. of tourists")boxplot(UK_2010_2015.ts[,3] ~ cycle(UK_2010_2015.ts[,3]), col=1:12,main = "Monthly UK tourists entering Thailand -Boxplot", xlab = "Month", ylab = "No. of tourists")

#Decomposing Time Series 

plot(decompose(UK_2010_2015.ts[,3]))

# Forecasting methods-Mean forecasting

UK_2010_2015.fit.a <-meanf(UK_2010_2015.ts[,3], h = 12)
summary(UK_2010_2015.fit.a)
UK.f0 <-forecast(UK_2010_2015.fit.a, h = 12, level = c(80,95))
UK.f0
UK.f0 <-forecast(UK_2010_2015.fit.a, h = 12, level = c(80,95))
plot.ts(UK_2010_2015.ts[,3], main = "Monthly UK tourists Forecasting -Simple Average", xlab = "Year", ylab = "No. of tourists",  xlim = c(2010, 2017))
lines(UK.f0$fitted, col = "blue")
lines(UK.f0$mean, col = "red")
#Accuracy
accuracy(UK.f0, UK_2016.ts[,3]) 


#Forecasting methods-Time series linear model 
UK_2010_2015.fit.lm <-tslm(UK_2010_2015.ts[,3] ~ trend)
summary(UK_2010_2015.fit.lm)
UK.f1 <-forecast(UK_2010_2015.fit.lm, h = 12, level = c(80,95))
UK.f1
#Ploting Linear model
plot.ts(UK_2010_2015.ts[,3], main = "Monthly UK tourists Forecasting -linear model", xlab = "Year", ylab = "No. of tourists",  xlim = c(2010, 2017))
lines(UK.f1$fitted, col ="blue")
lines(UK.f1$mean, col = "red")
# Accuracy
accuracy(UK.f1, UK_2016.ts[,3])
#Forecasting methods-Time series linear model with seasonality
UK_2010_2015.fit.lm2  <-tslm(UK_2010_2015.ts[,3]~ trend + season)
summary(UK_2010_2015.fit.lm2)
UK.f2 <-forecast(UK_2010_2015.fit.lm2 , h = 12, level = c(80,95))
UK.f2
# Ploting linear model with seasonality
plot.ts(UK_2010_2015.ts[,3], main = "Monthly UK tourists Forecasting -linear model with Seasonality", xlab = "Year", ylab = "No. of tourists", xlim = c(2010, 2017))
lines(UK.f2$fitted, col = "blue")
lines(UK.f2$mean, col = "red")
# Accuracy linear model with seasonality
accuracy(UK.f2, UK_2016.ts[,3])

#Forecasting methods-Holt-Winters' Seasonal method
UK_2010_2015.fit.hw <-hw(UK_2010_2015.ts[,3], h = 12, seasonal = "additive")
summary(UK_2010_2015.fit.hw)
UK.f3 <-forecast(UK_2010_2015.fit.hw , h = 12, level = c(80,95))
UK.f3
#Ploting Holt-Winters' Seasonal method
plot.ts(UK_2010_2015.ts[,3], main = "Monthly UK tourists Forecasting -Holt-Winters", xlab = "Year", ylab = "No. of tourists", xlim = c(2010, 2017))
lines(UK.f3$fitted, col ="blue")
lines(UK.f3$mean, col = "red")
#accuracy Holt-Winters' Seasonal method
accuracy(UK.f3, UK_2016.ts[,3])

# Comparison of Forecast Errors

accuracy(UK.f0, UK_2016.ts[,3])
accuracy(UK.f1, UK_2016.ts[,3])
accuracy(UK.f2, UK_2016.ts[,3])
accuracy(UK.f3, UK_2016.ts[,3])