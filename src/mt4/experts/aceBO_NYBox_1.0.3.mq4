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
double gPrevNYBoxHigh = 0;
double gPrevNYBoxLow = 0;
double gPrevNYBoxRange = 0; // in PIPS

double gDrLimit = 200; // daily range limit  in pips
double gMinBoxRange = 200; // we dont do revert if box is too small

double gBalance = 300000;//How much left in the account
double gValue = 1000; // 1 lot * 1 pips for ***USD

bool gHasStartToRecord = false;
bool gHasDumpTodayRange = false;
bool gHasTradedForTheDay = false;

bool gBreakOutTopOnce = false;
bool gBreakOutBottomOnce = false;
bool gDayChanged = false;
	
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

int gBOBuyTicket = 0; 
int gRVBuyTicket = 0; 

int gBOSellTicket = 0; 
int gRVSellTicket = 0;

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

void performTrailingStop()
{
   if( gBOBuyTicket != 0)
   {
      aceTrailingStopByPoint(MAGIC, gTS1);      
   }
   
   if(gBOSellTicket != 0)
   {
      aceTrailingStopByPoint(MAGIC, gTS1);    
   }
  
   if(gRVBuyTicket != 0)
   {  
      aceTrailingStopByPoint(MAGIC, gTS1);
   }
   if(gRVSellTicket != 0)
   {
      aceTrailingStopByPoint(MAGIC, gTS1);    
   }
}

void recordNYBoxHighLow(int currHourInGMT, int currMinInGMT)
{
     bool hasBoxRangeUpdate = false;
     if (gHasStartToRecord == false)
	  {
	     gHasStartToRecord = true;
	     gNYHigh = 0;
	     gNYLow = 10000;// fake value, which is high enough to trigger update.
	  }	  
	  //Print("Box Time, recording NY High/low and take some rest...");	  
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
	  
     if( hasBoxRangeUpdate)
     {
         string status = "["+gBoxHighHourInJST+":"+gBoxHighMinuteInJST+"]" + gNYHigh + 
                         "["+gBoxLowHourInJST+":"+gBoxLowMinuteInJST+"]" + gNYLow ;
         //Print(status);
     }
}

void amendNYBoxHighLow(int currHourInGMT, int currMinInGMT, double newHigh, double newLow, bool forceLog)
{    
     if (gHasStartToRecord == false)
	  {
	     gHasStartToRecord = true;
	     gNYHigh = 0;
	     gNYLow = 10000;// fake value, which is high enough to trigger update.
	  }	  
	  //Print("Box Time, recording NY High/low and take some rest...");	  
	  if( gNYHigh < newHigh )
	  {
	     gNYHigh = newHigh;
	     gNYRange = (gNYHigh - gNYLow)/Point;
	     gBoxHighHourInJST = currHourInGMT;
	     gBoxHighMinuteInJST = currMinInGMT;	     
	  }
	  
	  if( gNYLow > newLow )
	  {
	     gNYLow = newLow;
	     gNYRange = (gNYHigh - gNYLow)/Point;
	     gBoxLowHourInJST = currHourInGMT;
	     gBoxLowMinuteInJST = currMinInGMT;	  
	  }
	  
     if( forceLog )
     {
         string status = "["+gBoxHighHourInJST+":"+gBoxHighMinuteInJST+"]" + gNYHigh + 
                         "["+gBoxLowHourInJST+":"+gBoxLowMinuteInJST+"]" + gNYLow ;
         Print(status);
     }
}

