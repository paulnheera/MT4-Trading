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

void getHistoricalData(){

   double prices[];
   string times[];
   int ishift;
   int back = 2000;
   //string Symbol = Symbol();
   
   ArrayResize(prices, back);
   ArrayResize(times, back);
   
   // Fill the prices array: Start with previous bar (not current).
    for (int i=0; i<back; i++){
      ishift = iBarShift(Symbol(),0, Time[i]);
      prices[i] = iClose(Symbol(), 0, ishift);
      times[i] = TimeToStr(iTime(Symbol(),0,ishift),TIME_DATE|TIME_MINUTES);
    }
    
    // Then copy it over to R:
    Rv("prices", prices);  // Copy vector over to R.
    Rf("times",times); // Copy time vector to R
    Rs("symbol",Symbol());
    Ri("period",Period());
    
    Rx("times = as.character(times)");
    // Convert vector to time series:
    Rx("ts <- xts(rev(prices),order.by=rev(as.Date(times,'%Y.%m.%d %H:%M')))");
    Rx("colnames(ts) = 'EURUSD'");
    
    // Get timezone from MT4/Server.
    
    // Save the timeseries object:
    Rx("saveRDS(ts,paste0('C:/Users/Paul Nheera/repos/MT4-Trading/data/',symbol,period,'.rds'))");
    
    // Plot the latest timeseries:
    Rx("plot(rev(prices),type='l')");

}
