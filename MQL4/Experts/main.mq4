//+------------------------------------------------------------------+
//|                                                         main.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// Define:
#define MAGICMA  20191111
#define RPATH "C:\Program Files\R\R-3.5.1\bin\i386\Rterm.exe --no-save"
#define RDEBUG 2

// Load functions:
#include <mt4R.mqh>
#include <common_functions.mqh>
#include <my_functions.mqh>

int signal;
int position;


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
//| Calculate open positions                                         |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
//---
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
//--- return orders volume / Number of trades:
   if(buys>0) return(buys);
   else       return(-sells);
  }
  
//+------------------------------------------------------------------+
//| Check for close order conditions                                 |
//+------------------------------------------------------------------+
void CheckForClose()
  {

//--- go trading only for first tiks of new bar
   //if(Volume[0]>1) return;
   
//---
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      //--- check order type 
      if(OrderType()==OP_BUY)
        {
           
         if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,White))
            Print("OrderClose error ",GetLastError());
           
         break;
        }
      if(OrderType()==OP_SELL)
        {
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,White))
               Print("OrderClose error ",GetLastError());
               
         break;
        }
     }
//---
  }
  
//+------------------------------------------------------------------+
//| Check for open order conditions                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {
   int    res;
//--- go trading only for first tiks of new bar
   //if(Volume[0]>1) return;

//--- sell conditions
   if(signal==-1)
     {
      res=OrderSend(Symbol(),OP_SELL,0.01,Bid,3,0,0,"",MAGICMA,0,Red);
      return;
     }
//--- buy conditions
   if(signal==1)
     {
      res=OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,0,"",MAGICMA,0,Blue);
      return;
     }
//---
  }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   // Start R and set options:
   StartR(RPATH, RDEBUG);
   Rx("options(device='windows')");
   
   // Check current positions:
   position = CalculateCurrentOrders(Symbol());
   Print("Current postion: " + position);  
   
   // Load required libaries in R:
   //Rx("library(forecast); library(quantmod)");
   
   // Source functions:
   Rx("source('C:/Users/Paul Nheera/repos/MT4-Trading/R/functions/arima_trading_strategy.R')");
   
   
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
      // Strategy code here:
      
      // Send Historical Data to R:
      getHistoricalData();
      
      Rx("saveRDS(prices,'C:/Users/Paul Nheera/repos/MT4-Trading/data/prices.rds')");
      Rx("saveRDS(times,'C:/Users/Paul Nheera/repos/MT4-Trading/data/times.rds')");
      
      Rx("signal = arima_trading_strategy(rev(prices),40)");
      signal = Rgi("signal");
      position = CalculateCurrentOrders(Symbol());
      
      Rx("plot(rev(prices),type='l')");
      
      
      if(signal == 1 & position != -1){
      // Switch to long postion:
         
         // Close short position:
         CheckForClose();
         
         // Open long position:
         CheckForOpen();
         
         
      }
      else if(signal == -1 & position != 1){
         // Switch to short position:
         
         // Close long position:
         CheckForClose();
         
         // Open short position:
         CheckForOpen();
         
      }
      
   }
   
  }
//+------------------------------------------------------------------+
