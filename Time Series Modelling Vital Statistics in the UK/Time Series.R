# Install and load necessary packages
install.packages("readxl")
install.packages("TTR")
install.packages("ggplot2")
install.packages("forecast")

library(readxl)
library(TTR)
library(forecast)
library(tseries)

### 1- EDA - Exploratory Data Analysis

# 1. Load the data set
death_stats_data <- read_excel("DeathStats.xlsx", skip = 5)

# 2. Drop unnecessary columns
death_stats_data <- death_stats_data[, 1:3]

# 3. Inspect the data set
head(death_stats_data)
summary(death_stats_data)
str(death_stats_data)

# 4. Pre-Processing: Replace missing values with linear interpolation for UK deaths
library(zoo)
UK_death_counts <- death_stats_data$'Number of deaths: United Kingdom'
UK_death_counts <- na.approx(UK_death_counts)
UK_death_counts


# 5. Reading& Plotting: Time Series Data
uk_death_timeseries <- ts(UK_death_counts, start = c(1886),frequency = 12) 

england_wales_death_counts <- death_stats_data$'Number of deaths: England and Wales'
england_wales_timeseries <- ts(england_wales_death_counts, start = c(1838),frequency = 12)

plot(uk_death_timeseries, col = "blue", main = "Number of Deaths: United Kingdom", xlab = "Year", ylab = "Deaths")
plot(england_wales_timeseries, col = "red", main = "Number of Deaths: England and Wales", xlab = "Year", ylab = "Deaths")


# Calculate the 3-year Simple Moving Average (SMA)
uk_death_timeseries_SMA3 <- SMA(uk_death_timeseries, n = 3)
england_wales_timeseries_SMA3 <- SMA(england_wales_timeseries, n = 3)

# Plot the original UK deaths time series (blue) and overlay the 3-year SMA (purple)
plot(uk_death_timeseries, main = "UK Deaths with 3-Year Moving Average", 
     xlab = "Year", ylab = "Number of Deaths", col = "lightblue", type = "l", lwd = 2)
lines(uk_death_timeseries_SMA3, col = "pink", lwd = 2)  # Overlay 3-year SMA

plot(england_wales_timeseries, main = "England & Wales Deaths with 3-Year Moving Average", 
     xlab = "Year", ylab = "Number of Deaths", col = "pink", type = "l", lwd = 2)
lines(england_wales_timeseries_SMA3, col = "green", lwd = 2)  # Overlay 3-year SMA



#### Decomposition 
uk_death_decomposed <- decompose(uk_death_timeseries, type = "additive")
plot(uk_death_decomposed)
england_wales_decomposed <- decompose(england_wales_timeseries, type = "additive")
plot(england_wales_decomposed)


#### Seasonally adjusted data
uk_death_timeseries_seasonally_adjusted <- uk_death_timeseries - uk_death_timeseries_SMA3
plot(uk_death_timeseries_seasonally_adjusted, main = "Seasonally Adjusted Deaths (UK)", col = "green", xlab = "Year", ylab = "Deaths")

england_wales_timeseries_seasonally_adjusted <- england_wales_timeseries - england_wales_timeseries_SMA3
plot(england_wales_timeseries_seasonally_adjusted, main = "Seasonally Adjusted Deaths (England and Wales)", col = "pink", xlab = "Year", ylab = "Deaths")



#### Time Series Modeling
# Stationarity Testing, Perform the Augmented Dickey-Fuller (ADF) test. 
adf.test(uk_death_timeseries)
adf.test(england_wales_timeseries)

acf(uk_death_timeseries)
acf(england_wales_timeseries)

pacf(uk_death_timeseries)
pacf(england_wales_timeseries)

# As it's non-stationarity
uk_death_diff <- diff(uk_death_timeseries)
england_wales_diff <- diff(england_wales_timeseries)

# Plot the ACF and PACF to assess autocorrelation.
plot.ts(uk_death_diff, main = "Differenced UK Deaths")
plot.ts(england_wales_diff, main = "Differenced England & Wales Deaths")


# Re-check stationarity of difference series
adf.test(uk_death_diff)
adf.test(england_wales_diff)



### Forecasting

# ARIMA Model
uk_arima_model  <- auto.arima(uk_death_diff)
england_wales_arima_model <- auto.arima(england_wales_diff)

summary(uk_arima_model)
summary(england_wales_arima_model)


# Check residuals
checkresiduals(uk_arima_model)
checkresiduals(england_wales_arima_model)

# Forecast the next 10 years
uk_arima_death_forecast <- forecast(uk_arima_model, h = 10)
england_wales_arima_forecast <- forecast(england_wales_arima_model, h = 10)

plot(uk_arima_death_forecast, main = "ARIMA Forecast: UK Deaths")
plot(england_wales_arima_forecast, main = "ARIMA Forecast: England & Wales Deaths")

# plot a correlogram
acf(uk_death_diff, lag.max = 20, main = "Correlogram of Differenced UK Deaths")
acf(england_wales_diff, lag.max = 20, main = "Correlogram of Differenced England & Wales Deaths")
pacf(uk_death_diff, lag.max = 20, main = "Partial LAg/ACF UK Deaths")
pacf(england_wales_diff, lag.max = 20, main = "Partial ACF/Lag England & Wales Deaths")
# Get the autocorrelation values for UK deaths (up to 20 lags, without plotting)


uk_acf_values <- acf(uk_death_diff, lag.max = 20, plot = FALSE)
england_wales_acf_values <- acf(england_wales_diff, lag.max = 20, plot = FALSE)

uk_acf_values
england_wales_acf_values
mean_forecast_uk <- mean(uk_arima_death_forecast$mean)
mean_forecast_englandwales <- mean(england_wales_arima_model$mean)

print(mean_forecast_uk)
print(mean_forecast_englandwales)
print(uk_acf_values)  # Print autocorrelation values for UK deaths
print(england_wales_acf_values)  # Print autocorrelation values for England & Wales deaths


# Evaluate accuracy for ARIMA forecasts
cat("\nAccuracy for England & Wales ARIMA model:\n")
accuracy(uk_arima_death_forecast)
accuracy(england_wales_arima_model)

#### Holt Winter

# Apply Holt-Winters model for UK deaths
uk_holt_winters <- HoltWinters(uk_death_timeseries, gamma = FALSE)
england_wales_holt_winters <- HoltWinters(england_wales_timeseries, gamma = FALSE)

summary(uk_holt_winters)
summary(england_wales_holt_winters)

# Check residuals for UK ARIMA model
checkresiduals(uk_holt_winters)
checkresiduals(england_wales_holt_winters)

uk_holt_winters_forecast <- forecast(uk_holt_winters, h = 10)
england_wales_holt_winters_forecast <- forecast(england_wales_holt_winters, h = 10)


plot(uk_holt_winters_forecast, main = "Holt-Winters Forecast: UK Deaths")
plot(england_wales_holt_winters_forecast, main = "Holt-Winters Forecast: England & Wales Deaths")



# Evaluate accuracy for Holt-Winters & ARIMA forecasts
accuracy(uk_arima_death_forecast)
accuracy(england_wales_arima_model)
accuracy(uk_holt_winters_forecast)
accuracy(england_wales_holt_winters_forecast)





