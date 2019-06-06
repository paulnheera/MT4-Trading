#
# ARIMA Trading Strategy:
#

#
# Generates a signal from the ARIMA trading strategy
#

# Load Libraries: ----
library(forecast)
library(quantmod)

arima_trading_strategy <- function(ts,lookback){
  
  ts <- tail(ts,lookback)
  
  model = auto.arima(ts)
  pred = forecast(model,1) # Forecast one step ahead.
  pred = as.numeric(pred$mean)
  
  # Criteria:
  ret_mean = (pred/tail(ts,1))-1
  
  # Signal:
  signal <- ifelse(ret_mean >0,1,-1)
  
  return(signal)
  
}
