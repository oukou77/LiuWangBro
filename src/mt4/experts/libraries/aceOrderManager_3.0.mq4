//+------------------------------------------------------------------+
//| Module                                           aceOrderManager |
//| Version                                          2.0             |
//| LastUpdate                                       2012-07-15      |
//| Copyright                         Copyright (c) 2012, Da Mon     |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2012, Da Mon"
#property link      "liulei.forex@gmail.com"
#property library

#include <aceOrderManager_3.0.mqh>

// arrow color for order 
color ArrowColor[6] = {Blue, Red, Blue, Red, Blue, Red};

// waiting time
int MyOrderWaitingTime = 10;

// return lots of current orders/positions (+:Buy -: sell)
double aceCurrentOrders(int type, int magic)
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

int aceGetOrderTicket(int type, int magic)
{
   int ticket = 0;  

   for( int i=0; i<OrdersTotal(); i++ )
   {
      if(OrderSelect(i, SELECT_BY_POS) == false)
      {
         int err = GetLastError();
         Print("error(",err,"): ", ErrorDescription(err));
         break ;
      } 
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;

      switch(type)
      {
         case OP_BUY:
            if(OrderType() == OP_BUY) ticket = OrderTicket();
            break;
         case OP_SELL:
            if(OrderType() == OP_SELL) ticket = OrderTicket();
            break;
         case OP_BUYLIMIT:
            if(OrderType() == OP_BUYLIMIT) ticket = OrderTicket();
            break;
         case OP_SELLLIMIT:
            if(OrderType() == OP_SELLLIMIT) ticket = OrderTicket();
            break;
         case OP_BUYSTOP:
            if(OrderType() == OP_BUYSTOP) ticket = OrderTicket();
            break;
         case OP_SELLSTOP:
            if(OrderType() == OP_SELLSTOP) ticket = OrderTicket();
            break;
          case MY_BUYPOS:
            if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) ticket = OrderTicket();
            break;
         case MY_SELLPOS:
            if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) ticket = OrderTicket();
            break;    
         default:
            Print("[aceGetOrderTicket] : Illegel order type("+type+")");
            break;
      }
      if(ticket != 0) break;
   }
   return(ticket);
}

// success : return ticket Number
// failure : return zero
int aceOrderSend(int type, double lots, double price, int slippage, double stopLoss, double takeprofit, string comment, int magic, datetime expiration=0,color arrow_color=CLR_NONE)
{   
   //http://book.mql4.com/appendix/limits
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
         return(0);// 
      }
      if(IsTradeAllowed() == true)
      {
         RefreshRates();
         
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
            //OpenPrice <= Bid
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
         
         int ticket = OrderSend(Symbol(),type,lots,price,100,stopLoss,takeprofit,comment,magic,expiration,Blue);
         string orderStatus = "ticket["+ticket+"]"
                 + "type["+type+"]"
                 + "lots["+lots+"]"
                 + "price["+price+"]"
                 + "stopLoss["+stopLoss+"]"
                 + "takeprofit["+takeprofit+"]"
                 + "bid["+Bid+"]"
                 + "ask["+Ask+"]"
                 //+ "Spread["+(Ask-Bid)+"]"
//                 + "SpreadPoint["+MarketInfo(Symbol(),MODE_SPREAD)+"]"
                 + "StopLossLevel["+MarketInfo(Symbol(),MODE_STOPLEVEL)+"]"
                 + "FreezeLevel["+MarketInfo(Symbol(),MODE_FREEZELEVEL)+"]"
                 + "magic["+magic+"]"
                 ;
         Print (orderStatus);        
         if( ticket != -1) return(ticket);
         int err = GetLastError();
         Print("[OrderSendError] : ", err, " ", ErrorDescription(err));
         if(err == ERR_INVALID_PRICE) break;
         if(err == ERR_INVALID_STOPS) break;
      }
      else
      {
         Print("TRADING IS NOT ALLOWED!!!");
      }
      Sleep(100);
   }
   return(0);
}

bool aceOrderModify(double sl, double tp, int magic)
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

bool aceOrderModifyByTicket(int ticket, double sl, double tp, int magic)
{
   int type = 0;
   if(ticket == 0) return(false);
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_TICKET) == false) break;
      if(OrderTicket() == ticket && OrderMagicNumber() == magic) 
      { 
         type = OrderType();
         break;
      }
   }
   if (type == 0) return (false);
   
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

bool aceOrderClose(int slippage, int magic)
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
         if(OrderClose(ticket, OrderLots(), 0, slippage, Red) == true) return(true);
         int err = GetLastError();
         Print("[OrderCloseError] : ", err, " ", ErrorDescription(err));
         if(err == ERR_INVALID_PRICE) break;
      }
      Sleep(100);
   }
   return(false);
}

