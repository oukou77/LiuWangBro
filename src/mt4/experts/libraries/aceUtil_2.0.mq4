//+------------------------------------------------------------------+
//| Module                                           aceUtil |
//| Version                                          2.0             |
//| LastUpdate                                       2012-09-15      |
//| Copyright                         Copyright (c) 2012, Da Mon     |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2012, Da Mon"
#property link      "liulei.forex@gmail.com"
#property library

#include <aceUtil_2.0.mqh>

//
// Date & Time Util
//

// return YYYY-MM-DD
string aceGetISODate()
{
   string result = TimeYear(Time[0]) + "-" + TimeMonth(Time[0]) + "-" + TimeDay(Time[0]);
   result = Year() + "-" + Month() + "-" + Day();
  
  return (result);
}
// return HH24:MI:SS
string aceGetISOTimeStamp()
{
   return (Hour() + "-" + Minute() + "-" + Seconds());
   //return (TimeToStr(TimeCurrent(),TIME_SECONDS));
   
}
// return YYYY-MM-DD_HH24:MI:SS
string aceGetISODateTimeStamp()
{ 
   return (aceGetISODate()+ "_" + aceGetISOTimeStamp());
}

//
// Log File Util
//

// return algo-ver-instance-date-timestamp
string aceGetLogFileName(string algo_and_ver, string instance, string symbol, string timeframe)
{
   return (algo_and_ver + "_" + instance + "_" + symbol + "_" + timeframe + "_" + aceGetISODateTimeStamp()+ ".log");
}

// return folder + log file
void aceLog2(int hFile, string msg)
{  
   Print(msg);
   if( hFile > 0 )
   {
     FileSeek(hFile, 0, SEEK_SET);
     //---- add data to the end of file
     string timestamp = TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
     string logLine = "[" + timestamp + "]" + msg; 
     FileWrite(hFile, logLine);  
     FileFlush(hFile);       
    }
    else
    {
      Print("Log File Handle is NULL");
    }  
}

// return folder + log file
void aceLog(string fileName, string msg)
{  
   Print(msg);
   return(0);
   int hFile= FileOpen(fileName, FILE_READ | FILE_WRITE |  FILE_CSV,";");
   if( hFile > 0 )
   {
     FileSeek(hFile, 0, SEEK_END);
     //---- add data to the end of file
     string timestamp = TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
     string logLine = "[" + timestamp + "] " + msg; 
     FileWrite(hFile, logLine);  
     FileClose(hFile);  
    }
    else
    {
      Print("Log File Handle is NULL");
    }  
}