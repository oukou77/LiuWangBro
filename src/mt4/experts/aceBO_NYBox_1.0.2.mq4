//+------------------------------------------------------------------+
//|                                              aceBO_NewYorBox_1.0 |
//|                                   Copyright (c) 2013, Da Monster |
//|                                         liulei.forex@gmail.com   |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2013, Da Mon"
#property link      "liulei.forex@gmail.com"

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
// Time-frame: M30/H1

//
// Strategy Objective
// -- (Basic)  : Capture BreakOut of NY.BOX
// -- (Advance): Capture Range RevertBack Into the N.Y Box
//

//
// Strategy Open Signal: 
// -- (Basic   1)  : Close Break Out of N.Y Box.
// -- (Basic   2)  : LTP Break Out of N.Y Box sharply, 20pips, but this case need to be close quickly
// -- (Advance 1)  : revert back from box edge for some pips
// -- (Advance 2)  : revert back from box edge when BreakOut stoplos

//
// Strategy Close Signal: 
// -- (Basic   1)  : Close Break Out of N.Y Box.
// -- (Basic   2)  : LTP Break Out of N.Y Box sharply, 20pips, but this case need to be close quickly
// -- (Advance 1)  : revert back from box edge for some pips
// -- (Advance 2)  : revert back from box edge when BreakOut stoplos


//
//Strategy Strengths: 
// -- (Basic   1)  : Close Break + 20
// -- (Basic   2)  : LTP Break Out of N.Y Box sharply, exit on close
// -- (Advance 1)  : revert back from box edge for some pips, revert 61.8% 
// -- (Advance 2)  : revert back from box edge when BreakOut stoplos, the other side of the box

//
//Strategy Weaknesses:

// ToDo:

#define MAGIC   206101
#define COMMENT "aceBO_NYBox"

//
//  INPUT PARAMETERS
//
extern double gRiskPerTrade = 0.01;// percentage
extern double gRiskDis = 0.1; // %riskPerTrade of first lot, 1 - riskDis is the risk  for 2nd lot
extern int gEtrBreakBars = 72; // ????? check the High Low between 15:00~20:55

extern int gSlATR = 2;// stop loss     : number of ATR
extern int gTpATR = 4;// take profit   : number of ATR
extern int gTsATR = 2;// trailing stop : number of ATR
extern double gLot1 = 0.3;
extern double gLot2 = 0.1;
extern bool gDoPrint = false;
extern bool gDoLog = false;

extern string gInstance = "default";
// The following definitions are in PIPS
extern int gAlertOffset = 10;
extern int gEtrOffset = 100; 
extern int gSL1 = 300;
extern int gSL2 = 300;
extern int gTP1 = 300;
extern int gTP2 = 1400;
extern int gTS1 = 100;
extern int gTS2 = 300;
extern double eRiskPerTrade = 0.02;
extern double eStopLossBase = 0.5;

// NY.BOX (Non-DLS)
// JST : 14 - 21:00
// GMT : 05 - 12:00
// NY.BOX (DLS)
// JST : 13 - 20:00
// GMT : 04 - 11:00
int gStartHourInJST = 13; 
int gStartMinuteInJST = 0;
int gEndHourInJST = 20;
int gEndMinuteInJST = 0;

int gBoxHighHourInJST = 0; 
int gBoxHighMinuteInJST = 0;
int gBoxLowHourInJST = 0;
int gBoxLowMinuteInJST = 0;

//
//  GLOBAL Variables
//
double gNYHigh = 0;
double gNYLow  = 0;
double gNYRange = 0; // in PIPS
double gDrLimit = 200; // daily range limit  in pips
double gMinBoxRange = 200; // we dont do revert if box is too small

double gBalance = 300000;//How much left in the account
double gValue = 1000; // 1 lot * 1 pips for ***USD

bool hasStartToRecord = false;
bool hasDumpTodayRange = false;
bool hasTradedForTheDay = false;

bool gBuyFlag  = false;
bool gSellFlag = false;

bool gOrderFlag1 = false;
bool gOrderFlag2 = false;

int gBuyCnt=0;
int gSellCnt=0;

int gTradeSide = 0;// 0: NaN; 1: Buy; 2: Sell

double gOdrOpen1 = 0;
double gOdrOpen2 = 0;

double gOdrClose1 = 0;
double gOdrClose2 = 0;

double gOdrSl1 = 0;
double gOdrSl2 = 0;

double gOdrTp1 = 0;
double gOdrTp2 = 0;

double gOdrTs1 = 0;
double gOdrTs2 = 0;

int gOdrTkt1 = 0; 
int gOdrTkt2 = 0;

int gTktBuyOdr = 0; 
int gTktSellOdr = 0; 


int gLogFileHandle = 0;// Uninitialized
string gLogFileName = "";

