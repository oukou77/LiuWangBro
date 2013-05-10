//+------------------------------------------------------------------+
//| Module                                           aceUtil        |
//| Version                                          2.0            |
//| LastUpdate                                       2012-09-26      |
//| Copyright                         Copyright (c) 2012, Da Mon     |
//+-------------------------------------------------------------------+
// History :
// 2012-09-25     2.0  Orignal (get ISO date/ISO time stamp/get log file name)
#property copyright "Copyright (c) 2012, Da Mon"
#property link      "liulei.forex@gmail.com"

#include <stderror.mqh>
#include <stdlib.mqh>

//
// all methods defined in this lib will be started with ace, respecting camel rule
// 
#import "aceUtil_2.0.ex4"
// return YYYY-MM-DD
string aceGetISODate();
// return HH24:MI:SS
string aceGetISOTimeStamp();
// return YYYY-MM-DD_HH24:MI:SS
string aceGetISODateTimeStamp();
// return YYYY-MM-DD_HH24:MI:SS
string aceGetDateTimeStamp();

// return algo-ver-instance-date-timestamp
string aceGetLogFileName(string algo_and_ver, string instance, string symbol, string timeframe);
void aceLog(string fileName, string msg);

#import