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
   int ishift;
   int back = 2000;
   //string Symbol = Symbol();
   
   ArrayResize(prices, back);
   
   // Fill the prices array:
    for (int i=0; i<back; i++){
      ishift = iBarShift(Symbol(),0, Time[i]);
      prices[i] = iClose(Symbol(), 0, ishift);
      // insert line to get time:
      //time[i] = iTime(Symbol(),0,ishift);
    }
    
    // Then copy it over to R:
    Rv("prices", prices);  // Copy vector over to R.
    // Rv("time",time); // Copy time vector to R
    
    // Get timezone from MT4/Server.
    // Convert vector to time series:
    // Rx("ts = xts(x=prices,order.by=time); // Have to think about time zone
    
    // Plot the latest timeseries:
    Rx("plot(rev(prices),type='l')");

}
