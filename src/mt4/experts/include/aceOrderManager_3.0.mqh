//+------------------------------------------------------------------+
//| Module                                           aceOrderManager |
//| Version                                          2.0             |
//| LastUpdate                                       2012-07-15      |
//| Copyright                         Copyright (c) 2012, Da Mon     |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2012, Da Mon"
#property link      "liulei.forex@gmail.com"

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

#import "aceOrderManager_3.0.ex4"

//////////////////////////////////////////////////////////////
//
// all methods will be started with ace, respecting camel rule
//
//////////////////////////////////////////////////////////////

//
// get order: return lots of current orders/positions (+:Buy -: sell)
//
double aceCurrentOrders(int type, int magic);

//
// get order: return net postion, and order tickets
//
int aceGetOrderTicket(int type, int magic);

//
// send order by price, return ticket No., zero indicate failure
//
int aceOrderSend(int type, double lots, double price, int slippage, double sl, double tp, string comment, int magic, datetime expiration=0, color arrow_color=CLR_NONE);
// 
// amend order 
//
bool aceOrderModify(double sl, double tp, int magic);
bool aceOrderModifyByTicket(int ticket, double sl, double tp, int magic);


//
// close order
//
bool aceOrderClose(int slippage, int magic);
bool aceOrderCloseBySide(bool closeBuy, bool closeSell, int magic);
bool aceOrderCloseByTicket(int ticket, int magic);
bool aceOrderPartialCloseByTicket(int ticket, double closingLot, int magic);
//
// cancel pending order
//
bool aceOrderDelete(int magic);

//
// trailing stop
//
void aceTrailingStopByPoint(int magic, int Points);
void aceTrailingStopByPrice(int magic, double rawNewStopPrice);

#import