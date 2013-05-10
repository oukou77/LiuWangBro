//+------------------------------------------------------------------+
//| Module                                           aceOrderManager |
//| Version                                          2.0             |
//| LastUpdate                                       2012-07-15      |
//| Copyright                         Copyright (c) 2012, Da Mon     |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2012, Da Mon"
#property link      "liulei.forex@gmail.com"
#property library

#include <aceRiskManager_2.0.mqh>

void acePrintAccountInfo()
{
   Print("account currency is ", AccountCurrency());
   Print("Account balance = ",AccountBalance());
   Print("Account Credit ", AccountCredit());
   Print("Account equity = ",AccountEquity());
   Print("Account #",AccountNumber(), " leverage is ", AccountLeverage());
   Print("Account margin ", AccountMargin());
   Print("Account free margin = ",AccountFreeMargin());
   Print("Market Point = ",MarketInfo("EURUSD",MODE_POINT));
   Print("Market Digits = ",MarketInfo("EURUSD",MODE_DIGITS));
   
}

/*
 * riskPerTrade : 0.02 
 */
double aceCaculateLotsize(double balance, double riskPerTrade, double maxStopLossBase, double openPrice, double stopPrice)
{
   double rawResult = 0;
   double result = 0;
   // SafeGuard from wrong or risky parameter 
   // We dont allow too risky input, too high or too low,
   if ( riskPerTrade < 0 || riskPerTrade > 0.2 ) riskPerTrade = 0.05;
   if ( maxStopLossBase < 0 || maxStopLossBase > 2 ) maxStopLossBase = 0.5;
   
   double stopLossBase = MathMin( maxStopLossBase, MathAbs(openPrice - stopPrice));
   
   rawResult = balance * riskPerTrade / stopLossBase / 10;
   if (AccountCurrency() == "JPY" )
      rawResult = rawResult / 10000 ;
   else 
      rawResult = rawResult / 100 ;
   result = MathFloor(100*rawResult)/100;
   string status = "balance["+balance+"]"
                 + "riskPerTrade["+riskPerTrade+"]"
                 + "stopLossBase["+stopLossBase+"]"                 
                 + "rawResult["+rawResult+"]"                 
                 + "result["+result+"]"
                 ;
                 
   Print(status);              
   return (result);
}