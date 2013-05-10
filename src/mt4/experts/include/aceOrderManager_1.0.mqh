//+------------------------------------------------------------------+
//|                                                     mtdlpLib.mqh |
//|                                   Copyright (c) 2012, Da Monster |
//|                                         mtdlp@hotmail.com        |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2012, Da Monster"
#property link      "mtdlp@hotmail.com"

#include <stderror.mqh>
#include <stdlib.mqh>

#define MY_OPENPOS   6
#define MY_LIMITPOS  7
#define MY_STOPPOS   8
#define MY_PENDPOS   9
#define MY_BUYPOS   10
#define MY_SELLPOS  11
#define MY_ALLPOS   12

#define BUY_CHANCE 1
#define SELL_CHANCE -1
#define NO_CHANCE 0

#define xTrend_VerticalUp 3
#define xTrend_SharpUp 2
#define xTrend_MinorUp 1
#define xTrend_NotClear 0
#define xTrend_MinorDown  -1
#define xTrend_SharpDown  -2
#define xTrend_VerticalDown -3

#define xAction_LongMore 3
#define xAction_LongNew 2
#define xAction_ExitShort 1
#define xAction_None 0
#define xAction_ExitLong -1
#define xAction_ShortNew  -2
#define xAction_ShortMore -3

//
// all methods defined in this lib will be started with x, respecting camel rule
// 
#import "aceOrderManager_1.0.ex4"
// return lots of current orders/positions (+:Buy -: sell)
double xCurrentOrders(int type, int magic);
// send order by price
bool xOrderSend(int type, double lots, double price, int slippage, double sl, double tp, string comment, int magic, datetime expiration=0, color arrow_color=CLR_NONE);
// amend order by price
bool xOrderModify(double sl, double tp, int magic);
// close order
bool xOrderClose(int slippage, int magic);
// cancel pending order
bool xOrderDelete(int magic);
#import