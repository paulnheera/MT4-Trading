//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#define RPATH "C:\Program Files\R\R-3.6.2\bin\i386\Rterm.exe --no-save"
#define RDEBUG 2

#include <mt4R.mqh>
#include <common_functions.mqh>
#include <my_functions.mqh>

//+------------------------------------------------------------------+
//| On new bar function
//+------------------------------------------------------------------+
datetime NewBarTime=TimeCurrent(); // Global Variable

bool IsNewBar(){
   if(NewBarTime == iTime(Symbol(),0,0)) return false;
   else{
      NewBarTime = iTime(Symbol(),0,0);
      return true;
   }
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("Before initializing R");
   StartR(RPATH, RDEBUG);
   Rx("options(device='windows')");
   
   Print("Before function");
   getHistoricalData();
   Print("After function");
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   if (UninitializeReason() != REASON_CHARTCHANGE){
      StopR();
   }
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      if(IsNewBar()){
         //getHistoricalData();
         getHistoricalData(30);
         getHistoricalData(60);
         getHistoricalData(240);
         getHistoricalData(1440);
      }
   
  }
//+------------------------------------------------------------------+
