//+------------------------------------------------------------------+
//|                                                       2Bands.mq4 |
//|                                 Copyright 2013, 2BSoftware Corp. |
//|                                                http://www.2b.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, 2BSoftware Corp."
#property link      "http://www.2b.org"
#define MAGIC 20130403
//--- input parameters
extern int BD_timeframe=1440;
extern string BD_symbol="EURJPY";

extern double Lots=0.1;           //lotÊý
extern int Slippage=3;
extern double TrailingStop=1;           //lotÊý
static double TSSell=0;
static double TSBuy=0;
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
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
void ClosePositions()
  {
//----
     if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)==true &&
        OrderMagicNumber()== MAGIC && OrderSymbol()==Symbol()) {
        double ValueBBand0 = iBands(BD_symbol,BD_timeframe,20,0,1,PRICE_CLOSE,0,0);
        double ValueBBand3 = iBands(BD_symbol,BD_timeframe,20,3,1,PRICE_CLOSE,MODE_UPPER,0);
        
        double ValueSBand0 = iBands(BD_symbol,BD_timeframe,20,0,1,PRICE_CLOSE,0,0);
        double ValueSBand3 = iBands(BD_symbol,BD_timeframe,20,3,1,PRICE_CLOSE,MODE_LOWER,0);
         
         if(OrderType()==OP_BUY){
            if(TSBuy==0) {
               TSBuy = Bid - TrailingStop;
            }else if (Bid > (TSBuy + TrailingStop)){
               TSBuy = Bid - TrailingStop;
            }
            Print("TSBuy:"+TSBuy);
            if (Bid<=TSBuy || Bid <=ValueBBand0 || Bid >= ValueBBand3){
               OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,White);
            }
         }
         if(OrderType()==OP_SELL){
            if(TSSell==0) {
               TSSell = Ask + TrailingStop;
            }else if (Ask < (TSSell - TrailingStop)){
               TSSell = Ask + TrailingStop;
            }
            
            if (Ask>=TSSell || Ask >=ValueSBand0 || Ask <= ValueSBand3){
               OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,White);
            }
         }
     }
//----
   
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if(OrdersTotal() < 1){
      if(Volume[0]>1 || IsTradeAllowed()==false) return(0);
      double ValueBBand1 = iBands(BD_symbol,BD_timeframe,20,1,1,PRICE_CLOSE,MODE_UPPER,0);
      Print("ValueBBand1:"+ValueBBand1);
      double ValueBBand2 = iBands(BD_symbol,BD_timeframe,20,2,1,PRICE_CLOSE,MODE_UPPER,0);
      Print("ValueBBand2:"+ValueBBand2);
      double OldBBand1 = iBands(BD_symbol,BD_timeframe,20,1,2,PRICE_CLOSE,MODE_UPPER,0);
      Print("OldBBand1:"+OldBBand1);
      double ValueSBand1 = iBands(BD_symbol,BD_timeframe,20,1,1,PRICE_CLOSE,MODE_LOWER,0);
      Print("ValueSBand1:"+ValueSBand1);
      double ValueSBand2 = iBands(BD_symbol,BD_timeframe,20,2,1,PRICE_CLOSE,MODE_LOWER,0);
      Print("ValueSBand2:"+ValueSBand2);
      double OldSBand1 = iBands(BD_symbol,BD_timeframe,20,1,2,PRICE_CLOSE,MODE_LOWER,0);
      Print("OldSBand1:"+OldSBand1);
   
      Print("Close[1]:"+Close[1]);
      Print("Open[1]:"+Open[1]);
      //buy
      if(Close[1]>Open[1] && Close[1]>ValueBBand1 && Close[1]<ValueBBand2 && Close[2]<=OldBBand1){
         OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"",MAGIC,0,Blue);
      }
      
      //sell
      if(Close[1]<Open[1] && Close[1]<ValueSBand1 && Close[1]>ValueSBand2 && Close[2]>=OldSBand1){
         OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"",MAGIC,0,Red);
      }
   }else{
      ClosePositions();
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+