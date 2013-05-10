//+------------------------------------------------------------------+
//|                                                     mtdlpLib.mqh |
//|                                   Copyright (c) 2012, Da Monster |
//|                                         mtdlp@hotmail.com        |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2012, Da Monster"
#property link      "mtdlp@hotmail.com"
#property library


#include <mtdlpLib_2_0.mqh>

// arrow color for order 
color ArrowColor[6] = {Blue, Red, Blue, Red, Blue, Red};

// waiting time
int MyOrderWaitingTime = 10;

// return lots of current orders/positions (+:Buy -: sell)
double xCurrentOrders(int type, int magic)
{
   double lots = 0.0;

   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;

      switch(type)
      {
         case OP_BUY:
            if(OrderType() == OP_BUY) lots += OrderLots();
            break;
         case OP_SELL:
            if(OrderType() == OP_SELL) lots -= OrderLots();
            break;
         case OP_BUYLIMIT:
            if(OrderType() == OP_BUYLIMIT) lots += OrderLots();
            break;
         case OP_SELLLIMIT:
            if(OrderType() == OP_SELLLIMIT) lots -= OrderLots();
            break;
         case OP_BUYSTOP:
            if(OrderType() == OP_BUYSTOP) lots += OrderLots();
            break;
         case OP_SELLSTOP:
            if(OrderType() == OP_SELLSTOP) lots -= OrderLots();
            break;
         case MY_OPENPOS:
            if(OrderType() == OP_BUY) lots += OrderLots();
            if(OrderType() == OP_SELL) lots -= OrderLots();
            break;
         case MY_LIMITPOS:
            if(OrderType() == OP_BUYLIMIT) lots += OrderLots();
            if(OrderType() == OP_SELLLIMIT) lots -= OrderLots();
            break;
         case MY_STOPPOS:
            if(OrderType() == OP_BUYSTOP) lots += OrderLots();
            if(OrderType() == OP_SELLSTOP) lots -= OrderLots();
            break;
         case MY_PENDPOS:
            if(OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) lots += OrderLots();
            if(OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) lots -= OrderLots();
            break;
         case MY_BUYPOS:
            if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) lots += OrderLots();
            break;
         case MY_SELLPOS:
            if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) lots -= OrderLots();
            break;
         case MY_ALLPOS:
            if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) lots += OrderLots();
            if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) lots -= OrderLots();
            break;
         default:
            Print("[CurrentOrdersError] : Illegel order type("+type+")");
            break;
      }
      if(lots != 0) break;
   }
   return(lots);
}

bool xOrderSend(int type, double lots, double price, int slippage, double stopLoss, double takeprofit, string comment, int magic, datetime expiration=0,color arrow_color=CLR_NONE)
{
   //http://book.mql4.com/appendix/limits
   price = NormalizeDouble(price, Digits);
   price = NormalizeDouble(price, Digits);
   stopLoss = NormalizeDouble(stopLoss, Digits);
   takeprofit = NormalizeDouble(takeprofit, Digits);

   double freezeLevel = (MarketInfo(Symbol(),MODE_FREEZELEVEL)+1)* Point;
   double StopLossLevel = (MarketInfo(Symbol(),MODE_STOPLEVEL)+1)* Point;
   double spreadLevel = MarketInfo(Symbol(),MODE_SPREAD)* Point;   
   
   int starttime = GetTickCount();
   while(true)
   {
      if(GetTickCount() - starttime > MyOrderWaitingTime*1000)
      {
         Alert("OrderSend timeout. Check the experts log.");
         return(false);
      }
      if(IsTradeAllowed() == true)
      {
         RefreshRates();
         string sellstatus = "type["+type+"]"
                 + "lots["+lots+"]"
                 + "price["+price+"]"
                 + "stopLoss["+stopLoss+"]"
                 + "takeprofit["+takeprofit+"]"
                 + "bid["+Bid+"]"
                 + "ask["+Ask+"]"
                 + "Spread["+(Ask-Bid)+"]"
                 + "SpreadPoint["+MarketInfo(Symbol(),MODE_SPREAD)+"]"
                 + "StopLossLevel["+MarketInfo(Symbol(),MODE_STOPLEVEL)+"]"
                 + "FreezeLevel["+MarketInfo(Symbol(),MODE_FREEZELEVEL)+"]"
                 + "magic["+magic+"]"
                 ;
         Print (sellstatus);
         if (type == OP_BUY)
         {
            price = Ask;
            if(stopLoss !=0 )
            {
               stopLoss = MathMin(stopLoss, Bid-StopLossLevel);               
            }
            if(takeprofit!=0)
            {
               takeprofit = MathMax(takeprofit, Bid+StopLossLevel);
            }
         }
         else if (type == OP_SELL)
         {
            price = Bid;
            if(stopLoss !=0 )
            {
               stopLoss = MathMax(stopLoss, Ask+StopLossLevel);               
            }
            if(takeprofit!=0)
            {
               takeprofit = MathMin(takeprofit, Ask-StopLossLevel);
            }            
         }
         else if (type == OP_BUYLIMIT)
         {
            //Ask-OpenPrice >= StopLevel
            //OpenPrice-SL >= StopLevel
            //TP-OpenPrice >= StopLevel
            price = MathMin(price,Ask-StopLossLevel);
            if(stopLoss !=0 )
            {
               stopLoss = MathMin(stopLoss, price-StopLossLevel);               
            }
            if(takeprofit!=0)
            {
               takeprofit = MathMax(takeprofit, price+StopLossLevel);
            }
         }
         else if (type == OP_SELLLIMIT)
         {
            price = MathMax(price,Bid+StopLossLevel);
            if(stopLoss !=0 )
            {
               stopLoss = MathMax(stopLoss, price+StopLossLevel);               
            }
            if(takeprofit!=0)
            {
               takeprofit = MathMin(takeprofit, price-StopLossLevel);
            }            
         }
         else if (type == OP_BUYSTOP)
         {
            //OpenPrice >= Ask
            price = MathMax(price,Ask+StopLossLevel);
            if(stopLoss !=0 )
            {
               stopLoss = MathMin(stopLoss, price-StopLossLevel);               
            }
            if(takeprofit!=0)
            {
               takeprofit = MathMax(takeprofit, price+StopLossLevel);
            } 
         }
         else if (type == OP_SELLSTOP)
         {
            //OpenPrice >= Ask
            price = MathMin(price, Bid-StopLossLevel);
            if(stopLoss !=0 )
            {
               stopLoss = MathMax(stopLoss, price+StopLossLevel);               
            }
            if(takeprofit!=0)
            {
               takeprofit = MathMin(takeprofit, price-StopLossLevel);
            }       
         }
         
         if(OrderSend(Symbol(),type,lots,price,100,stopLoss,takeprofit,comment,magic,expiration,Blue) != -1) return(true);
         int err = GetLastError();
         Print("[OrderSendError] : ", err, " ", ErrorDescription(err));
         if(err == ERR_INVALID_PRICE) break;
         if(err == ERR_INVALID_STOPS) break;
      }
      Sleep(100);
   }
   return(false);
}

