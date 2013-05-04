package com.lwfund.fx.mt4.calculators;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import com.lwfund.fx.mt4.MT4Algorithm;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.dblayer.AlgorithmAccessor;
import com.lwfund.fx.mt4.util.MT4EODUtil;

public class AlgoAllocationStatusCalculator implements MT4TradeCalculator {
	private String accountID;
	private String algoID;
	private Date eodFrom;
	private Date eodTo;
	private double equity;
	private double balance;
	private double margin;
	private double allocation;
	private static final DateFormat sdf = new SimpleDateFormat(
			MT4Constants.DEFAULT_DATE_FORMAT);
	private MT4Algorithm algo;
	private double usedMargin;
	
	@Override
	public void init(Map<String, String> parameters){
		accountID = parameters.get(MT4Constants.TRADE_ACCOUNT_ID);
		algoID = parameters.get(MT4Constants.ALGORITHM_ID);
		algo = AlgorithmAccessor.getAllAlgos().get(algoID);
		String eodStr = parameters.get(MT4Constants.EOD_DATE);
		balance = Double.parseDouble(parameters.get(MT4Constants.ALGORITHM_BALANCE));
		equity = Double.parseDouble(parameters.get(MT4Constants.ALGORITHM_EQUITY));
		margin = Double.parseDouble(parameters.get(MT4Constants.ALGORITHM_MARGIN));
		
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

	@Override
	public void process(MT4Trade trade) {
		if(algo == null || trade == null || eodFrom == null || eodTo == null){
			return;
		}

		if(algo.getMagicNumber() != trade.getMagicNumber()){
			return;
		}
		
		if(trade.getOrderType() > MT4Constants.TRADE_ORDER_TYPE_SELL){
			return;
		}
		
		if(trade.isClosed()){
			if(this.eodFrom.before(trade.getCloseTime()) && this.eodTo.after(trade.getCloseTime())){
				balance += trade.getRealProfit();
				equity += trade.getRealProfit();
				margin -= ;
			}
		}else{
			if(this.eodFrom.before(trade.getOpenTime()) && this.eodTo.after(trade.getOpenTime())){
				equity += trade.getRealProfit();
				margin += 
			}			
		}
		
	}

	@Override
	public Map<String, String> calculate() {
		// TODO Auto-generated method stub
		return null;
	}

}
