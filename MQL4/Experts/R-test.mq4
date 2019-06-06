//+------------------------------------------------------------------+
//|                                                       R-test.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <mt4R.mqh>
#include <common_functions.mqh>

#define RPATH "C:\Program Files\R\R-3.5.1\bin\i386\Rterm.exe --no-save"
#define RDEBUG 2

#import "myLibrary"
   int historicalBars(string symbol= "EURUSD",int timeframe=0,string type = NULL , int back=2000);
#import

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH)); 
   Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH)); 
   Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH)); 

   StartR(RPATH, RDEBUG);
   Rx("options(device='windows')");
   Rx("library(ggplot2)");
   //Rx("ggplot(data.frame(x=rnorm(100),y=1:100),aes(x=x,y=y))+geom_point()");
   
   historicalBars();
   Rx("plot(prices)");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
