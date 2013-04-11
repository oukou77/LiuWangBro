//+------------------------------------------------------------------+
//|                                          StreamMarketDataEOD.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#define HR2359      86340           // 24 * 3600
#define HR0500      18000
#define ROUGH_BAR2359     1000
#define NYC_CLOSE 5
#define EOD_CHECK_START 5
#define EOD_CHECK_END 6
#define FILE_SIZE_BYTES_CHECK 10000

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
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if(TimeHour(TimeCurrent()) < EOD_CHECK_START || TimeHour(TimeCurrent()) > EOD_CHECK_END){
      Print("out of EOD processing timeframe");
      return(-1);
   }
  
   int startDate = iTime(Symbol(),PERIOD_D1,1);
   int startTiming = startDate + HR0500;
  
   string whenStr = TimeToStr(startTiming,TIME_DATE);
   int handle = -1;
   Print("when is " + stringReplace(whenStr,".","_"));
   int iStart = 0;
   int iEnd = 0;
   for(int i=0;i<ArraySize(SymbolsArray); i++){
      
      string symbolName = SymbolsArray[i];
      string fileName = symbolName + stringReplace(whenStr,".","_")+"TKOtime.csv";
      
      Print("Processing " + symbolName + "With " +  whenStr);
      
      iStart = iBarShift(symbolName,PERIOD_M1,startTiming);
      iEnd = iBarShift(symbolName,PERIOD_M1,startTiming+HR2359);
      
      if((iStart - iEnd) < ROUGH_BAR2359){
         Print("haha" + (iStart - iEnd));
         Print("Market data is not ready for "+ symbolName + " with date " + whenStr);
         continue;
      }
      
      handle = FileOpen(symbolName + stringReplace(whenStr,".","_")+"TKOtime.csv",FILE_CSV|FILE_READ,',');
 
      if(handle>=0){
         if(FileSize(handle) > FILE_SIZE_BYTES_CHECK){
            Print("EOD already processed for " + symbolName + " with date " + whenStr);
            FileClose(handle);
            continue;
         }
      }

      handle = FileOpen(symbolName + stringReplace(whenStr,".","_")+"TKOtime.csv",FILE_CSV|FILE_WRITE,',');
      
       for(int j = iStart; j >= iEnd; j--){
         FileWrite(handle,TimeToStr(iTime(symbolName,PERIOD_M1,j),TIME_DATE),TimeToStr(iTime(symbolName,PERIOD_M1,j),TIME_MINUTES),iOpen(symbolName,PERIOD_M1,j),
         iHigh(symbolName,PERIOD_M1,j),iLow(symbolName,PERIOD_M1,j),iClose(symbolName,PERIOD_M1,j),iVolume(symbolName,PERIOD_M1,j));        
      }
      FileClose(handle);
   }
  
//----
   return(0);
  }
//+------------------------------------------------------------------+