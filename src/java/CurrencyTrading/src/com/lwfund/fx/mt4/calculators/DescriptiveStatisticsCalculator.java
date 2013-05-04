package com.lwfund.fx.mt4.calculators;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;

public class DescriptiveStatisticsCalculator implements MT4TradeCalculator {
	private List<MT4Trade> trades = null;
	private DescriptiveStatistics profitStats = null;
	
	public void init(Map<String,String> parameters){
		// do nothing
	}
	
	@Override
	public void process(MT4Trade trade) {
		if(trades == null){
			trades = new ArrayList<MT4Trade>();
		}
		if(profitStats == null){
			profitStats = new DescriptiveStatistics();
		}
		trades.add(trade);
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
