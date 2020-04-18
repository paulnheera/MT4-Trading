//+------------------------------------------------------------------+
//|                                                 my_functions.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <mt4R.mqh>
#include <common_functions.mqh>

/* 

Description: This function download historical data

*/


//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//----------------------
// Get Historical Data:
//----------------------

void getHistoricalData(int timeframe=0){
   //Include timeframe as an input argument.
   
   
   Rx("library(quantmod)");
   Rx("library(readr)");
   Rx("library(dplyr)");
   
   double prices[];
   double open[];
   double high[];
   double low[];
   double close[];
   double volume[];
   string times[];
   int ishift;
   int back = 2000;
   int original_timeframe = Period();
   //string Symbol = Symbol();
   
   // First Open the chart:
   //ChartSetSymbolPeriod(0,NULL,timeframe);
   
   Print("Inside function");
   ArrayResize(prices, back-1);
   ArrayResize(times, back-1);
   ArrayResize(open, back-1);
   ArrayResize(high, back-1);
   ArrayResize(low, back-1);
   ArrayResize(close, back-1);
   ArrayResize(volume, back-1);
   
   // Fill the prices array: Start with previous bar (not current).
    for (int i=1; i<back; i++){
      ishift = iBarShift(Symbol(),timeframe, Time[i]);
      prices[i-1] = iClose(Symbol(), timeframe, ishift);
      open[i-1] = iOpen(Symbol(), timeframe, ishift);
      high[i-1] = iHigh(Symbol(), timeframe, ishift);
      low[i-1] = iLow(Symbol(), timeframe, ishift);
      close[i-1] = iClose(Symbol(), timeframe, ishift);
      volume[i-1] = iVolume(Symbol(), timeframe, ishift);
      times[i-1] = TimeToStr(iTime(Symbol(),timeframe,ishift),TIME_DATE|TIME_MINUTES);
      //Print(i);
    }
    
    if(timeframe == 0){
      timeframe = Period();
    }
    
    // Set the chart back to the orignal timeframe:
    //ChartSetSymbolPeriod(0,NULL,original_timeframe);
    
    // Then copy it over to R:
    Rv("prices", prices);  // Copy vector over to R.
    Rv("open", open);
    Rv("high", high);
    Rv("low", low);
    Rv("close", close);
    Rv("volume", volume);
    Rf("times",times); // Copy time vector to R
    Rs("symbol",Symbol());
    Ri("period",timeframe);
    
    Rx("times = as.character(times)");
    
    // Create data frame:
    Rx("df = data.frame(Open=rev(open),High=rev(high),Low=rev(low),Close=rev(close),Volume=rev(volume))");
    // Convert vector to time series:
    Rx("ts <- xts(df,order.by=rev(as.POSIXct(times,tryFormats ='%Y.%m.%d %H:%M')))");
    Rx("colnames(ts) = c('Open','High','Low','Close','Volume')");
    
    // Remove duplicates:
    
    // Get timezone from MT4/Server.
    
    // Save the timeseries object:
    Rx("saveRDS(ts,paste0('C:/Users/paul/repos/MT4-Trading/data/',symbol,period,'.rds'))");
    Rx("df = data.frame(Time = as.character(index(ts)), ts)");
    Rx("df=distinct(df)");
    Rx("write_csv(df,paste0('C:/Users/paul/repos/MT4-Trading/data/',symbol,period,'.csv'))");
    
    // Plot the latest timeseries:
    //Rx("plot(rev(prices),type='l')");
    
    //Confirm the download is done:
    Print("Data Download Done!");

}
