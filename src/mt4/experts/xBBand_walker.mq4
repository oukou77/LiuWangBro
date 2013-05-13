//+------------------------------------------------------------------+
//|                                                     xEMA         |
//|                                   Copyright (c) 2012, Da Monster |
//|                                         mtdlp@hotmail.com        |
//+------------------------------------------------------------------+
// 1.4.8 : Add Log File from 1.4.7

#property copyright "Copyright (c) 2012, Da Monster"
#property link      "mtdlp@hotmail.com"

#include <aceUtil_2.2.mqh>
#include <aceOrderManager_3.0.mqh>
#include <aceRiskManager_2.0.mqh>

// How to name MAGIC (6 Digits)
// -- 1st : strategy type
//          1 -- Trend Following
//          2 -- Break Out
//          3 -- Counter Trend
//          4 -- Mean Reverse
//          5 -- Toralipi
//          6 -- Scalpering
// -- 2-3 : strategy series
//          i.e. 01 - 2 MA Cross + BBand
// -- 4-6 : strategy version
//           1.4.6 
//           4th digit : the same as common libraries,i.e. using aceOrderManager
//           5th digit : Major change
//           6th digit : Minor Change

//
// Currency pair: Major Pairs
// Time-frame: D1

//
// Strategy Objective
// -- (Basic)  : 
// -- (Advance): 
//

//
// Strategy Buy Signal: 
// -- (Basic   1)  : prev day bar is up bar
// -- (Basic   2)  : prev day bar open is lower 1 sigma
// -- (Basic   3)  : prev day bar close is higher 1 sigma
// -- (Basic   4)  : curr day bar close is higher high[1], buy stop
// -- (Basic   5)  : stop loss is low[1], no trailing stop, no take profit

//
// Strategy Buy Close Signal: 
// -- (Basic   1)  : Curr open is higher 1 sigma
// -- (Basic   2)  : Curr close is lower 1 sigma

//
// Strategy Sell Signal: 
// -- (Basic   1)  : prev day bar is down bar
// -- (Basic   2)  : prev day bar open is higher 1 sigma
// -- (Basic   3)  : prev day bar close is lower 1 sigma
// -- (Basic   4)  : curr day bar close is lower than low[1], sell stop
// -- (Basic   5)  : stop loss is high[1], no trailing stop, no take profit

//
// Strategy Sell Close Signal: 
// -- (Basic   1)  : Curr open is lower 1 sigma
// -- (Basic   2)  : Curr close is higher 1 sigma


//
//Strategy Strengths: 

//
//Strategy Weaknesses:

// ToDo:

#define MAGIC   10101
#define COMMENT "xBBand_Walker"

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
extern int stopLossPoints = 400;
extern int eTakeProfit = 30;
extern int gTS1 = 15;
extern bool gDoPrint = false;
extern bool gDoLog = false;

int gLogFileHandle = 0;// Uninitialized
string gLogFileName = "";

void ClosePositions(bool closeBuy, bool closeSell)
{
   for(int i=0; i< OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS,MODE_TRADES) == false) break;
      if(OrderMagicNumber() != MAGIC || OrderSymbol() != Symbol()) continue;

      if(OrderType()==OP_BUY && closeBuy== true)
      {
         OrderClose(OrderTicket(),OrderLots(),Bid,0,White);
         break;
      }
      if(OrderType()==OP_SELL && closeSell == true)
      {
         OrderClose(OrderTicket(),OrderLots(),Ask,0,White);
         break;
      }
      if(OrderType()==OP_BUYLIMIT && closeBuy== true)
      {
         OrderDelete(OrderTicket());
         break;
      }
      if(OrderType()==OP_SELLLIMIT && closeSell == true)
      {
         OrderDelete(OrderTicket());
         break;
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
      aceLog(gLogFileName,(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)), gDoPrint, gDoLog);
      //FileFlush(gLogFileHandle);
      
   }else
   {
      Print("Failed to open a new log file : " + gLogFileName);
   }
}

