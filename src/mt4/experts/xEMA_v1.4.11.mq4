//+------------------------------------------------------------------+
//|                                                     xEMA         |
//|                                   Copyright (c) 2012, Da Monster |
//|                                         mtdlp@hotmail.com        |
//+------------------------------------------------------------------+
// 1.4.8 : Add Log File from 1.4.7

#property copyright "Copyright (c) 2012, Da Monster"
#property link      "mtdlp@hotmail.com"

#include <aceUtil_2.0.mqh>
#include <aceOrderManager_3.0.mqh>
#include <aceRiskManager_2.0.mqh>


#define MAGIC   30001
#define COMMENT "xEMA_1.4.11"

extern double eRiskPerTrade = 0.02;
extern double eStopLossBase = 0.5;
extern int eDigits = 3;

//extern double Lots = 0.1;
extern int Slippage = 10;

extern int FastMAPeriod = 20;
extern int SlowMAPeriod = 200;

extern int BBPeriod = 20;
extern int BBDev = 1;
extern string instance = "default";
extern int stopLossPoints = 300;
extern int takeProfitPoints = 300;
extern double minChange=0.010;

// global variable
bool hasPendingSell=false;
bool hasPendingBuy= false;

bool useDelayedBuyExit=false;
bool useDelayedSellExit= false;

bool hasGoldenCrossed = false;
bool hasDeadCrossed = false;
bool doneForThisCycle = false;

int gLogFileHandle = 0;// Uninitialized
string gLogFileName = "";

void ClosePositions(bool closeBuy, bool closeSell)
{
   for(int i=0; i< OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) break;
      if(OrderMagicNumber() != MAGIC || OrderSymbol() != Symbol()) continue;

      if(OrderType()==OP_BUY && closeBuy== true)
      {
         OrderClose(OrderTicket(),OrderLots(),Bid,0,White);         
         hasPendingBuy = false;
         break;
      }
      if(OrderType()==OP_SELL && closeSell == true)
      {
         OrderClose(OrderTicket(),OrderLots(),Ask,0,White);
         hasPendingSell=false;         
         break;
      }
      if(OrderType()==OP_BUYLIMIT && closeBuy== true)
      {
         OrderDelete(OrderTicket());
         hasPendingBuy = false;
         break;
      }
      if(OrderType()==OP_SELLLIMIT && closeSell == true)
      {
         OrderDelete(OrderTicket());
         hasPendingSell=false;
         break;
      }
   }
}

void xTrailingStop(double rawNewStopPrice)
{
    double newStopPrice = NormalizeDouble(rawNewStopPrice, Digits);         
    //newStopPrice = 0;
             
    for(int i=0; i<OrdersTotal(); i++)
    {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MAGIC) continue;
      double currStopLoss = OrderStopLoss();
            
      if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT)
      {
         //newStopPrice = NormalizeDouble(MathMin(rawNewStopPrice, OrderOpenPrice( ) - stopLossPoints * Point), Digits);
         newStopPrice = NormalizeDouble((Close[0]-stopLossPoints* Point), Digits);
         if(newStopPrice > currStopLoss || currStopLoss == 0)
         {
            aceOrderModify(newStopPrice, 0, MAGIC);
            string status1 = "xTrailingStop_buy["+currStopLoss+"]--->>>"+ "newStopPrice["+newStopPrice+"]";
            Print (status1);
            break;
         }         
      }
      if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT)
      {
         //newStopPrice = NorealizeDouble(MathMin(rawNewStopPrice, OrderOpenPrice( ) + stopLossPoints * Point), Digits);
         newStopPrice = NormalizeDouble((Close[0]+stopLossPoints* Point), Digits);
         if(newStopPrice < currStopLoss || currStopLoss == 0)
         {
            aceOrderModify(newStopPrice, 0, MAGIC);
            string status2 = "xTrailingStop_sell["+currStopLoss+"]--->>>"+ "newStopPrice["+newStopPrice+"]";
            Print (status2);
            break;
         }
       }
     }
}

int init()
{
   // 0. create a new log file, the convention follows:
   //     algoName_version_instance_timestamp   
   gLogFileName = aceGetLogFileName(COMMENT, instance, Symbol(), "0");
   Print ("Log File : " + gLogFileName);
   gLogFileHandle = FileOpen(gLogFileName, FILE_WRITE);
   if(gLogFileHandle > 0)
   {
      string line="File created[" + gLogFileHandle +"]:" + gLogFileName;      
      Print(line);
      FileClose(gLogFileHandle);
      gLogFileHandle = FileOpen(gLogFileName, FILE_READ | FILE_WRITE |  FILE_CSV);
      line="File opened for write[" + gLogFileHandle +"]:" + gLogFileName;  
      Print(line);
      aceLog(gLogFileName,(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)));   
      //FileFlush(gLogFileHandle);
      
   }else
   {
      Print("Failed to open a new log file : " + gLogFileName);
   }
}


