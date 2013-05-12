package com.lwfund.fx.mt4.calculators;

import java.util.Map;

import com.lwfund.fx.mt4.MT4Trade;

public interface MT4TradeCalculator {
	public void init(Map<String,String> parameters);
	public void process(MT4Trade trade);
	public Map<String, String> calculate();
	public void deinit();
}