bool aceOrderCloseByTicket(int ticket, int magic)
{
   if(ticket == 0) return(false);
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_TICKET) == false) break;
      if(OrderTicket() == ticket && OrderMagicNumber() == magic) break;
   }  

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
         double closePrice = OrderClosePrice();
         closePrice = 0;
         if(OrderClose(ticket, OrderLots(),closePrice , 0, Red) == true)
         {
            Print("[OrderCloseSuccess] : ", ticket, " ", magic);
            return(true);
         }
         int err = GetLastError();
         Print("[OrderCloseError] : ", err, " ", ErrorDescription(err));
         if(err == ERR_INVALID_PRICE) break;
      }
      Sleep(100);
   }
   return(false);
}

bool aceOrderPartialCloseByTicket(int ticket, double lotsize, int magic)
{
   if(ticket == 0) return(false);
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_TICKET) == false) break;
      if(OrderTicket() == ticket && OrderMagicNumber() == magic) break;
   }  

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
         double closePrice = OrderClosePrice();
         closePrice = 0;
         if(OrderClose(ticket, lotsize ,closePrice , 0, Red) == true)
         {
            Print("[OrderCloseSuccess] : ", ticket, " ", magic);
            return(true);
         }
         int err = GetLastError();
         Print("[OrderCloseError] : ", err, " ", ErrorDescription(err));
         if(err == ERR_INVALID_PRICE) break;
      }
      Sleep(100);
   }
   return(false);
}


bool aceOrderCloseBySide(bool closeBuy, bool closeSell, int magic)
{
   for(int i=0; i< OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) break;
      if(OrderMagicNumber() != magic || OrderSymbol() != Symbol()) continue;

      if(OrderType()==OP_BUY && closeBuy== true)
      {
         OrderClose(OrderTicket(),OrderLots(),Bid,0,White);
         break;
      }
      if(OrderType()==OP_SELL && closeSell == true)
      {
         OrderClose(OrderTicket(),OrderLots(),Ask,0,White);         
         break;
      }
      if(OrderType()==OP_BUYLIMIT && closeBuy== true)
      {
         OrderDelete(OrderTicket());         
         break;
      }
      if(OrderType()==OP_SELLLIMIT && closeSell == true)
      {
         OrderDelete(OrderTicket());         
         break;
      }
   }
}

bool aceOrderDelete(int magic)
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

void aceTrailingStopByPoint(int magic, int Points)
{    
    double newStopPrice=0;        
    for(int i=0; i<OrdersTotal(); i++)
    {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
      double currStopLoss = OrderStopLoss();
            
      if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT)
      {         
         newStopPrice = NormalizeDouble((Close[0]-Points* Point), Digits);
         if(newStopPrice > currStopLoss || currStopLoss == 0)
         {
            aceOrderModify(newStopPrice, 0, magic);
            string status1 = "xTrailingStop_buy["+currStopLoss+"]--->>>"+ "newStopPrice["+newStopPrice+"]";
            Print (status1);
            break;
         }         
      }
      if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT )
      {         
         newStopPrice = NormalizeDouble((Close[0]+Points* Point), Digits);
         if(newStopPrice < currStopLoss || currStopLoss == 0)
         {
            aceOrderModify(newStopPrice, 0, magic);
            string status2 = "xTrailingStop_sell["+currStopLoss+"]--->>>"+ "newStopPrice["+newStopPrice+"]";
            Print (status2);
            break;
         }        
       }
     }
}

void aceTrailingStopByPrice(int magic, double rawNewStopPrice)
{
    double newStopPrice = NormalizeDouble(rawNewStopPrice, Digits);         
    //newStopPrice = 0;
             
    for(int i=0; i<OrdersTotal(); i++)
    {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
      double currStopLoss = OrderStopLoss();
            
      if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT)
      {
         //newStopPrice = NormalizeDouble(MathMin(rawNewStopPrice, OrderOpenPrice( ) - stopLossPoints * Point), Digits);
         newStopPrice = NormalizeDouble((Close[0]-newStopPrice), Digits);
         if(newStopPrice > currStopLoss || currStopLoss == 0)
         {
            aceOrderModify(newStopPrice, 0, magic);
            string status1 = "xTrailingStop_buy["+currStopLoss+"]--->>>"+ "newStopPrice["+newStopPrice+"]";
            Print (status1);
            break;
         }         
      }
      if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT)
      {
         //newStopPrice = NormalizeDouble(MathMin(rawNewStopPrice, OrderOpenPrice( ) + stopLossPoints * Point), Digits);
         newStopPrice = NormalizeDouble((Close[0]+newStopPrice), Digits);
         if(newStopPrice < currStopLoss || currStopLoss == 0)
         {
            aceOrderModify(newStopPrice, 0, magic);
            string status2 = "xTrailingStop_sell["+currStopLoss+"]--->>>"+ "newStopPrice["+newStopPrice+"]";
            Print (status2);
            break;
         }       
         
       }
     }
}

