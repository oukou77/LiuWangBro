//+------------------------------------------------------------------+
//|                                           StreamTradeArchive.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#define HR2359      86340           // 24 * 3600
#define HR0500      18000
#define EOD_CHECK_START 5
#define EOD_CHECK_END 6
#define FILE_SIZE_BYTES_CHECK 128

/**
* search for the string needle in the string haystack and replace all
* occurrecnes with replace.
*/
string stringReplace(string haystack, string needle, string replace=""){
   string left, right;
   int start=0;
   int rlen = StringLen(replace);
   int nlen = StringLen(needle);
   while (start > -1){
      start = StringFind(haystack, needle, start);
      if (start > -1){
         if(start > 0){
            left = StringSubstr(haystack, 0, start);
         }else{
            left="";
         }
         right = StringSubstr(haystack, start + nlen);
         haystack = left + replace + right;
         start = start + rlen;
      }
   }
   return (haystack);  
}  

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
   
   //out of EOD processing time frame
   if(TimeHour(TimeCurrent()) < EOD_CHECK_START || TimeHour(TimeCurrent()) > EOD_CHECK_END){
      return(0);
   }
     
   int startDate = iTime(Symbol(),PERIOD_D1,1);
   int startTiming = startDate + HR0500;
   int endTiming = startTiming + HR2359;
   
   Print("Archiving trades between " + TimeToStr(startTiming) + " and " + TimeToStr(endTiming));
   
   string fileName = StringConcatenate("TradeArchiveFor",stringReplace(TimeToStr(startTiming,TIME_DATE),".","_"),"TKO.csv");
   
   //logic to figure out if trade archive is already done
   int handle = FileOpen(fileName,FILE_CSV|FILE_READ,',');
 
   if(handle>=0){
      if(FileSize(handle) > FILE_SIZE_BYTES_CHECK){
         Print("EOD already processed for " + fileName + " with date " + TimeToStr(startDate,TIME_DATE));
            FileClose(handle);
            return(0);
      }
   }
   
   //fresh and go
   handle = FileOpen(fileName,FILE_CSV|FILE_WRITE,',');
   
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
   
   //first check closed trades
   for(int j=0; j<OrdersHistoryTotal();j++){
   
      if(OrderSelect(j,SELECT_BY_POS,MODE_HISTORY)==false) break;
      
      int closeTime = OrderCloseTime();
      
      if(closeTime >= startTiming && closeTime <= endTiming){
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
   }
              
   //second check market and pending trades
   for(int i=0;i<OrdersTotal();i++){
      
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      
      int openTime = OrderOpenTime();
      
      int normalizeCloseTime = OrderCloseTime();
      string sCloseTime = "0";
      if(normalizeCloseTime !=0) sCloseTime = TimeToStr(normalizeCloseTime);
      
      if(openTime >= startTiming && openTime <= endTiming ){
            FileWrite(handle,
               OrderClosePrice(),
               sCloseTime,
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
   }
   
   FileClose(handle);

//----
   return(0);
  }
//+------------------------------------------------------------------+