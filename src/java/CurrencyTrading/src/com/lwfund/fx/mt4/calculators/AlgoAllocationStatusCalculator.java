package com.lwfund.fx.mt4.calculators;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.lwfund.fx.mt4.MT4Algorithm;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.dblayer.AlgorithmAccessor;
import com.lwfund.fx.mt4.util.MT4EODUtil;

public class AlgoAllocationStatusCalculator implements MT4TradeCalculator {
	private String algoID;
	private Date eodFrom;
	private Date eodTo;
	private String eodStr;
	private double equity;
	private double balance;
	private double margin;
	private static final DateFormat sdf = new SimpleDateFormat(
			MT4Constants.DEFAULT_DATE_FORMAT);
	private MT4Algorithm algo;
	private double usedMargin;
	
	@Override
	public void init(Map<String, String> parameters){
		algoID = parameters.get(MT4Constants.ALGORITHM_ID);
		algo = AlgorithmAccessor.getAllAlgos().get(algoID);
		eodStr = parameters.get(MT4Constants.EOD_DATE);
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
		
		if(trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_SELL || 
				trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_BUY){
			if(trade.isClosed()){
				if(this.eodFrom.before(trade.getCloseTime()) && this.eodTo.after(trade.getCloseTime())){
					balance += trade.getRealProfit();
					equity = balance;
	// TODO
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
		ret.put(MT4Constants.ALGORITHM_BALANCE, Double.toString(balance));
		ret.put(MT4Constants.ALGORITHM_EQUITY, Double.toString(equity));
		ret.put(MT4Constants.ALGORITHM_MARGIN, Double.toString(margin));
		return ret;
	}

}
