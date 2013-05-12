package com.lwfund.fx.mt4.eod;

import java.text.SimpleDateFormat;
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
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.calculators.GrossPerformanceCalculator;
import com.lwfund.fx.mt4.dblayer.AlgorithmAccessor;
import com.lwfund.fx.mt4.dblayer.AllocationStatusAccessor;
import com.lwfund.fx.mt4.dblayer.BrokerAccountInfoAccessor;
import com.lwfund.fx.mt4.dblayer.GrossPerformanceAccessor;
import com.lwfund.fx.mt4.dblayer.TradeAccessor;
import com.lwfund.fx.mt4.util.MT4Display;
import com.lwfund.fx.mt4.util.MT4EODUtil;
import com.mongodb.DB;
import com.mongodb.Mongo;

public class GrossPerformanceProcessor {
	private static final SimpleDateFormat sdf = new SimpleDateFormat(
			"yyyy_MM_dd");
	private GrossPerformanceAccessor gpa;
	private GrossPerformanceCalculator gpc;
	private TradeAccessor ta;
	private Mongo mongoInstance;
	private DB mongoFXDB;

	public GrossPerformanceProcessor() {
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		gpa = new GrossPerformanceAccessor();
		gpc = new GrossPerformanceCalculator();
		ta = new TradeAccessor();
	}

	private void processOverallForDate(Date eodDate) throws Exception {

		// Do nothing for Sunday
		Calendar cal = Calendar.getInstance();
		cal.setTime(eodDate);
		if (Calendar.SUNDAY == cal.get(Calendar.DAY_OF_WEEK)) {
			return;
		}

		Map<String, String> initParameters = new HashMap<String, String>();
		Map<String, String> resultSet = null;
		
		List<MT4Account> accountList = BrokerAccountInfoAccessor
				.getAccoutInfoList();
		List<MT4AllocationStatus> allocationList = null;
		List<MT4Trade> tradeList = null;
		
		// first process 30days
		Map<String, Date> dateRange = MT4EODUtil.getEODDateForPriorDays(
				eodDate, 30);
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
		
		initParameters.put(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT, Double.toString(balance));
		gpc.init(initParameters);
		
		for (MT4Trade mt4Trade : tradeList) {
			gpc.process(mt4Trade);
		}
		
		resultSet = gpc.calculate();
		gpc.deinit();
		
		
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
}