int start()
{
   bool hasPendingBuy = true;
   bool hasPendingSell = true;   
   
   if(gLogFileHandle == 0)
   {  
     Print("No File Opened yet !!!");
     return (0);   
   }
   
   int currHourInGMT = TimeHour(TimeCurrent());
	int currMinInGMT = TimeMinute(TimeCurrent());
   
   string hbmsg= "xBBand_Rebounder" + instance +"_" +IsTradeAllowed();

   double currLongPos = aceCurrentOrders(MY_BUYPOS, MAGIC);
	double currShortPos = aceCurrentOrders(MY_SELLPOS, MAGIC);		
	
	if( currLongPos == 0 )
	{
	    hasPendingBuy = false;
	}	
	
	if( currShortPos == 0 )
	{
	    hasPendingSell = false;
	}	
	
   double bbU1 = iBands(NULL, PERIOD_D1, 20, BBDev*1, 0, PRICE_WEIGHTED, MODE_UPPER, 1);
   double bbU2 = iBands(NULL, PERIOD_D1, 20, BBDev*2, 0, PRICE_WEIGHTED, MODE_UPPER, 1);   
   
   double bbL1 = iBands(NULL, PERIOD_D1, 20, BBDev*1, 0, PRICE_WEIGHTED, MODE_LOWER, 1);
   double bbL2 = iBands(NULL, PERIOD_D1, 20, BBDev*2, 0, PRICE_WEIGHTED, MODE_LOWER, 1);   

   double prevOpen = iOpen( NULL, PERIOD_D1, 1); 
   double prevClose = iClose( NULL, PERIOD_D1, 1); 
   double prevHigh = iHigh( NULL, PERIOD_D1, 1); 
   double prevLow = iLow( NULL, PERIOD_D1, 1); 
   
   double fastMA1 = iMA(NULL, 0, 20, 0, MODE_SMA, PRICE_WEIGHTED, 1);
   double fastMA2 = iMA(NULL, 0, 20, 0, MODE_SMA, PRICE_WEIGHTED, 2);   
   
   double cci_0 = iCCI(NULL, PERIOD_D1, 20, PRICE_WEIGHTED, 0);
   double cci_1 = iCCI(NULL, PERIOD_D1, 20, PRICE_WEIGHTED, 1);
   
   if( Volume[0] == 1 )
   {
      string check_yesterday = "[mkt][yesterday][bbU1"+"]" + bbU1 + 
                             " [prevOpen"+"]" + prevOpen +
                             " [prevClose"+"]" + prevClose +
                             " [prevHigh"+"]" + prevHigh +
                             " [prevLow"+"]" + prevLow +
                             " [Close[0]"+"]" + (Close[0]);                             
      aceLog(gLogFileName, check_yesterday, gDoPrint, gDoLog);
      
      if( prevOpen < prevClose && prevClose > bbU1 && prevClose < bbU2 && hasPendingBuy == false 
         && fastMA2 < fastMA1 && cci_0 >cci_1
      )
      {
         double buyOpen = NormalizeDouble(Close[0], Digits);
         double buyStop = NormalizeDouble(bbL1, Digits);
         double buyExit = NormalizeDouble(MathMax(bbL2, buyOpen+eTakeProfit*Point), Digits);  
         //double buyExit = NormalizeDouble(buyOpen+eTakeProfit*Point, Digits);  
         buyExit = 0;
         double buyLot = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, buyOpen, buyStop);
         aceOrderSend(OP_BUYSTOP,buyLot,buyOpen,0, buyStop,buyExit,COMMENT,MAGIC,TimeCurrent()+ 60*60*1, Blue);
         hasPendingBuy=true;
         string bbBuyStatus = "[order][buyOpen"+"]" + buyOpen + 
                             " [buyStop"+"]" + buyStop +
                             " [buyExit"+"]" + buyExit +
                             " [buyLot"+"]" + buyLot ;
         aceLog(gLogFileName, bbBuyStatus, gDoPrint, gDoLog);
         return;
      }
      
      aceLog(gLogFileName, " No Buy Order Opened", gDoPrint, gDoLog);
  
      //if( prevOpen > prevClose && prevClose < bbL1 && prevClose > bbL2  && hasPendingSell == false
      //  && fastMA2 > fastMA1 && cci_0 < cci_1
      // )
      //{
      //   double sellOpen = NormalizeDouble(Close[0], Digits);
      //   double sellStop = NormalizeDouble(bbU1, Digits);
      //   double sellExit = NormalizeDouble(MathMin(bbU2, sellOpen - eTakeProfit*Point), Digits);
      //   //double sellExit = NormalizeDouble(sellOpen - eTakeProfit*Point, Digits);
      //   sellExit = 0;      
      //  double sellLot = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, sellOpen, sellStop);
      //  aceOrderSend(OP_SELLSTOP,sellLot,sellOpen,0,sellStop, sellExit,COMMENT,MAGIC,TimeCurrent()+60*60*1, Red);
      //  hasPendingSell= true;  
      // string bbSellStatus = "[order][sellOpen"+"]" + sellOpen + 
      //                       " [sellStop"+"]" + sellStop +
      //                       " [sellExit"+"]" + sellExit +
      //                       " [sellLot"+"]" + sellLot ;
      //   aceLog(gLogFileName, bbSellStatus, gDoPrint, gDoLog);
      //  return;   
      //}
      //aceLog(gLogFileName, " No SELL Order Opened", gDoPrint, gDoLog);
   }
   else
   {
      if(hasPendingBuy && Open[0] > bbU1 && Close[0] < bbU1)
      {
         ClosePositions(true,false);
      }
      
      if(hasPendingSell && Open[0] < bbL1 && Close[0] > bbL1)
      {
         ClosePositions(false,true);
      }
   
   }    
   return(0);
}