void calLotSize(double aBalance, double aValue, double aRiskPerTrade, double aRiskDis, int aSL1, int aSL2 )
{
   gLot1 = aBalance*aRiskPerTrade*aRiskDis/(aValue*aSL1);
   gLot1 = MathFloor(100*gLot1)/100;
   
   gLot2 = aBalance*aRiskPerTrade*(1-aRiskDis)/(aValue*aSL2);
   gLot2 = MathFloor(100*gLot2)/100;
}

int init()
{
   // 0. create a new log file, the convention follows:
   //     algoName_version_instance_timestamp   
   gLogFileName = aceGetLogFileName(COMMENT, gInstance, Symbol(), "0");
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
   }
   else
   {
      Print("Failed to open a new log file : " + gLogFileName);
   }
}

void test_serverTime()
{
   int currHourInGMT = TimeHour(TimeCurrent());
	int currMinInGMT = TimeMinute(TimeCurrent());
   Print("currHourInGMT : " + currHourInGMT);
   Print("currMinInGMT : " + currMinInGMT);
}

int start()
{  
   // No Entry if it is box time 
   // -- todo : close any open order ? 
   int currHourInGMT = TimeHour(TimeCurrent());
	int currMinInGMT = TimeMinute(TimeCurrent());
	bool hasBoxRangeUpdate = false;	
	bool goodToEntry = false;
	double entryPrice = 0;	
	
	double currLongPos = aceCurrentOrders(MY_BUYPOS, MAGIC);
	double currShortPos = aceCurrentOrders(MY_SELLPOS, MAGIC);
	if( currLongPos == 0 && gTktBuyOdr !=0 )
	{
	  gTktBuyOdr = 0;
	}
	if( currShortPos == 0 && gTktSellOdr !=0 )
	{
	  gTktSellOdr = 0;
	}
	//aceLog(gLogFileName, "currHourInGMT: " + currHourInGMT, gDoPrint, gDoLog);
	
	if ( currHourInGMT < gStartHourInJST && currHourInGMT > 1)
	{
	  //ok, before N.Y Box time, like tokyo 
	  //Print("before N.Y Box time : " + currHourInGMT);
	  hasStartToRecord = false;
	  hasTradedForTheDay = false;
	  if(gTktBuyOdr != 0)
     {
      aceTrailingStopByPoint(MAGIC, gTS1);
     }
     if(gTktSellOdr != 0)
     {
         aceTrailingStopByPoint(MAGIC, gTS1);
     }
	  return (0);
	}
	else if( currHourInGMT >= gStartHourInJST && currHourInGMT < gEndHourInJST )
	{	  
	  // OK, NY Box Time, no break out trade.
	  if (hasStartToRecord == false)
	  {
	     hasStartToRecord = true;
	     gNYHigh = 0;
	     gNYLow = 10000;// fake value, which is high enough to trigger update.
	  }
	  //Print("Box Time, recording NY High/low and take some rest...");
	  gEtrBreakBars = currHourInGMT - gStartHourInJST + 1;
	  if( gNYHigh < High[0] )
	  {
	     gNYHigh = High[0];
	     gNYRange = (gNYHigh - gNYLow)/Point;
	     gBoxHighHourInJST = currHourInGMT;
	     gBoxHighMinuteInJST = currMinInGMT;
	     hasBoxRangeUpdate = true;
	  }
	  
	  if( gNYLow > Low[0] )
	  {
	     gNYLow = Low[0];	     
	     gNYRange = (gNYHigh - gNYLow)/Point;
	     gBoxLowHourInJST = currHourInGMT;
	     gBoxLowMinuteInJST = currMinInGMT;
	     hasBoxRangeUpdate = true;
	  }	  
	  
	  //gNYHigh = High[iHighest(NULL, PERIOD_H1, MODE_HIGH, gEtrBreakBars, 0)];
	  //gNYLow  = Low[iLowest(NULL, PERIOD_H1, MODE_LOW, gEtrBreakBars, 0)];	  
	  
     if( hasBoxRangeUpdate)
     {
         string status = "["+gBoxHighHourInJST+":"+gBoxHighMinuteInJST+"]" + gNYHigh + 
                         "["+gBoxLowHourInJST+":"+gBoxLowMinuteInJST+"]" + gNYLow ;
         //Print(status);
     }     
     if(gTktBuyOdr != 0)
     {
      aceTrailingStopByPoint(MAGIC, gTS1);
     }
     if(gTktSellOdr != 0)
     {
         aceTrailingStopByPoint(MAGIC, gTS1);
     }
     return ;
   }
   else
   {      
      //Print("After N.Y Box time : " + currHourInGMT);
      if( hasStartToRecord == false)
      {
         return(0);         
      }
      if( hasDumpTodayRange == false)
      {
         string statusFinal = "["+gBoxHighHourInJST+":"+gBoxHighMinuteInJST+"]" + gNYHigh + 
                           " ["+gBoxLowHourInJST+":"+gBoxLowMinuteInJST+"]" + gNYLow +
                           " ["+gNYRange+"]";
         aceLog(gLogFileName, statusFinal, gDoPrint, gDoLog);
         hasDumpTodayRange = true;
      }
   }
   
   if( Close[1] >= (gNYHigh + gAlertOffset*Point))
   {  
      goodToEntry = true;
      entryPrice = Close[1];
   }
   else if(Close[0] >= (gNYHigh + 100*Point))
   {
      goodToEntry = true;
      entryPrice = Close[0];
   }
   
   if( goodToEntry )
   {
      if( gTktBuyOdr == 0 && hasTradedForTheDay == false )
      { 
         double rawBuyEntryPrice = entryPrice;
         double buyOpenPrice = NormalizeDouble(rawBuyEntryPrice, Digits);
         double buyStopPrice = NormalizeDouble(MathMin(buyOpenPrice - gNYRange/3*Point, buyOpenPrice-gSL1*Point), Digits);
         double buyExitPrice = NormalizeDouble(MathMin(buyOpenPrice + gNYRange/3*Point, buyOpenPrice+gTP1*Point), Digits);
              
         string testBuyStatus = "[BuyEntryLine"+"]" + buyOpenPrice + 
                             " [StopLossLine"+"]" + buyStopPrice +
                             " [TakeProfitLine"+"]" + buyExitPrice +
                             " ["+gTktBuyOdr+"]";
         aceLog(gLogFileName, testBuyStatus, gDoPrint, gDoLog);

         //buyStopPrice = 0;
         buyExitPrice = 0; 
         
         hasTradedForTheDay = true;
         double buyLotSize = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, buyOpenPrice, buyStopPrice);
         gTktBuyOdr = aceOrderSend(OP_BUYSTOP,buyLotSize,buyOpenPrice,0, buyStopPrice,buyExitPrice,COMMENT,MAGIC,TimeCurrent()+ 60*60*1, Blue);
         aceLog(gLogFileName, "BuyTiket: " + gTktBuyOdr, gDoPrint, gDoLog);
         //aceLog(gLogFileName, "BuyEntry_Open: " + buyOpenPrice, gDoPrint, gDoLog);
         //aceLog(gLogFileName, "BuyEntry_Stop: " + buyStopPrice, gDoPrint, gDoLog);
         //aceLog(gLogFileName, "BuyEntry_Exit: " + buyExitPrice, gDoPrint, gDoLog);
      }
      return ;
   }
   
   if( Close[1] <= (gNYLow - gAlertOffset*Point))
   {  
      goodToEntry = true;
      entryPrice = Close[1];
   }
   else if(Close[0] <= (gNYLow - 100*Point))
   {
      goodToEntry = true;
      entryPrice = Close[0];
   }


   if( goodToEntry )
   {      
      if( gTktSellOdr == 0 && hasTradedForTheDay == false)
      {
         double rawSellEntryPrice = entryPrice;
         double sellOpenPrice = NormalizeDouble(rawSellEntryPrice, Digits);
         double sellStopPrice = NormalizeDouble(MathMax(sellOpenPrice + gNYRange/3*Point,sellOpenPrice+gSL1*Point), Digits);
         double sellExitPrice = NormalizeDouble(MathMax(sellOpenPrice - gNYRange/3*Point,sellOpenPrice+gTP1*Point), Digits);
      
         string testSellStatus = "[SellEntryLine"+"]" + sellOpenPrice + 
                             " [StopLossLine"+"]" + sellStopPrice +
                             " [TakeProfitLine"+"]" + sellExitPrice +
                             " ["+gTktSellOdr+"]";
         aceLog(gLogFileName, testSellStatus, gDoPrint, gDoLog);     
               
         //sellStopPrice = 0;
         sellExitPrice = 0;
         
         hasTradedForTheDay = true;
         double sellLotSize = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, sellStopPrice, sellOpenPrice);
         gTktSellOdr = aceOrderSend(OP_SELLSTOP,sellLotSize,sellOpenPrice,0,sellStopPrice, sellExitPrice,COMMENT,MAGIC,TimeCurrent()+60*60*1, Red);
         aceLog(gLogFileName, "SellTiket: " + gTktSellOdr, gDoPrint, gDoLog);
         //aceLog(gLogFileName, "SellEntry_Open: " + sellOpenPrice, gDoPrint, gDoLog);
         //aceLog(gLogFileName, "SellEntry_Stop: " + sellStopPrice, gDoPrint, gDoLog);
         //aceLog(gLogFileName, "SellEntry_Exit: " + sellExitPrice, gDoPrint, gDoLog);
      }
      
      return ;
   }  
         
   if(gTktBuyOdr != 0)
   {
     aceTrailingStopByPoint(MAGIC, gTS1);
   }
   if(gTktSellOdr != 0)
   {
     aceTrailingStopByPoint(MAGIC, gTS1);
   }
   return(0);
}

