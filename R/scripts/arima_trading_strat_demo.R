
# Libraries: ----
library(quantmod)
library(forecast)
library(PerformanceAnalytics)









# Signals: ----

look_back = 50;
signals <- returns; signals[,] =NA

for(i in look_back:length(signals)){
  
  # Fit model:
  temp_model = auto.arima(prices[(i-look_back+1):i])
  
  # Predict 1 step:
  pred = forecast(temp_model,1)
  
  prev = prices[i] 
  
  ret_mean = (pred$mean[1]/prev - 1)
  
  if(ret_mean >= 0) signals[i] = 1 else signals[i] = - 1
  
  #ret_low = s$lower[2]/prev -1
  #ret_high =  s$upper[2]/prev -1
  
}



# Strategy returns: ----
strategy_returns = lag(signals) * returns

plot(strategy_returns)
summary(strategy_returns)

strat_perf <- cum_ret(strategy_returns)
buy_n_hold_perf <- cum_ret(returns)

chart_Series(cbind(strat_perf,buy_n_hold_perf))
chart_Series(strat_perf)


plot(strat_perf,type='l')
plot(buy_n_hold_perf)

lines(buy_n_hold_perf)

charts.PerformanceSummary(strategy_returns)
table.Drawdowns(strategy_returns)

# Plots ----
library(ggplot2)
library(plotly)

gdataset <- data.frame(Date = index(strategy_returns),strategy_returns) %>% 
  tail(100)
colnames(gdataset) <- c('Date','Return')

p <- ggplot(gdataset,aes(x=Date,y=Return)) +
  geom_bar(stat = 'identity',color='black')+
  geom_hline(yintercept=0.0003,color='red',linetype='dashed')

ggplotly(p)


  