bool xOrderModify(double sl, double tp, int magic)
{
   int ticket = 0;
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
      int type = OrderType();
      if(type == OP_BUY || type == OP_SELL)
      {
         ticket = OrderTicket();
         break;
      }
   }
   if(ticket == 0) return(false);

   sl = NormalizeDouble(sl, Digits);
   tp = NormalizeDouble(tp, Digits);

   if(sl == 0) sl = OrderStopLoss();
   if(tp == 0) tp = OrderTakeProfit();

   if(OrderStopLoss() == sl && OrderTakeProfit() == tp) return(false);

   int starttime = GetTickCount();
   while(true)
   {
      if(GetTickCount() - starttime > MyOrderWaitingTime*1000)
      {
         Alert("OrderModify timeout. Check the experts log.");
         return(false);
      }
      if(IsTradeAllowed() == true)
      {
         if(OrderModify(ticket, 0, sl, tp, 0, ArrowColor[type]) == true) return(true);
         int err = GetLastError();
         Print("[OrderModifyError] : ", err, " ", ErrorDescription(err));
         if(err == ERR_NO_RESULT) break;
         if(err == ERR_INVALID_STOPS) break;
      }
      Sleep(100);
   }
   return(false);
}


bool xOrderClose(int slippage, int magic)
{
   int ticket = 0;
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
      int type = OrderType();
      if(type == OP_BUY || type == OP_SELL)
      {
         ticket = OrderTicket();
         break;
      }
   }
   if(ticket == 0) return(false);

   int starttime = GetTickCount();
   while(true)
   {
      if(GetTickCount() - starttime > MyOrderWaitingTime*1000)
      {
         Alert("OrderClose timeout. Check the experts log.");
         return(false);
      }
      if(IsTradeAllowed() == true)
      {
         RefreshRates();
         if(OrderClose(ticket, OrderLots(), OrderClosePrice(), slippage, Red) == true) return(true);
         int err = GetLastError();
         Print("[OrderCloseError] : ", err, " ", ErrorDescription(err));
         if(err == ERR_INVALID_PRICE) break;
      }
      Sleep(100);
   }
   return(false);
}

bool xOrderDelete(int magic)
{
   int ticket = 0;
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
      int type = OrderType();
      if(type != OP_BUY && type != OP_SELL)
      {
         ticket = OrderTicket();
         break;
      }
   }
   if(ticket == 0) return(false);

   int starttime = GetTickCount();
   while(true)
   {
      if(GetTickCount() - starttime > MyOrderWaitingTime*1000)
      {
         Alert("OrderDelete timeout. Check the experts log.");
         return(false);
      }
      if(IsTradeAllowed() == true)
      {
         if(OrderDelete(ticket) == true) return(true);
         int err = GetLastError();
         Print("[OrderDeleteError] : ", err, " ", ErrorDescription(err));
      }
      Sleep(100);
   }
   return(false);
}

void xTrailingStop(int magic, int stopLossPoints)
{    
    double newStopPrice=0;        
    for(int i=0; i<OrdersTotal(); i++)
    {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
      double currStopLoss = OrderStopLoss();
            
      if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT)
      {         
         newStopPrice = NormalizeDouble((Close[0]-stopLossPoints* Point), Digits);
         if(newStopPrice > currStopLoss || currStopLoss == 0)
         {
            xOrderModify(newStopPrice, 0, magic);
            string status1 = "xTrailingStop_buy["+currStopLoss+"]--->>>"+ "newStopPrice["+newStopPrice+"]";
            Print (status1);
            break;
         }         
      }
      if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT)
      {         
         newStopPrice = NormalizeDouble((Close[0]+stopLossPoints* Point), Digits);
         if(newStopPrice < currStopLoss || currStopLoss == 0)
         {
            xOrderModify(newStopPrice, 0, magic);
            string status2 = "xTrailingStop_sell["+currStopLoss+"]--->>>"+ "newStopPrice["+newStopPrice+"]";
            Print (status2);
            break;
         }        
       }
     }
}

