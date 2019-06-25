#*************************
# ARIMA Trading Strategy:
#*************************


# Run the arima strategy and returns: signals and strategy returns


# Load Libraries: ----
library(forecast)
library(quantmod)

# Backtest Function: ----
runBacktest <- function(prices,look_back=40){
  
  returns <- ROC(prices,type='discrete')
  
  signals <- returns; signals[,] =NA
  
  for(i in look_back:length(signals)){
    
    # Fit model:
    temp_model = auto.arima(prices[(i-look_back+1):i])
    
    # Predict 1 step:
    pred = forecast(temp_model,1)
    
    prev = prices[i] 
    
    ret_mean = (pred$mean[1]/prev - 1)
    
    if(ret_mean >= 0) signals[i] = 1 else signals[i] = -1
    
    #ret_low = s$lower[2]/prev -1
    #ret_high =  s$upper[2]/prev -1
    
  }
  
  # Strategy Returns:
  strategy_returns = lag(signals) * returns
  
  return(list(signals = signals,strategy_returns = strategy_returns))
  
}
