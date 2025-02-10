library(dplyr)
# Load required libraries
library(tidyverse)
library(lubridate)
library(forecast)
library(caret)
library(randomForest)


# Importing the data
setwd("/Users/akhilagolla/Desktop/Everything/forecasting/project")
hotel.data <- read.csv("hotel_booking.csv")

# Checking for null values
colSums(is.na(hotel.data))

# Dropping the 'company' column (excessive nulls)
hotel.data <- hotel.data %>% select(-company)
hotel.data <- hotel.data %>% select(-agent)

# Filling NA in 'children' with 0 and dropping rows with missing 'country'
hotel.data$children[is.na(hotel.data$children)] <- 0
hotel.data <- hotel.data %>% filter(!is.na(country))

# Check for null values
colSums(is.na(hotel.data))

#  Converting "reservation_status_date" column to Date type
hotel.data$reservation_status_date <- as.Date(hotel.data$reservation_status_date)

# Aggregating the cancellation count per month
library(dplyr)
library(lubridate)

# Creating a month column from reservation_status_date
hotel.data$month <- floor_date(hotel.data$reservation_status_date, "month")

# Filtering the canceled bookings (is_canceled == 1) and group by month to get the count of cancellations
cancellation_data <- hotel.data %>%
  filter(is_canceled == 1) %>%
  group_by(month) %>%
  summarise(cancellations = n())

# Converting "cancellations" to a time series object
# Data starts from October 2014 and ends in September 2017, so start = c(2014, 10) and end = c(2017, 9)
cancellation.ts <- ts(cancellation_data$cancellations, start = c(2014, 10), frequency = 12)

# Creating a subset of the time series for the training period (e.g., up to September 2016)
cancellation.a <- window(cancellation.ts, end = c(2016, 9))

# Creating a subset of the time series for the validation period (e.g., from October 2016 to September 2017)
cancellation.b <- window(cancellation.ts, start = c(2016, 10))

### NAIVE FORECAST

# Produce Naive forecasts for the validation period
library(forecast)
cancellation.naive <- naive(cancellation.a, h = length(cancellation.b))

# time plot for the cancellations time series
plot(cancellation.ts, xlab = "Time", ylab = "Cancellations", main = "Monthly Cancellations Over Time")

# Adding forecasts for the validation period with a dotted line
lines(cancellation.naive$mean, lwd = 2, lty = 2, col = "blue")

# Adding a vertical line to divide the training and validation periods
abline(v = c(2016.75), col = "red", lty = 2) # Adjust v according to when the training period ends

# Adding text "Training" and "Validation" to the plot accordingly
text(2015.5, max(cancellation.ts) * 0.9, "Training", col = "black")
text(2017, max(cancellation.ts) * 0.9, "Validation", col = "black")

# Calculating RMSE for the validation period
accuracy(cancellation.naive$mean, cancellation.b)



### EXPONENTIAL SMOOTHING

# Running an exponential smoothing model with "cancellation.a" and name it "cancellation.e"
library(forecast)
cancellation.e <- ets(cancellation.a)

# Calculating forecasts for the validation period and name it "cancellation.e.pred"
cancellation.e.pred <- forecast(cancellation.e, h = length(cancellation.b))

# time plot for "cancellation.ts"
plot(cancellation.ts, xlab = "Time", ylab = "Cancellations", main = "Monthly Cancellations Over Time")

# Adding forecasts for the validation period with a dotted line
lines(cancellation.e.pred$mean, lwd = 2, lty = 2, col = "blue")

# Adding a vertical line to divide the training period and the validation period
abline(v = c(2016.75), col = "red", lty = 2) # Adjust v according to when the training period ends

# Adding text "Training" and "Validation" to the plot accordingly
text(2015.5, max(cancellation.ts) * 0.9, "Training", col = "black")
text(2017, max(cancellation.ts) * 0.9, "Validation", col = "black")

# Calculating RMSE for the validation period
accuracy(cancellation.e.pred$mean, cancellation.b)





# ARIMA

library(forecast)


# Fit auto ARIMA
auto_arima_model <- auto.arima(cancellation.ts)

# Summary of the model
summary(auto_arima_model)

# Forecast next 12 months
forecast_values <- forecast(auto_arima_model, h = 12)

# Plot the forecast
plot(forecast_values, main = "ARIMA Forecast")

# Check residuals
checkresiduals(auto_arima_model)



## ARIMAAAA

library(forecast)

# Decompose the time series to inspect for trend/seasonality
plot(stl(cancellation.ts, s.window = "periodic"))

# Split the data into training and validation sets
train.ts <- window(cancellation.ts, start = c(2014, 10), end = c(2016, 9))
valid.ts <- window(cancellation.ts, start = c(2016, 10), end = c(2017, 9))

# Fit ARIMA directly on the training data
auto.arima.model <- auto.arima(train.ts, seasonal = TRUE)

# Forecast using the ARIMA model
arima.forecast <- forecast(auto.arima.model, h = length(valid.ts))

# Plot the original time series with ARIMA forecast
plot(arima.forecast, main = "ARIMA Forecast", xlab = "Time", ylab = "Values")
lines(valid.ts, col = "red", lwd = 2) # Add validation data for comparison

# Check residuals of the ARIMA model
checkresiduals(auto.arima.model)

# Plot residuals explicitly (if needed)
plot(residuals(auto.arima.model), main = "Residuals of ARIMA Model", xlab = "Time", ylab = "Residuals")
abline(h = 0, col = "blue", lwd = 2) # Add horizontal line at zero

summary(auto.arima.model)

# Extract residuals and fitted values from ARIMA model
residuals <- residuals(auto.arima.model)
fitted_values <- fitted(auto.arima.model)

# Plot residuals and fitted values together
plot(residuals, main = "Residuals and Fitted Values", ylab = "Residuals", xlab = "Time")
lines(fitted_values, col = "blue", lwd = 2) # Add fitted values as a line
abline(h = 0, col = "red", lwd = 2, lty = 2) # Horizontal zero line for reference