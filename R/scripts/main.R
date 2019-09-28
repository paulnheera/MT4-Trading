#
# Main
#

# Libraries: ----
library(quantmod)
library(forecast)
library(PerformanceAnalytics)

source(file.path('R','functions','cum_ret.R'))
source(file.path('R','functions','arima_trading_strategy.R'))
source(file.path('R','functions','get_trades.R'))

getSymbols("EUR/USD",src="oanda")
prices <- EURUSD

backtest <- runBacktest(EURUSD60,40)



lookbacks <- list(10,20,30,40,50,60,70,80,90,100)
backtests <- lapply(lookbacks,FUN='runBacktest',prices=EURUSD60)


backtest <- backtests[[4]]
strat_ret <- backtest$strategy_returns
signals <- backtest$signals
positions <-lag(signals)

trades <- get_trades(positions,strat_ret)

strat_perf <- cum_ret(trades$`net return`)
plot(strat_perf,type='l')
lines(cum_ret(trades$return),type='l')

# --- A ggplot ---
library(ggplot2)
library(plotly)

a <- EURUSD60
b <- backtest$predicted

c <- merge.xts(a,lag(b))

d <- data.frame(Time=index(c),c)
colnames(d) <- c('Time','Close','Pred')


p <- ggplot(d,aes(x=Time,y=Close)) +
        geom_line()+
        geom_point(aes(y=Pred),col='red')+
        geom_line(aes(y=Pred),col='red')

ggplotly(p)