int start()
{
   if(gLogFileHandle == 0)
   {  
     Print("No File Opened yet !!!");
     return (0);   
   }
   
   //if(TimeHour(Time[0])>= 15 || TimeHour(Time[0])>= 4) return (0);
   string hbmsg= "xEMA_" + instance +"_" +IsTradeAllowed();
   //if(MathMod(Volume[0], 40)==0) Print(hbmsg); 
   //get my current NetPostition
   double pos = aceCurrentOrders(MY_ALLPOS, MAGIC);   

   double fastMA0 = iMA(NULL, 0, FastMAPeriod, 0, MODE_SMA, PRICE_WEIGHTED, 0);
   double fastMA1 = iMA(NULL, 0, FastMAPeriod, 0, MODE_SMA, PRICE_WEIGHTED, 1);
   double fastMA2 = iMA(NULL, 0, FastMAPeriod, 0, MODE_SMA, PRICE_WEIGHTED, 2);
   double fastMA3 = iMA(NULL, 0, FastMAPeriod, 0, MODE_SMA, PRICE_WEIGHTED, 3);
   
   double slowMA0 = iMA(NULL, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_WEIGHTED, 0);
   double slowMA1 = iMA(NULL, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_WEIGHTED, 1);
   double slowMA2 = iMA(NULL, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_WEIGHTED, 2);
   double slowMA3 = iMA(NULL, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_WEIGHTED, 3);

   double bbU0 = iBands(NULL, 0, BBPeriod, BBDev, 0, PRICE_TYPICAL, MODE_UPPER, 1);
   double bbU1 = iBands(NULL, 0, BBPeriod, BBDev+1, 0, PRICE_TYPICAL, MODE_UPPER, 1);
   double bbU2 = iBands(NULL, 0, BBPeriod, BBDev+2, 0, PRICE_TYPICAL, MODE_UPPER, 1);
   double bbU3 = iBands(NULL, 0, BBPeriod, BBDev+3, 0, PRICE_TYPICAL, MODE_UPPER, 1);
   double bbU4 = iBands(NULL, 0, BBPeriod, BBDev+4, 0, PRICE_TYPICAL, MODE_UPPER, 1);
   
   double bbL0 = iBands(NULL, 0, BBPeriod, BBDev, 0, PRICE_TYPICAL, MODE_LOWER, 1);
   double bbL1 = iBands(NULL, 0, BBPeriod, BBDev+1, 0, PRICE_TYPICAL, MODE_LOWER, 1);
   double bbL2 = iBands(NULL, 0, BBPeriod, BBDev+2, 0, PRICE_TYPICAL, MODE_LOWER, 1);
   double bbL3 = iBands(NULL, 0, BBPeriod, BBDev+3, 0, PRICE_TYPICAL, MODE_LOWER, 1);
   double bbL4 = iBands(NULL, 0, BBPeriod, BBDev+4, 0, PRICE_TYPICAL, MODE_LOWER, 1);

   double bMid = iMA(NULL, 0, BBPeriod, 0, MODE_SMA, PRICE_TYPICAL, 0);

   double MACD_V0=iMACD(NULL,0,FastMAPeriod,SlowMAPeriod,FastMAPeriod,PRICE_WEIGHTED,MODE_MAIN,0);
   double MACD_S0=iMACD(NULL,0,FastMAPeriod,SlowMAPeriod,FastMAPeriod,PRICE_WEIGHTED,MODE_SIGNAL,0);
   
   double MACD_V1=iMACD(NULL,0,FastMAPeriod,SlowMAPeriod,FastMAPeriod,PRICE_WEIGHTED,MODE_MAIN,1);
   double MACD_S1=iMACD(NULL,0,FastMAPeriod,SlowMAPeriod,FastMAPeriod,PRICE_WEIGHTED,MODE_SIGNAL,1);

   double MACD_V2=iMACD(NULL,0,FastMAPeriod,SlowMAPeriod,FastMAPeriod,PRICE_WEIGHTED,MODE_MAIN,2);
   double MACD_S2=iMACD(NULL,0,FastMAPeriod,SlowMAPeriod,FastMAPeriod,PRICE_WEIGHTED,MODE_SIGNAL,2);      
   
   double ADX_M0 = iADX(NULL,0,FastMAPeriod, PRICE_CLOSE, MODE_MAIN, 0);
   double ADX_S0 = iADX(NULL,0,FastMAPeriod, PRICE_CLOSE, MODE_SIGNAL, 0);
   
   string status = "ADX_M0["+ADX_M0+"]"+ "ADX_S0["+ADX_S0+"]";
   //Print (status);
   double diff_from_fastMa0 = MathAbs(fastMA0 - Open[0]);   
   double diff_from_bbU1 = MathAbs(bbU1- Open[0]);
   double diff_from_bbL1 = MathAbs(bbL1- Open[0]);
   
   double entryFactor = 0.0;    
   //
   // 0. in case stoploss/takeprofit,reset flags
   //
   if(pos == 0 && hasPendingBuy)
   {
      hasPendingBuy = false;   
      useDelayedBuyExit = false;
   }
   else if(pos == 0 && hasPendingSell)
   {
      hasPendingSell = false;   
      useDelayedSellExit = false;   
   }

   //
   // 1. check basic trend
   //   
   if(fastMA1 < slowMA1 && fastMA0 > slowMA0 // golden cross   
   && Volume[0] == 1
   )
   {
      hasGoldenCrossed = true;
      hasDeadCrossed = false;
      doneForThisCycle = false;
   }
   else if(fastMA1 > slowMA1 && fastMA0 < slowMA0   
   && Volume[0] == 1
   )
   {
      hasGoldenCrossed = false;
      hasDeadCrossed = true;
      doneForThisCycle = false;
   }
   
   //
   // Entry Triggers
   //
   if( hasGoldenCrossed 
   //&& diff_from_fastMa0 < diff_from_bbU1 
   && MathAbs(fastMA1 - slowMA1) > minChange 
   && slowMA1 <= slowMA0
   && fastMA1 <= fastMA0
   && MACD_V1 >= MACD_S1
   && MACD_S1 > 0   
   //&& bbU0 > Open[1]
   && ADX_M0 > 25
   )
   {  
      
      ClosePositions(false, true);
      if(hasPendingBuy== false) 
      {
         //acePrintAccountInfo();
         //double buyOpenPrice = NormalizeDouble(Close[0] + (Ask-Bid)/2, Digits);
         //double rawBuyEntryPrice = bbU0 + (bbU1-bbU0)*entryFactor;
         double rawBuyEntryPrice = fastMA0 + (bbU1-bbU0)*entryFactor;
         double buyOpenPrice = NormalizeDouble(rawBuyEntryPrice, Digits);
         double buyStopPrice = NormalizeDouble(MathMin(slowMA1, buyOpenPrice-stopLossPoints*Point), Digits);
         //double buyStopPrice = NormalizeDouble(slowMA1, Digits);
         double buyExitPrice = NormalizeDouble(MathMin(bbU3, buyOpenPrice+takeProfitPoints*Point), Digits);
         //buyStopPrice = 0;
         buyExitPrice = 0;         
         double buyLotSize = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, buyOpenPrice, buyStopPrice);
         aceOrderSend(OP_BUYSTOP,buyLotSize,buyOpenPrice,0, buyStopPrice,buyExitPrice,COMMENT,MAGIC,TimeCurrent()+ 60*60*1, Blue);
         hasPendingBuy=true;
         aceLog(gLogFileName, "BuyEntry: xEMA01_01");
      }
      else if(hasPendingBuy)
      {
         //xTrailingStop(bbL2);
      }     
      
      hasGoldenCrossed = true;
      hasDeadCrossed = false;
      useDelayedBuyExit = false;
      return(0);
   }
   else if(hasGoldenCrossed && hasPendingSell)
   {        
      aceLog(gLogFileName, "ShortClose: xEMA01_02");
      ClosePositions(false, true);
   }
   else if( fastMA0 > slowMA0)
   {   
      //ok, still up trend,keep hasGoldenCrossed as true
   }
   else if( hasPendingBuy)
   {   
      //ok, still up trend,keep hasGoldenCrossed as true
      //xTrailingStop(bbL2);
   } 
   else
   {
      hasGoldenCrossed = false;
   }

   if( hasDeadCrossed
   //&& diff_from_fastMa0 < diff_from_bbL1
   && MathAbs(fastMA1 - slowMA1) > minChange
   && slowMA1 >= slowMA0
   && fastMA1 >= fastMA0
   && MACD_V1 <= MACD_S1
   && MACD_S1 < 0
   //&& bbL0 < Open[1]
   && ADX_M0 > 25
   )
   {        
      ClosePositions(true, false);
      if(hasPendingSell == false)
      {
         //acePrintAccountInfo();
         //double sellOpenPrice = NormalizeDouble(Close[0], Digits);
         //double rawSellEntryPrice = bbL0 + (bbL1-bbL0)*entryFactor;
         double rawSellEntryPrice = fastMA0 + (bbL1-bbL0)*entryFactor;
         double sellOpenPrice = NormalizeDouble(bbL0, Digits);
         double sellStopPrice = NormalizeDouble(MathMax(slowMA1,sellOpenPrice+stopLossPoints*Point), Digits);
         //double sellStopPrice = NormalizeDouble(slowMA1, Digits);
         double sellExitPrice = NormalizeDouble(MathMax(bbL3, sellOpenPrice+takeProfitPoints*Point), Digits);         
         //sellStopPrice = 0;
         sellExitPrice = 0;
         double sellLotSize = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, sellStopPrice, sellOpenPrice);
         aceOrderSend(OP_SELLSTOP,sellLotSize,sellOpenPrice,0,sellStopPrice, sellExitPrice,COMMENT,MAGIC,TimeCurrent()+60*60*1, Red);
         hasPendingSell= true;  
         aceLog(gLogFileName, "SellEntry: xEMA02_01");
       }   
       else if(hasPendingSell)
       {
         //xTrailingStop(bbU2);         
       }
         
      hasDeadCrossed = true;
      hasGoldenCrossed = false;
      useDelayedSellExit = false;
      return(0);
   }
   else if(hasDeadCrossed && hasPendingBuy)
   {      
      aceLog(gLogFileName, "BuyClose: xEMA02_02");
      ClosePositions(true, false);
   }
   else if(fastMA0 < slowMA0)
   {
   }
   else if(hasPendingSell)
   {
      //xTrailingStop(bbU2);
   }  
   else
   {
      hasDeadCrossed = false;
   }
   
   //
   // Profit Taking Triggers
   //
   if(hasPendingBuy == true 
   && Open[1] < Close[1] // rising bar
   //&& (MathAbs(Close[1] - bbU1) / MathAbs(Open[1] - bbU1) >=2 )// upper band exceeding a lot
   && Close[1] > bbU1 // upper band exceeding a lot
   && Open[1] < bbU1 && bbU1 < Close[1]
   )
   {
      aceLog(gLogFileName, "BuyClose checking...");
      if(Open[1] > fastMA1 && Close[1] > fastMA1)
      {
         aceLog(gLogFileName, "BuyClose checking --> DELAY");
         useDelayedBuyExit = true;
      }
      else
      {
         aceLog(gLogFileName, "BuyClose checking --> DONE");
         useDelayedBuyExit = false;
         ClosePositions(true, false);
         //acePrintAccountInfo();
         return(0);
      }
   }
   else if(hasPendingBuy && useDelayedBuyExit 
   && Open[1] > Close[1] // rising bar
   && (MathAbs(Close[1] - fastMA1) / MathAbs(Open[1] - fastMA1) >=2 )// upper band exceeding a lot   
   && fastMA1 > Close[1]
   )
   {
      aceLog(gLogFileName, "BuyClose Delay Done");
      useDelayedBuyExit = false;
      ClosePositions(true, false);
      //acePrintAccountInfo();
      return(0);
   }
   else if(hasPendingBuy
   && fastMA1 > Close[1]
   )
   {
      aceLog(gLogFileName, "BuyClose Delay Done");
      useDelayedBuyExit = false;
      ClosePositions(true, false);
      //acePrintAccountInfo();
      return(0);
   }
   
   if(hasPendingSell
   && Open[1] > Close[1] 
   //&& (MathAbs(Close[1] - bbL1) / MathAbs(Open[1] - bbL1) >=2 )// upper band exceeding a lot
   && Close[1] < bbL1// upper band exceeding a lot
   && Open[1] > bbL1 && bbL1 > Close[1]
   )
   {
      aceLog(gLogFileName, "SellClose checking...");
      if(Open[1] < fastMA1 && Close[1] < fastMA1)
      {
         aceLog(gLogFileName, "SellClose checking --> DELAY");
         useDelayedSellExit = true;
      }
      else
      {
         aceLog(gLogFileName, "SellClose checking --> DONE");
          useDelayedSellExit = false;
          ClosePositions(false, true);
          //acePrintAccountInfo();
          return(0);

      }
   }   
   if(hasPendingSell && useDelayedSellExit 
   && Open[1] < Close[1] // rising bar
   && (MathAbs(Close[1] - fastMA1) / MathAbs(Open[1] - fastMA1) >=2 )// upper band exceeding a lot
   && fastMA1 < Close[1]
   )
   {
      aceLog(gLogFileName, "SellClose Delay Done");
      useDelayedSellExit = false;
      ClosePositions(false, true);
      //acePrintAccountInfo();
      return(0);
   }
   else if(hasPendingSell 
   && fastMA1 < Close[1]
   )
   {
      aceLog(gLogFileName, "SellClose Delay Done");
      useDelayedSellExit = false;
      ClosePositions(false, true);
      //acePrintAccountInfo();
      return(0);
   }
   return(0);
}