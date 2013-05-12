package com.lwfund.fx.mt4.calculators;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;

public class AlgoStatisticsCalculator implements MT4TradeCalculator {
	private DescriptiveStatistics profitStats = null;
	private DescriptiveStatistics returnRateStats = null;
	private int rptPeriodType;
	private double initBalance = 0;
	private Date eodDate;
	private static final DateFormat sdf = new SimpleDateFormat(
			MT4Constants.DEFAULT_DATE_FORMAT);
	
	public void init(Map<String,String> parameters){
		// do nothing
		rptPeriodType = Integer.parseInt(parameters.get(MT4Constants.PERFORMANCE_RPT_TYPE));
		initBalance = Double.parseDouble(parameters.get(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT));
		
		try{
			eodDate = sdf.parse(parameters.get(MT4Constants.EOD_DATE));
		}catch(Exception e){
			e.printStackTrace();
			eodDate = null;
		}
		//Sharpe ratio
		//AHPR
		//HPR
		//Z score
	}
	
	public void deinit(){
		eodDate = null;
		rptPeriodType = -1;
		profitStats = null;
		returnRateStats = null;
		initBalance = 0;
	}
	
	@Override
	public void process(MT4Trade trade) {
		if(profitStats == null){
			profitStats = new DescriptiveStatistics();
		}
		if(returnRateStats == null){
			returnRateStats = new DescriptiveStatistics();
		}
		profitStats.addValue(trade.getRealProfit());
	}

	@Override
	public Map<String, String> calculate() {
		Map<String,String> ret = new HashMap<String,String>();
		ret.put(MT4Constants.PERFORMANCE_RPT_PROFIT_EXPECTATION, Double.toString(profitStats.getMean()));
		ret.put(MT4Constants.PERFORMANCE_RPT_PROFIT_STANDARD_DEVIATION, Double.toString(profitStats.getStandardDeviation()));
		return ret;
	}

}
