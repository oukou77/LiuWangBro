package com.lwfund.fx.mt4.calculators;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.util.MT4EODUtil;

public class PortfolioAccountAllocStatusCalculator implements
		MT4TradeCalculator {
	private String accountID;
	private double balance;
	private double equity;
	private double margin;
	private String eodStr;
	private Date eodFrom;
	private Date eodTo;
	private double deposit;
	
	@Override
	public void init(Map<String, String> parameters) {
		accountID = parameters.get(MT4Constants.ACCOUNT_ID);
		eodStr = parameters.get(MT4Constants.EOD_DATE);
		balance = Double.parseDouble(parameters.get(MT4Constants.ACCOUNT_BALANCE));
		equity = Double.parseDouble(parameters.get(MT4Constants.ACCOUNT_EQUITY));
		margin = Double.parseDouble(parameters.get(MT4Constants.ACCOUNT_MARGIN));
		
		try {
			Map<String,Date> range = MT4EODUtil.getEODDateRange(eodStr);
			eodFrom = range.get(MT4Constants.EOD_FROM_DATE);
			eodTo = range.get(MT4Constants.EOD_TO_DATE);
		} catch (ParseException e) {
			e.printStackTrace();
			eodFrom = null;
			eodTo = null;
		}
	}

	public void deinit(){
		accountID = null;
		balance = 0;
		equity = 0;
		margin = 0;
		eodStr = null;
		eodFrom = null;
		eodTo = null;
		deposit = 0;		
	}
	
	@Override
	public void process(MT4Trade trade) {
		if(accountID == null || trade == null || eodFrom == null || eodTo == null){
			return;
		}

		if(!accountID.equals(trade.getAccountID())){
			return;
		}
		
		if(trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_SELL || 
				trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_BUY || 
				trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_BROKER_ACTION ){

			if(trade.isClosed()){
				if(this.eodFrom.before(trade.getCloseTime()) && this.eodTo.after(trade.getCloseTime())){
					balance += trade.getRealProfit();
					equity = balance;
	// TODO			
					if(trade.isDepositTrade()){
						deposit += trade.getRealProfit();
					}
//					margin -= ;
				}
			}else{
				if(this.eodFrom.before(trade.getOpenTime()) && this.eodTo.after(trade.getOpenTime())){
					equity = balance + trade.getRealProfit();
	// TODO
//					margin += 
				}			
			}
		}

	}

	@Override
	public Map<String, String> calculate() {
		Map<String, String> ret = new HashMap<String, String>();
		ret.put(MT4Constants.EOD_DATE, eodStr);
		ret.put(MT4Constants.ACCOUNT_BALANCE, Double.toString(balance));
		ret.put(MT4Constants.ACCOUNT_EQUITY, Double.toString(equity));
		ret.put(MT4Constants.ACCOUNT_MARGIN, Double.toString(margin));
		ret.put(MT4Constants.ACCOUNT_DEPOSIT, Double.toString(deposit));
		return ret;
	}

}
