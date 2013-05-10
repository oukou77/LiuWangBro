package com.lwfund.fx.mt4.eod;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Algorithm;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.dblayer.AlgorithmAccessor;
import com.lwfund.fx.mt4.dblayer.GrossPerformanceAccessor;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.DB;
import com.mongodb.Mongo;

public class GrossPerformanceProcessor {
	private static final SimpleDateFormat sdf = new SimpleDateFormat(
			"yyyy_MM_dd");
	private GrossPerformanceAccessor gpa;
	private Mongo mongoInstance;
	private DB mongoFXDB;
	
	public GrossPerformanceProcessor(){
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		gpa = new GrossPerformanceAccessor();
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
		Date currentDate = fromDate;

		// Monday needs to be adjusted to Sat's EOD
		if (2 == cal.get(Calendar.DAY_OF_WEEK)) {
			cal.add(Calendar.DAY_OF_MONTH, -2);
		} else {
			cal.add(Calendar.DAY_OF_MONTH, -1);
		}

		Date priorDate = cal.getTime();
		System.out.println("priordate " + priorDate);
		cal.setTime(fromDate);
		
		xx
	}
	
	public void processForHoldingPeriod(String startDateStr, String toDateStr)
			throws Exception{
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
