//+------------------------------------------------------------------+
//|                                          DumpAllClosedTrades.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

string standardFormatDateTime(string delimter="_", int currentTime=0){
   
   if(currentTime==0)currentTime=TimeCurrent();
   
   string sTimeMonth = TimeMonth(currentTime);
   if(TimeMonth(currentTime) < 10){
      sTimeMonth = "0" + TimeMonth(currentTime);
   }
   string sTimeDay = TimeDay(currentTime);
   if(TimeDay(currentTime) < 10){
      sTimeDay = "0" + TimeDay(currentTime);
   }
   string sTimeHour = TimeHour(currentTime);
   if(TimeHour(currentTime) < 10){
      sTimeHour = "0" + TimeHour(currentTime);      
   }   
   string sTimeMinute = TimeMinute(currentTime);
   if(TimeMinute(currentTime) < 10){
      sTimeMinute = "0" + TimeMinute(currentTime);
   }   
   string sTimeSeconds = TimeSeconds(currentTime);
   if(TimeSeconds(currentTime) < 10){
      sTimeSeconds = "0" + TimeSeconds(currentTime);
   }     
   
   return(StringConcatenate(TimeYear(currentTime),delimter,sTimeMonth,delimter,sTimeDay,delimter,sTimeHour,delimter,sTimeMinute,delimter,sTimeSeconds));
}

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   int currentTime = TimeCurrent();
   
   Print("Dump all closed trades @ " + TimeToStr(currentTime));
   
   string fileName = "AllClosedTradesAsOf" + standardFormatDateTime() + ".csv";

   int handle = FileOpen(fileName,FILE_CSV|FILE_WRITE,',');
   
   if(handle<0){
      Print("Open file " + fileName + " failed!!" );
      return(-1);
   }
   
   FileWrite(handle,
            "close price",
            "close time",
            "comment", 
            "commission", 
            "expiration", 
            "lots", 
            "magic number",
            "open price",
            "open time",
            "profit",
            "stop loss",
            "swap",
            "symbol",
            "take profit",
            "ticket",
            "order type");
            
   for(int i=0; i< OrdersHistoryTotal();i++){
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) break;
      FileWrite(handle,
               OrderClosePrice(),
               TimeToStr(OrderCloseTime()),
               OrderComment(),
               OrderCommission(),
               OrderExpiration(),
               OrderLots(),
               OrderMagicNumber(),
               OrderOpenPrice(),
               TimeToStr(OrderOpenTime()),
               OrderProfit(),
               OrderStopLoss(),
               OrderSwap(),
               OrderSymbol(),
               OrderTakeProfit(),
               OrderTicket(),
               OrderType());     
   }
   
   Print("done");
   
   FileClose(handle);
//----
   return(0);
  }
//+------------------------------------------------------------------+