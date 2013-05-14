package com.lwfund.fx.mt4.calculators;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.util.MT4Display;

public class DrawdownCalculator implements MT4TradeCalculator {
	private float initialDeposit = 0;
	private float balance = 0;
	private float absoluteDrawdown = 0;
	private float maximumDrawdown = 0;
	private float maximumDrawdownPercent = 0;
	private float drawdown;
	private float drawdownPercent = 0;
	private float relativeDrawdown = 0;
	private float relativeDrawdownPercent = 0;
	private float maximalPeak = 0;
	private float minimalPeak = 0;

	@Override
	public void init(Map<String, String> parameters) {
		if (parameters
				.containsKey(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT)) {
			initialDeposit = Float.parseFloat(parameters
					.get(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT));
			balance = initialDeposit;
			maximalPeak = initialDeposit;
			minimalPeak = initialDeposit;
			absoluteDrawdown = initialDeposit;
		}
	}

	public void deinit() {
		initialDeposit = 0;
		balance = 0;
		absoluteDrawdown = 0;
		maximumDrawdown = 0;
		maximumDrawdownPercent = 0;
		drawdown = 0;
		drawdownPercent = 0;
		relativeDrawdown = 0;
		relativeDrawdownPercent = 0;
		maximalPeak = 0;
		minimalPeak = 0;
	}

	@Override
	public void process(MT4Trade trade) {
		balance += trade.getRealProfit();

		if (balance < absoluteDrawdown) {
			absoluteDrawdown = balance;
		}

		if (minimalPeak > balance) {
			minimalPeak = balance;
			drawdown = maximalPeak - minimalPeak;
			drawdownPercent = drawdown / maximalPeak;
			if (maximumDrawdown < drawdown) {
				maximumDrawdown = drawdown;
			}
			if (maximumDrawdownPercent < drawdownPercent) {
				maximumDrawdownPercent = drawdownPercent;
			}
			if (maximumDrawdownPercent > relativeDrawdownPercent) {
				relativeDrawdownPercent = maximumDrawdownPercent;
				relativeDrawdown = maximumDrawdown;
			}
		}

		if (maximalPeak < balance) {
			maximalPeak = balance;
			minimalPeak = balance;
		}
	}

	@Override
	public Map<String, String> calculate() {
		Map<String, String> ret = new HashMap<String, String>();
		DecimalFormat dfDefault = new DecimalFormat("0.00");
		DecimalFormat dfPercent = new DecimalFormat("0.00");
		
		if(initialDeposit == 0){
			ret.put(MT4Constants.PERFORMANCE_RPT_ABSOLUTE_DRAWDOWN,
					dfDefault.format(0));
			ret.put(MT4Constants.PERFORMANCE_RPT_MAX_DRAWDOWN,
					dfDefault.format(0));
			ret.put(MT4Constants.PERFORMANCE_RPT_MAX_DRAWDOWN_PERCENT,
					dfPercent.format(0));
			ret.put(MT4Constants.PERFORMANCE_RPT_RELATIVE_DRAWDOWN,
					dfDefault.format(0));
			ret.put(MT4Constants.PERFORMANCE_RPT_RELATIVE_DRAWDOWN_PERCENT,
					dfPercent.format(0));
		}else{
			ret.put(MT4Constants.PERFORMANCE_RPT_ABSOLUTE_DRAWDOWN,
					dfDefault.format(Math.abs(initialDeposit - absoluteDrawdown)));
			ret.put(MT4Constants.PERFORMANCE_RPT_MAX_DRAWDOWN,
					dfDefault.format(maximumDrawdown));
			ret.put(MT4Constants.PERFORMANCE_RPT_MAX_DRAWDOWN_PERCENT,
					dfPercent.format(maximumDrawdownPercent));
			ret.put(MT4Constants.PERFORMANCE_RPT_RELATIVE_DRAWDOWN,
					dfDefault.format(relativeDrawdown));
			ret.put(MT4Constants.PERFORMANCE_RPT_RELATIVE_DRAWDOWN_PERCENT,
					dfPercent.format(relativeDrawdownPercent));
		}
		return ret;
	}

}
