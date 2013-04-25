//+------------------------------------------------------------------+
//|                                          StreamMarketDataEOD.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#define HR2359      86340           // 24 * 3600
#define HR0500      18000
#define HR2100      75600
#define ROUGH_BAR2359     800
#define NYC_CLOSE_IN_TKO_TIME 5
#define NYC_CLOSE_IN_LDN_TIME 21
#define EOD_CHECK_START_IN_TKO_TIME 5
#define EOD_CHECK_START_IN_LDN_TIME 11
#define EOD_CHECK_END_IN_TKO_TIME 6
#define EOD_CHECK_END_IN_LDN_TIME 16

#define CUTOFF_FILE_SIZE_BYTES_CHECK 10
#define MKT_DATA_FILE_SIZE_BYTES_CHECK 1000
#define THINKFOREX_ACCOUNT_NUMBER 120768
#define FOREXCOM_ACCOUNT_NUMBER 10952720

#import "kernel32.dll"
   int _lopen  (string path, int of);
   int _lcreat (string path, int attrib);
   int _llseek (int handle, int offset, int origin);
   int _lread  (int handle, string buffer, int bytes);
   int _lwrite (int handle, string buffer, int bytes);
   int _lclose (int handle);
#import


string SymbolsArray[]={"EURUSDpro","USDJPYpro","EURJPYpro","GBPJPYpro","AUDJPYpro","NZDJPYpro"};

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

bool IsInEODPeriod(datetime currentTime){
   bool ret = false;
   int accountnumber = AccountNumber();

   if(accountnumber == THINKFOREX_ACCOUNT_NUMBER){
   //LDN timezone
      ret = ((TimeHour(currentTime)>=EOD_CHECK_START_IN_LDN_TIME) && 
               (TimeHour(currentTime)<=EOD_CHECK_END_IN_LDN_TIME));
   }
   if(accountnumber == FOREXCOM_ACCOUNT_NUMBER){
   //TKO timezone
      ret = ((TimeHour(currentTime)>=EOD_CHECK_START_IN_TKO_TIME) && 
               (TimeHour(currentTime)<=EOD_CHECK_END_IN_TKO_TIME));     
   }
   return (ret);
}

bool isNeedToStreamMktData(){
   bool ret = false;
   ret = (FOREXCOM_ACCOUNT_NUMBER == AccountNumber());
   return (ret);
}

void getCutOffFileNames(datetime currentTime,string& cutoffFileNames[]){
   int accountnumber = AccountNumber();
   string ret[2];
   datetime cutoffDate;
   datetime previousCutOffDate;
   string location;
   if(accountnumber == THINKFOREX_ACCOUNT_NUMBER){
   //LDN timezone
      cutoffDate = iTime(Symbol(),PERIOD_D1,0);
      previousCutOffDate = iTime(Symbol(),PERIOD_D1,1);
      location = "LDN";
   }
   if(accountnumber == FOREXCOM_ACCOUNT_NUMBER){
   //TKO timezone
      cutoffDate = iTime(Symbol(),PERIOD_D1,1);
      previousCutOffDate = iTime(Symbol(),PERIOD_D1,2);
      location = "TKO";
   }
   string cutoffDateStr = stringReplace(TimeToStr(cutoffDate,TIME_DATE),".","_");
   cutoffFileNames[0] = "CutoffTimeAs" + stringReplace(TimeToStr(previousCutOffDate,TIME_DATE),".","_") + ".csv";
   cutoffFileNames[1] = "CutoffTimeAs" + cutoffDateStr + ".csv";
   cutoffFileNames[2] = cutoffDateStr + location + ".csv";
   cutoffFileNames[3] = "AccountInfoFor" + accountnumber + "As" + cutoffDateStr + ".csv";
   cutoffFileNames[4] = "TradesArchiveFor" + accountnumber + "As" + cutoffDateStr + ".csv";
}

