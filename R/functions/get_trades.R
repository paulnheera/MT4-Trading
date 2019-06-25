#******************
# Identify Trades :
#******************

library(quantmod)
library(dplyr)
library(PerformanceAnalytics)

options(scipen = 999)

get_trades <- function(positions,strat_ret){
  
  x = positions
  colnames(x) = 'positions'
  x[which(is.na(x))] = 0
  
  temp = (x != lag(x))
  
  start <- index(x)[which(temp==TRUE)]
  end <- index(x)[which(temp==TRUE)-1]
  
  df = data.frame(start=start,end=end)
  
  df <- df %>% 
    mutate(end =lead(end))
  
  sig_dif = data.frame(index(x),x)
  
  df <- df %>% 
    left_join(sig_dif, by=c('start' = 'index.x.'))
  
  trades = df
  
  # Calculate trade returns:
  trades = trades %>%
    mutate(return = NA)
  
  # Returns:
  for(i in 1:nrow(trades)){
    trades$return[i] = Return.cumulative(na.trim(strat_ret[paste0(trades$start[i],"::",trades$start[i])]))
  }
  
  # Costs & Net Return:
  trades <- trades %>% 
    mutate(id = row_number())
  
  trades <- trades %>% 
    mutate(`net return` = return - 0.0002)
  
  return(trades)
}

     