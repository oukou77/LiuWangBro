//+------------------------------------------------------------------+
//|                                         DumpMarketDataScript.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property show_inputs

extern datetime WhenStart;

#define HR2359      86340           // 24 * 3600
#define HR0500      18000
#define ROUGH_BAR2359     1000
#define NYC_CLOSE 5

string SymbolsArray[]={"EURUSDpro","USDJPYpro","EURJPYpro","GBPJPYpro","AUDJPYpro","NZDJPYpro"};
//string SymbolsArray[] = {"USDJPYpro"};
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
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {

   Print("when is " + WhenStart);
   if(WhenStart ==0)
   {
      WhenStart = iTime(Symbol(),PERIOD_D1,1);
      if(TimeHour(TimeCurrent())<=NYC_CLOSE){
         Print("NYC is not closed yet");
         return(-1);
      }
   }else{
      if(WhenStart > TimeCurrent()){
         Print("You put date in future");
         return(-1);
      }
   }
   
   WhenStart += HR0500;
   
   string whenStr = TimeToStr(WhenStart,TIME_DATE);
   int handle = -1;
   Print("when is " + stringReplace(whenStr,".","_"));
   int iStart = 0;
   int iEnd = 0;
   for(int i=0;i<ArraySize(SymbolsArray); i++){
      
      string symbolName = SymbolsArray[i];
      Print("Processing " + symbolName + "With " +  whenStr);

      iStart = iBarShift(symbolName,PERIOD_M1,WhenStart);
      iEnd = iBarShift(symbolName,PERIOD_M1,WhenStart+HR2359);
      
      if((iStart - iEnd) < ROUGH_BAR2359){
         Print("haha" + (iStart - iEnd));
         Print("Market data is not ready for "+ symbolName + " with date " + whenStr);
         continue;
      }
      
      handle = FileOpen(symbolName + stringReplace(whenStr,".","_")+"TKOtime.csv",FILE_CSV|FILE_WRITE,',');
      if(handle<0){
         Print("open file failed when handle" + symbolName + " with date " + whenStr);
         continue;
      }
      
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