datetime defaultCutOffTime(datetime currentTime){
   int accountnumber = AccountNumber();
   datetime ret;
   if(accountnumber == THINKFOREX_ACCOUNT_NUMBER){
   //LDN timezone
      ret = iTime(Symbol(),PERIOD_D1,1) + HR2100;
   }
   if(accountnumber == FOREXCOM_ACCOUNT_NUMBER){
   //TKO timezone
      ret = iTime(Symbol(),PERIOD_D1,1) + HR0500;     
   }   
   return (ret);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
   datetime currentTime = TimeCurrent();
   
   if(!IsInEODPeriod(currentTime)){
      Print("not in EOD process period");
      return(0);
   }
   
   string cutoffFileNames[5];
   getCutOffFileNames(currentTime,cutoffFileNames);
   
   int handle = -1;
   handle = FileOpen(cutoffFileNames[1],FILE_CSV|FILE_READ,',');
   if(handle>=0){
      if(FileSize(handle) > CUTOFF_FILE_SIZE_BYTES_CHECK){
         Print("EOD already processed for " + cutoffFileNames[1]);
         FileClose(handle);
         return(0);
      }
   }
   
   datetime startTiming;
   handle = FileOpen(cutoffFileNames[0],FILE_CSV|FILE_READ,',');
   if(handle<0){
      Print("can not find previous cutoff file " + cutoffFileNames[0]);
      startTiming = defaultCutOffTime(currentTime);
      Print("using default start " + TimeToStr(startTiming,TIME_DATE|TIME_SECONDS));
   }else{
      string previousCutoffTime =FileReadString(handle);
      startTiming = StrToTime(previousCutoffTime);
      FileClose(handle);
   }
   
   Print("current cutoff filename is " + cutoffFileNames[1]);
   int iStart = 0;
   int iEnd = 0;
   
   //Stream Market data information
   //only on TKO server
   if(isNeedToStreamMktData()){
      for(int i=0;i<ArraySize(SymbolsArray); i++){
      
         string symbolName = SymbolsArray[i];
         string fileName = symbolName + cutoffFileNames[2];
      
         Print("Processing " + symbolName + "With " +  fileName);
      
         iStart = iBarShift(symbolName,PERIOD_M1,startTiming);
         iEnd = iBarShift(symbolName,PERIOD_M1,currentTime);
         
         if((iStart - iEnd) < ROUGH_BAR2359){
            Print("Market data is not ready for "+ symbolName + " with date " + fileName);
            continue;
         }
      
         handle = FileOpen(fileName,FILE_CSV|FILE_READ,',');
 
         if(handle>=0){
            if(FileSize(handle) > MKT_DATA_FILE_SIZE_BYTES_CHECK){
               Print("EOD already processed for " + symbolName + " with date " + fileName);
               FileClose(handle);
               continue;
            }
         }

         handle = FileOpen(fileName,FILE_CSV|FILE_WRITE,',');
      
          for(int j = iStart; j >= iEnd; j--){
            FileWrite(handle,TimeToStr(iTime(symbolName,PERIOD_M1,j),TIME_DATE),TimeToStr(iTime(symbolName,PERIOD_M1,j),TIME_MINUTES),iOpen(symbolName,PERIOD_M1,j),
            iHigh(symbolName,PERIOD_M1,j),iLow(symbolName,PERIOD_M1,j),iClose(symbolName,PERIOD_M1,j),iVolume(symbolName,PERIOD_M1,j));        
         }
         FileClose(handle);
      }
   }
   
   //Stream Account Information
   handle = FileOpen(cutoffFileNames[3],FILE_CSV|FILE_WRITE,",");
   Print("Streaming out account information to " + cutoffFileNames[3]);
   FileWrite(handle,"account number", "account balance",
                     "account profit", "account equity", 
                     "account free margin","account margin");
   FileWrite(handle,AccountNumber(),AccountBalance(),AccountProfit(),AccountEquity(),AccountFreeMargin(),AccountMargin());
   FileClose(handle);
   
   //Stream Trades Information
   handle = FileOpen(cutoffFileNames[4],FILE_CSV|FILE_WRITE,",");
   Print("Streaming out trades archive to " + cutoffFileNames[4]);
   //header
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
         "order type",
         "account id",
         "is closed");
         
   //first closed trades
   for(int m=0; m<OrdersHistoryTotal();m++){
      if(OrderSelect(m,SELECT_BY_POS,MODE_HISTORY)==false) break;
      int closeTime = OrderCloseTime();
      if(closeTime >= startTiming && closeTime <= currentTime){
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
               OrderType(),
               AccountNumber(),"1");          
      }
   }
   
   //second check market and pending trades
   for(int k=0;k<OrdersTotal();k++){
      
      if(OrderSelect(k,SELECT_BY_POS,MODE_TRADES)==false) break;
      
      int openTime = OrderOpenTime();
      
      int normalizeCloseTime = OrderCloseTime();
      string sCloseTime = "0";
      if(normalizeCloseTime !=0) sCloseTime = TimeToStr(normalizeCloseTime);
      
      if(openTime >= startTiming && openTime <= currentTime ){
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
               OrderType(),
               AccountNumber(),"0");                
      }
   }
   FileClose(handle);
   
   //finally, cutoff time file
   handle = FileOpen(cutoffFileNames[1],FILE_CSV|FILE_WRITE,',');
   Print("EOD process finished");
   FileWrite(handle,TimeToStr(currentTime,TIME_DATE|TIME_SECONDS));
   FileClose(handle);
//----
   return(0);
  }
//+------------------------------------------------------------------+