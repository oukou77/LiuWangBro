package com.lwfund.fx.mt4.eod;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Account;
import com.lwfund.fx.mt4.MT4Algorithm;
import com.lwfund.fx.mt4.MT4AllocationStatus;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4GrossPerformance;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.calculators.AlgoStatisticsCalculator;
import com.lwfund.fx.mt4.calculators.DrawdownCalculator;
import com.lwfund.fx.mt4.calculators.GrossPerformanceCalculator;
import com.lwfund.fx.mt4.dblayer.AlgorithmAccessor;
import com.lwfund.fx.mt4.dblayer.AllocationStatusAccessor;
import com.lwfund.fx.mt4.dblayer.BrokerAccountInfoAccessor;
import com.lwfund.fx.mt4.dblayer.GrossPerformanceAccessor;
import com.lwfund.fx.mt4.dblayer.TradeAccessor;
import com.lwfund.fx.mt4.util.MT4Display;
import com.lwfund.fx.mt4.util.MT4EODUtil;
import com.mongodb.DB;
import com.mongodb.DBObject;
import com.mongodb.Mongo;

public class GrossPerformanceProcessor {
	private static final SimpleDateFormat sdf = new SimpleDateFormat(
			"yyyy_MM_dd");
	private GrossPerformanceAccessor gpa;
	private TradeAccessor ta;
	private Mongo mongoInstance;
	private DB mongoFXDB;
	private GrossPerformanceCalculator gpc = new GrossPerformanceCalculator();
	private DrawdownCalculator dc = new DrawdownCalculator();
	private AlgoStatisticsCalculator asc = new AlgoStatisticsCalculator();
	
	public GrossPerformanceProcessor() {
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		gpa = new GrossPerformanceAccessor();
		ta = new TradeAccessor();
	}

	private void processPortfolioForDate(Date eodDate) throws Exception {

		// Do nothing for Sunday
		Calendar cal = Calendar.getInstance();
		cal.setTime(eodDate);
		if (Calendar.SUNDAY == cal.get(Calendar.DAY_OF_WEEK)) {
			return;
		}
	
		List<MT4Account> accountList = BrokerAccountInfoAccessor
				.getAccoutInfoList();
		List<MT4AllocationStatus> allocationList = null;
		List<MT4Trade> tradeList = null;
		
		// first process 7days
		Map<String, Date> dateRange = MT4EODUtil.getEODDateForPriorDays(
				eodDate, 7);
		Date fromDate = dateRange.get(MT4Constants.EOD_FROM_DATE);
		Date toDate = dateRange.get(MT4Constants.EOD_TO_DATE);

		tradeList = ta.getLongShortTradesByDateRange(fromDate,
				toDate, true);
		AllocationStatusAccessor asa = new AllocationStatusAccessor();
		double balance = 0;
		for (MT4Account mt4Account : accountList) {
			allocationList = asa.getAccountAllocationStatusByAccountAndDate(
					mt4Account.getAccountID(), eodDate);
			balance += allocationList.get(0).getBalance();
		}
		
		Map<String, String> gpParameters = new HashMap<String, String>();
		gpParameters.put(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT, Double.toString(balance));
		gpc.init(gpParameters);
		dc.init(gpParameters);
		
		Map<String, String> ascParameters = new HashMap<String, String>();
		ascParameters.put(MT4Constants.PERFORMANCE_RPT_TYPE, Integer.toString(MT4Constants.REPORT_PERIOD_7DAYS));
		ascParameters.put(MT4Constants.ALGORITHM_ID, MT4Constants.ALLOCATION_NON_ALGO_FLAG);
		ascParameters.put(MT4Constants.ACCOUNT_ID, MT4Constants.ALLOCATION_NON_ALGO_FLAG);
		ascParameters.put(MT4Constants.PERFORMANCE_RPT_PORTFOLIO_ID, "1");
		ascParameters.put(MT4Constants.EOD_DATE, sdf.format(eodDate));
		asc.init(ascParameters);
		
		for (MT4Trade mt4Trade : tradeList) {
			gpc.process(mt4Trade);
			dc.process(mt4Trade);
			asc.process(mt4Trade);
		}
		
		Map<String, String> gpMap = gpc.calculate();
		Map<String, String> dcMap = dc.calculate();
		Map<String, String> ascMap = asc.calculate();
		
		gpc.deinit();
		dc.deinit();
		asc.deinit();
		
		Map<String, Map<String, String>> totalResult = new HashMap<String, Map<String,String>>();
		totalResult.put(MT4Constants.RESULTS_GROSS_PERFORMANCE, gpMap);
		totalResult.put(MT4Constants.RESULTS_DRAWDOWN, dcMap);
		totalResult.put(MT4Constants.RESULTS_RATIOS, ascMap);
		
		MT4GrossPerformance result = GrossPerformanceAccessor.buildGrossPerformanceFromMap(totalResult);
		result.setPortfolioID("1");
		result.setAlgoID(MT4Constants.ALLOCATION_NON_ALGO_FLAG);
		result.setAccountID(MT4Constants.ALLOCATION_NON_ALGO_FLAG);
		result.setEodDate(eodDate);
		result.setPeriodType(MT4Constants.REPORT_PERIOD_7DAYS);
		
		List<DBObject> dboList = new ArrayList<DBObject>();
		dboList.add(result);
		
		gpa.peristent(dboList);
	}

	public void processForDateRange(String fromDateStr, String toDateStr,
			boolean isForceFlag) throws Exception {
		// clean up the dates
		Date fromDate = sdf.parse(fromDateStr);
		Date toDate = sdf.parse(toDateStr);

		Map<String, MT4Algorithm> allAlgos = AlgorithmAccessor.getAllAlgos();

		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(fromDate);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);

		Date cleanFromDate = cal.getTime();

		cal.setTime(toDate);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);

		Date cleanToDate = cal.getTime();
		
		Date currentDate = cleanFromDate;
		cal.setTime(currentDate);
		
		while(currentDate.before(cleanToDate) || currentDate.equals(cleanToDate)){
			this.processPortfolioForDate(currentDate);
			cal.add(Calendar.DAY_OF_MONTH, 1);
			currentDate = cal.getTime();
		}
	}

	public void processForHoldingPeriod(String startDateStr, String toDateStr)
			throws Exception {
		Date fromDate = sdf.parse(startDateStr);
		Date toDate = sdf.parse(toDateStr);

		if (toDate.before(fromDate)) {
			MT4Display.outToConsole("toDate is before fromDate");
			return;
		}

		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(fromDate);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);

		Date cleanStartDate = cal.getTime();

		cal.setTime(toDate);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);

		Date cleanToDate = cal.getTime();

		// clean up(remove) the target data first
		gpa.removeGrossPerformanceForDateRange(cleanStartDate, cleanToDate);

		this.processForDateRange(startDateStr, toDateStr, true);
	}
	
	public static void main(String args[]) throws Exception{
		String from = "2012_06_27";
		String to = "2013_04_25";
		
		GrossPerformanceProcessor gpp = new GrossPerformanceProcessor();
		gpp.processForHoldingPeriod(from, to);
	}
}
