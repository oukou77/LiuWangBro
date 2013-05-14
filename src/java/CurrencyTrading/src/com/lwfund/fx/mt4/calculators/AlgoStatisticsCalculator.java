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
import com.lwfund.fx.mt4.MT4GrossPerformance;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.dblayer.GrossPerformanceAccessor;
import com.lwfund.fx.mt4.dblayer.ReferencedRatesAccessor;
import com.lwfund.fx.mt4.util.ZCalculator;

public class AlgoStatisticsCalculator implements MT4TradeCalculator {
	private DescriptiveStatistics profitStats = null;
	private DescriptiveStatistics returnRateStats = null;
	private GrossPerformanceAccessor gpa = null;
	private int rptPeriodType;
	private Date eodDate;
	private String algoID;
	private String accountID;
	private String portfolioID;
	private static final DateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
	private List<MT4GrossPerformance> gpList;
	private double balance = 0;
	private double profit = 0;
	private List<Double> profitList = null;
	private ReferencedRatesAccessor rra = new ReferencedRatesAccessor();

	public void init(Map<String, String> parameters) {
		// do nothing
		rptPeriodType = Integer.parseInt(parameters
				.get(MT4Constants.PERFORMANCE_RPT_TYPE));
		algoID = parameters.get(MT4Constants.ALGORITHM_ID);
		accountID = parameters.get(MT4Constants.ACCOUNT_ID);
		portfolioID = parameters.get(MT4Constants.PERFORMANCE_RPT_PORTFOLIO_ID);

		gpa = new GrossPerformanceAccessor();

		try {
			eodDate = sdf.parse(parameters.get(MT4Constants.EOD_DATE));
			gpList = gpa.getLatestPerformanceByPeriodTypeAndIDs(rptPeriodType,
					algoID, accountID, portfolioID, eodDate);
			if (gpList != null && gpList.size() > 0) {
				balance = gpList.get(0).getBalance();
			}
		} catch (Exception e) {
			e.printStackTrace();
			eodDate = null;
			gpList = null;
		}
	}

	public void deinit() {
		eodDate = null;
		rptPeriodType = -1;
		profitStats = null;
		returnRateStats = null;
		gpList = null;
		algoID = null;
		accountID = null;
		portfolioID = null;
		balance = 0;
		profit = 0;
		profitList = null;
	}

	@Override
	public void process(MT4Trade trade) {

		// if(returnRateStats == null){
		// returnRateStats = new DescriptiveStatistics();
		// }
		// profitStats.addValue(trade.getRealProfit());
		if (trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_BUY
				|| trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_SELL) {
			if (profitList == null)
				profitList = new ArrayList<Double>();
			profit += trade.getRealProfit();
			profitList.add(new Double(trade.getRealProfit()));
			
			if (profitStats == null) {
				profitStats = new DescriptiveStatistics();
			}
			profitStats.addValue(trade.getRealProfit());
		}
	}

