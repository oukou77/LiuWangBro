package com.lwfund.fx.mt4.test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.calculators.AlgoStatisticsCalculator;
import com.lwfund.fx.mt4.calculators.DrawdownCalculator;
import com.lwfund.fx.mt4.calculators.GrossPerformanceCalculator;
import com.lwfund.fx.mt4.calculators.MT4TradeCalculator;
import com.lwfund.fx.mt4.eod.AllClosedTradesArchive;
import com.lwfund.fx.mt4.util.MT4Display;
import com.lwfund.fx.mt4.util.MT4HtmlRptToTradesTransformer;
import com.mongodb.DBObject;

public class MT4CalculatorTest {

	private MT4CalculatorTest(){};
	
	public static void main(String args[])throws Exception{
		
		String filename = "C:\\test\\trade4.csv";
		AllClosedTradesArchive ata = new AllClosedTradesArchive();
		List<DBObject> trades = ata.retrieveTradesToBuffer(filename);
//		DrawdownCalculator c1 = new DrawdownCalculator();
		AlgoStatisticsCalculator c1 = new AlgoStatisticsCalculator();
		Map<String, String>initParameters = new HashMap<String, String>();
		initParameters.put(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT, "1000000");
		c1.init(initParameters);
		
		for (DBObject dbObject : trades) {
			c1.process((MT4Trade)dbObject);
		}
		Map<String, String> ret = c1.calculate();
		
		for (String key : ret.keySet()) {
			MT4Display.outToConsole(key + ":" +ret.get(key));
		}
		
//		String filename = "C:\\test\\trade2.csv";
//		MT4HtmlRptToTradesTransformer transformer = new MT4HtmlRptToTradesTransformer();
//		List<MT4Trade> trades = transformer.pairUpTrades(filename);
////		MT4TradeCalculator c1 = new GrossPerformanceCalculator();
////		DrawdownCalculator c1 = new DrawdownCalculator();
//		DescriptiveStatisticsCalculator c1 = new DescriptiveStatisticsCalculator();
//		Map<String, String>initParameters = new HashMap<String, String>();
//		initParameters.put(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT, "10000");
//		c1.init(initParameters);
//		for (MT4Trade mt4Trade : trades) {
//			c1.process(mt4Trade);
//		}
//		
//		Map<String, String> ret = c1.calculate();
//		
//		for (String key : ret.keySet()) {
//			MT4Display.outToConsole(key + ":" +ret.get(key));
//		}
	}	
}
