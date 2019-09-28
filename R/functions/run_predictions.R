# Load Libraries: ----
library(forecast)
library(quantmod)

runPredictions <- function(x,lookback=40){
  
  predictions <- x; predictions[,]= NA
  
  for(i in lookback:length(predictions)){
    
    # Fit model:
    temp_model = auto.arima(x[(i-lookback+1):i])
    
    # Predict 1 step:
    pred = forecast(temp_model,1)
    
    # Store prediction:
    predictions[i] = pred$mean[1]
    
  }
  
  # Predictions:
  predictions = lag(predictions)
  
  return(predictions)
  
}

# x = readRDS('data/EURUSD1440.rds')
# 
# # Target Variable: change
# y = ROC(x)
# 
# # 
# plot(y,type='l')
# 
# hist(y,breaks = 100)
# 
# # Test the function:
# y_hat <- runPredictions(y,40)
# 
# plot(y_hat,type='l')
# 
# hist(y_hat,breaks=100)