	@Override
	public Map<String, String> calculate() {
		Map<String, String> ret = new HashMap<String, String>();

		if (gpList == null || gpList.size() == 0 ) {
			ret.put(MT4Constants.PERFORMANCE_SHARPE_RATIO, "0");
			ret.put(MT4Constants.PERFORMANCE_RPT_HPR, "0");
			ret.put(MT4Constants.PERFORMANCE_Z_SCORE, "0");
			ret.put(MT4Constants.PERFORMANCE_RPT_PROFIT_STANDARD_DEVIATION, "0");
			ret.put(MT4Constants.PERFORMANCE_HPR_VOLATILITY, "0");
			ret.put(MT4Constants.PERFORMANCE_RISK_FREE_RATE, "0");
		}else if(profitList == null || profitList.size() == 0){
			if (returnRateStats == null)
				returnRateStats = new DescriptiveStatistics();
			returnRateStats.addValue(1);
			for (MT4GrossPerformance currentGP : gpList) {
				if(currentGP.getHpr() != 0){
					returnRateStats.addValue(currentGP.getHpr());
				}
			}
			
			double riskFreeRate = 0;
			try {
				riskFreeRate = rra.getLatestRiskFreeRate().getRate();
			} catch (Exception e) {
				e.printStackTrace();
			}

			int denomFactor = 1;
			switch (rptPeriodType) {
			case MT4Constants.REPORT_PERIOD_7DAYS:
				denomFactor = 52;
				break;
			case MT4Constants.REPORT_PERIOD_30DAYS:
				denomFactor = 12;
				break;
			case MT4Constants.REPORT_PERIOD_300DAYS:
				denomFactor = 1;
				break;
			case MT4Constants.REPORT_PERIOD_YTD:
				denomFactor = 52;
				break;
			default:
				break;
			}

			double sharpeRatio = (returnRateStats.getMean() - (1 + riskFreeRate
					/ denomFactor))
					/ returnRateStats.getStandardDeviation();
			
			ret.put(MT4Constants.PERFORMANCE_SHARPE_RATIO, Double.toString(sharpeRatio));
			ret.put(MT4Constants.PERFORMANCE_RPT_HPR, "1");
			ret.put(MT4Constants.PERFORMANCE_Z_SCORE, "0");
			ret.put(MT4Constants.PERFORMANCE_RPT_PROFIT_STANDARD_DEVIATION, "0");
			ret.put(MT4Constants.PERFORMANCE_HPR_VOLATILITY, Double.toString(returnRateStats.getStandardDeviation()));
			ret.put(MT4Constants.PERFORMANCE_RISK_FREE_RATE, Double.toString(riskFreeRate));		
			
		}else {
			double[] profits = new double[profitList.size()];
			for (int i = 0; i < profitList.size(); i++) {
				profits[i] = profitList.get(i);
			}
			ZCalculator zc = new ZCalculator();
			double zScore = zc.calculate(profits);

			double currentHPR = (balance + profit) / balance;
			if (returnRateStats == null)
				returnRateStats = new DescriptiveStatistics();
			returnRateStats.addValue(currentHPR);
			for (MT4GrossPerformance currentGP : gpList) {
				if(currentGP.getHpr() != 0){
					returnRateStats.addValue(currentGP.getHpr());
				}
			}

			double riskFreeRate = 0;
			try {
				riskFreeRate = rra.getLatestRiskFreeRate().getRate();
			} catch (Exception e) {
				e.printStackTrace();
			}

			int denomFactor = 1;
			switch (rptPeriodType) {
			case MT4Constants.REPORT_PERIOD_7DAYS:
				denomFactor = 52;
				break;
			case MT4Constants.REPORT_PERIOD_30DAYS:
				denomFactor = 12;
				break;
			case MT4Constants.REPORT_PERIOD_300DAYS:
				denomFactor = 1;
				break;
			case MT4Constants.REPORT_PERIOD_YTD:
				denomFactor = 52;
				break;
			default:
				break;
			}

			double sharpeRatio = (returnRateStats.getMean() - (1 + riskFreeRate
					/ denomFactor))
					/ returnRateStats.getStandardDeviation();
//for (int i = 0; i < returnRateStats.getValues().length; i++) {
//	System.out.println(returnRateStats.getValues()[i]);
//}
////System.out.println(currentHPR);
//System.out.println(returnRateStats.getMean());
//System.out.println((1 + riskFreeRate
//					/ denomFactor));
//System.out.println(sharpeRatio);
//System.out.println(eodDate);
			ret.put(MT4Constants.PERFORMANCE_RPT_PROFIT_STANDARD_DEVIATION,
					Double.toString(profitStats.getStandardDeviation()));
			ret.put(MT4Constants.PERFORMANCE_Z_SCORE, Double.toString(zScore));
			ret.put(MT4Constants.PERFORMANCE_SHARPE_RATIO, Double.toString(sharpeRatio));
			ret.put(MT4Constants.PERFORMANCE_RPT_HPR, Double.toString(currentHPR));
			ret.put(MT4Constants.PERFORMANCE_RISK_FREE_RATE, Double.toString(riskFreeRate));
			ret.put(MT4Constants.PERFORMANCE_HPR_VOLATILITY, Double.toString(returnRateStats.getStandardDeviation()));
		}
		return ret;
	}

}