int start()
{  
   // No Entry if it is box time 
   // -- todo : close any open order ? 
   int currHourInGMT = TimeHour(TimeCurrent());
	int currMinInGMT = TimeMinute(TimeCurrent());
	bool hasBoxRangeUpdate = false;	
	bool good2BOBuy = false;
	bool good2BOSell = false;
	bool good2RVBuy = false;
	bool good2RVSell = false;
	
	double breakOutEntryPrice = 0;
	double revertEntryPrice = 0;
	
	double currLongPos = aceCurrentOrders(MY_BUYPOS, MAGIC);
	double currShortPos = aceCurrentOrders(MY_SELLPOS, MAGIC);	
	
	if( currLongPos == 0 && gBOBuyTicket !=0 )
	{
	  aceLog(gLogFileName, "No more Break out long position", gDoPrint, gDoLog);
	  amendNYBoxHighLow(currHourInGMT, currMinInGMT, MathMax(High[0],High[1]), MathMin(Low[0],Low[1]), true);
	  gBOBuyTicket = 0;
	}
	if( currLongPos == 0 && gRVBuyTicket !=0 )
	{	  
	  gRVBuyTicket = 0;
	}
	
	if( currShortPos == 0 && gBOSellTicket !=0 )
	{
	  aceLog(gLogFileName, "No more break out short position", gDoPrint, gDoLog);
	  amendNYBoxHighLow(currHourInGMT, currMinInGMT, MathMax(High[0],High[1]), MathMin(Low[0],Low[1]), true);
	  gBOSellTicket = 0;
	}
	if( currShortPos == 0 && gRVSellTicket !=0 )
	{
	  gRVSellTicket = 0;
	}
	
	if ( currHourInGMT < gStartHourInJST && currHourInGMT > 6)
	{
	  //ok, before N.Y Box time, like tokyo 
	  //Print("before N.Y Box time : " + currHourInGMT);
	  gDayChanged = true;
	  gHasDumpTodayRange = false;
	  gHasStartToRecord = false;
	  gHasTradedForTheDay = false;
     performTrailingStop();
	  return (0);
	}
	else if( currHourInGMT >= gStartHourInJST && currHourInGMT < gEndHourInJST )
	{	  
	  // OK, NY Box Time, no break out trade.
	  recordNYBoxHighLow(currHourInGMT, currMinInGMT );
     performTrailingStop();
     return ;
   }
   else
   {      
      //Print("After N.Y Box time : " + currHourInGMT);
      if( gHasStartToRecord == false)
      {
         return(0);         
      }
      if( gHasDumpTodayRange == false)
      {
         string statusFinal = "[box]["+gBoxHighHourInJST+":"+gBoxHighMinuteInJST+"]" + gNYHigh + 
                           " ["+gBoxLowHourInJST+":"+gBoxLowMinuteInJST+"]" + gNYLow +
                           " ["+gNYRange+"]";
         aceLog(gLogFileName, statusFinal, gDoPrint, gDoLog);
         gHasDumpTodayRange = true;
         gPrevNYBoxHigh = gNYHigh;
         gPrevNYBoxLow = gNYLow;
         gPrevNYBoxRange = gNYRange;
      }
   }
   
   if( Close[1] >= (gNYHigh + gAlertOffset*Point) && Volume[0] == 1 && gBreakOutTopOnce == false)
   {  
      good2BOBuy = true;
      gBreakOutTopOnce = true;
      breakOutEntryPrice = Close[1];
      string boBuy_close1 = "[mkt][boBuy_close1][Close[1]"+"]" + Close[1] + 
                             " [gNYHigh"+"]" + gNYHigh +
                             " [entryLine"+"]" + (gNYHigh + gAlertOffset*Point);
      aceLog(gLogFileName, boBuy_close1, gDoPrint, gDoLog);
   }
   else if(Close[0] >= (gNYHigh + 100*Point))
   {
      good2BOBuy = true;
      gBreakOutTopOnce = true;
      breakOutEntryPrice = Close[0];
      string boBuy_close0 = "[mkt][boBuy_close0][Close[0]"+"]" + Close[0] + 
                             " [gNYHigh"+"]" + gNYHigh +
                             " [entryLine"+"]" + (gNYHigh + 100*Point);
     aceLog(gLogFileName, boBuy_close0, gDoPrint, gDoLog);
   }
   else if(Close[0] < (gNYHigh - gAlertOffset*Point) && gBreakOutTopOnce )
   {
      good2RVSell = true;
      gBreakOutTopOnce = false;
      revertEntryPrice = Close[0];
      string rvSell_0 = "[mkt][rvSell_0][Close[0]"+"]" + Close[0] + 
                             " [gNYHigh"+"]" + gNYHigh +
                             " [entryLine"+"]" + (gNYHigh - gAlertOffset*Point);
      aceLog(gLogFileName, rvSell_0, gDoPrint, gDoLog);
   }
   
   double ADX_M0 = iADX(NULL,0,25, PRICE_CLOSE, MODE_MAIN, 0);
   
   // 
   // Break Out Buy 
   //
   if( good2BOBuy )
   {
      if( gBOBuyTicket == 0 && gHasTradedForTheDay == false)
      { 
         double rawBuyEntryPrice = breakOutEntryPrice;
         double boBuyOpen = NormalizeDouble(rawBuyEntryPrice, Digits);
         double boBuyStop = NormalizeDouble(MathMin(boBuyOpen - gNYRange/3*Point, boBuyOpen-gSL1*Point), Digits);
         double boBuyExit = NormalizeDouble(MathMin(boBuyOpen + gNYRange/3*Point, boBuyOpen+gTP1*Point), Digits);

         //boBuyStop = 0;
         boBuyExit = 0; 
                  
         gHasTradedForTheDay = true;
         double boBuyLot = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, boBuyOpen, boBuyStop);
         gBOBuyTicket = aceOrderSend(OP_BUYSTOP,boBuyLot,boBuyOpen,0,boBuyStop,boBuyExit,COMMENT,MAGIC,TimeCurrent()+ 60*60*1, Blue);         
         string bbBuyStatus = "[order][boBuyOpen"+"]" + boBuyOpen + 
                             " [boBuySL"+"]" + boBuyStop +
                             " [boBuyTP"+"]" + boBuyExit +
                             " [boBuyLot"+"]" + boBuyLot +
                             " [BOBuyTkt"+"]" + gBOBuyTicket;
         aceLog(gLogFileName, bbBuyStatus, gDoPrint, gDoLog);
         return ;
      }
   }

   //
   // Revert Sell 
   //
   //if( good2RVSell )
   //{
   //   if( gRVSellTicket == 0 )
   //   { 
   //      double rawRVSellOpen = revertEntryPrice;
   //      double rvSellOpen = NormalizeDouble(rawRVSellOpen, Digits);
   //      double rvSellStop = NormalizeDouble(MathMax(rvSellOpen + gNYRange/3*Point,rvSellOpen+gSL1*Point), Digits);
   //      double rvSellExit = NormalizeDouble(MathMax(rvSellOpen - gNYRange/3*Point,rvSellOpen+gTP1*Point), Digits);
               
         //rvSellStop = 0;
         //rvSellExit = 0;
         
         //gHasTradedForTheDay = true;
   //      double rvSellLot = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, rvSellOpen, rvSellStop);
   //      gRVSellTicket = aceOrderSend(OP_SELLSTOP,rvSellLot,rvSellOpen,0,rvSellStop, rvSellExit,COMMENT,MAGIC,TimeCurrent()+60*60*1, Red);
   //      string rvSellStatus = "[rvSellOpen"+"]" + rvSellOpen + 
   //                          " [rvSellStop"+"]" + rvSellStop +
   //                          " [rvSellExit"+"]" + rvSellExit +
   //                          " [rvSellLot"+"]" + rvSellLot +
   //                          " [rvSellTkt"+"]" + gRVSellTicket;
   //      aceLog(gLogFileName, rvSellStatus, gDoPrint, gDoLog);
   //      return ;
   //   }      
   //}
   
   // **************************************************************************************************************
   // **************************************************************************************************************
   // **************************************************************************************************************
   if( Close[1] <= (gNYLow - gAlertOffset*Point) && Volume[0] == 1 && gBreakOutBottomOnce == false)
   {  
      good2BOSell = true;
      gBreakOutBottomOnce = true;
      breakOutEntryPrice = Close[1];
      string boSell_close1 = "[mkt][boSell_close1][Close[1]"+"]" + Close[1] + 
                             " [gNYLow"+"]" + gNYLow +
                             " [entryLine"+"]" + (gNYLow - gAlertOffset*Point);
     aceLog(gLogFileName, boSell_close1, gDoPrint, gDoLog);
   }
   else if(Close[0] <= (gNYLow - 100*Point))
   {
      good2BOSell = true;
      gBreakOutBottomOnce = true;
      breakOutEntryPrice = Close[0];
      string boSell_close0 = "[mkt][boSell_close0][Close[0]"+"]" + Close[0] + 
                             " [gNYLow"+"]" + gNYLow +
                             " [entryLine"+"]" + (gNYLow - 100*Point);
      aceLog(gLogFileName, boSell_close0, gDoPrint, gDoLog);
   }
   else if(Close[0] > (gNYLow + gAlertOffset*Point) && gBreakOutBottomOnce )
   {
      good2RVBuy = true;
      gBreakOutBottomOnce = false;
      revertEntryPrice = Close[0];
      string rvBuy_0 = "[mkt][rvBuy_0][Close[0]"+"]" + Close[0] + 
                             " [gNYLow"+"]" + gNYLow +
                             " [entryLine"+"]" + (gNYLow + gAlertOffset*Point);
      aceLog(gLogFileName, rvBuy_0, gDoPrint, gDoLog);
   }

   // 
   // Break Out Sell 
   //
   if( good2BOSell )
   {      
      if( gBOSellTicket == 0 && gHasTradedForTheDay == false)
      {
         double rawSellOpen = breakOutEntryPrice;
         double boSellOpen = NormalizeDouble(rawSellOpen, Digits);
         double boSellStop = NormalizeDouble(MathMax(boSellOpen + gNYRange/3*Point,boSellOpen+gSL1*Point), Digits);
         double boSellExit = NormalizeDouble(MathMax(boSellOpen - gNYRange/3*Point,boSellOpen+gTP1*Point), Digits);
               
         //boSellStop = 0;
         boSellExit = 0;
         
         gHasTradedForTheDay = true;
         double boSellLot = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, boSellOpen, boSellStop);
         gBOSellTicket = aceOrderSend(OP_SELLSTOP,boSellLot,boSellOpen,0,boSellStop, boSellExit,COMMENT,MAGIC,TimeCurrent()+60*60*1, Red);
         string boSellStatus = "[order][boSellOpen"+"]" + boSellOpen + 
                             " [boSellStop"+"]" + boSellStop +
                             " [boSellExit"+"]" + boSellExit +
                             " [boSellLot"+"]" + boSellLot +
                             " [boSellTkt"+"]" + gBOSellTicket ;
         aceLog(gLogFileName, boSellStatus, gDoPrint, gDoLog);
         return ;
      }
   }    
   //
   // Revert Buy
   //
   //if( good2RVBuy )
   //{
   //   if( gRVBuyTicket == 0 )
   //   { 
   //      double rawRVBuyOpen = revertEntryPrice;
   //      double rvBuyOpen = NormalizeDouble(rawRVBuyOpen, Digits);
   //     double rvBuyStop = NormalizeDouble(MathMin(rvBuyOpen - gNYRange/3*Point, rvBuyOpen-gSL1*Point), Digits);
   //      double rvBuyExit = NormalizeDouble(MathMin(rvBuyOpen + gNYRange/3*Point, rvBuyOpen+gTP1*Point), Digits);
         
         //rvBuyStop = 0;
         //rvBuyExit = 0; 
         
         //gHasTradedForTheDay = true;
   //      double rvBuyLot = aceCaculateLotsize(AccountBalance(), eRiskPerTrade, eStopLossBase, rvBuyOpen, rvBuyStop);
   //      gRVBuyTicket = aceOrderSend(OP_BUYSTOP,rvBuyLot,rvBuyOpen,0, rvBuyStop,rvBuyExit,COMMENT,MAGIC,TimeCurrent()+ 60*60*1, Blue);
   //      string rvBuyStatus = "[rvBuyOpen"+"]" + rvBuyOpen + 
   //                          " [rvBuyStop"+"]" + rvBuyStop +
   //                          " [rvBuyExit"+"]" + rvBuyExit +
   //                          " [rvBuyLot"+"]" + rvBuyLot +
   //                          " [rvBuyTkt"+"]" + gRVBuyTicket ;
   //      aceLog(gLogFileName, rvBuyStatus, gDoPrint, gDoLog);
   //      return ;
   //   }      
   //}
   performTrailingStop();
   return(0);
}

