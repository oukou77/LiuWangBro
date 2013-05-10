//+------------------------------------------------------------------+
//| Module                                           aceRiskManager |
//| Version                                          2.0             |
//| LastUpdate                                       2012-08-08      |
//| Copyright                         Copyright (c) 2012, Da Mon     |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2012, Da Mon"
#property link      "liulei.forex@gmail.com"

#include <stderror.mqh>
#include <stdlib.mqh>

#define MY_OPENPOS   6

//
// all methods defined in this lib will be started with x, respecting camel rule
// 
#import "aceRiskManager_2.0.ex4"

void acePrintAccountInfo();

double aceCaculateLotsize(double balance, double riskPerTrade, double slPips, double openPrice, double stopPrice);

#import