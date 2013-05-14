package com.lwfund.fx.mt4.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Constants;

public class MT4EODUtil {

	private MT4EODUtil() {
	};

	public static List<Date> getLatestYearDatesByInteval(int periodType, Date eodDate) {

		List<Date> targetDates = new ArrayList<Date>();

		Calendar cal = Calendar.getInstance(TimeZone
				.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(eodDate);

		if (Calendar.SUNDAY == cal.get(Calendar.DAY_OF_WEEK)) {
			return targetDates;
		}
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);

		Date currentDate = cal.getTime();

		cal.add(Calendar.YEAR, -1);
		// if its Sunday we use Sat
		if (Calendar.SUNDAY == cal.get(Calendar.DAY_OF_WEEK)) {
			cal.add(Calendar.DAY_OF_MONTH, -1);
		}
		Date startDate = cal.getTime();

		int inteval = -367;

		switch (periodType) {
		case MT4Constants.REPORT_PERIOD_7DAYS:
			inteval = 7;
			break;
		case MT4Constants.REPORT_PERIOD_30DAYS:
			inteval = 30;
			break;
		case MT4Constants.REPORT_PERIOD_300DAYS:
			inteval = 300;
			break;
		case MT4Constants.REPORT_PERIOD_YTD:
			inteval = 7;
			break;
		default:
			break;
		}

		while (currentDate.after(startDate) || currentDate.equals(startDate)) {
			cal.setTime(currentDate);
			if (Calendar.SUNDAY == cal.get(Calendar.DAY_OF_WEEK)) {
				cal.add(Calendar.DAY_OF_MONTH, -1);
			}
			targetDates.add(cal.getTime());
			cal.add(Calendar.DAY_OF_MONTH, -inteval);
			currentDate = cal.getTime();
		}

		return targetDates;
	}

	public static Map<String, Date> getEODDateForPriorDays(Date aDate, int days) {
		Map<String, Date> ret = new HashMap<String, Date>();

		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(aDate);
		cal.set(Calendar.HOUR_OF_DAY, 4);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		ret.put(MT4Constants.EOD_TO_DATE, cal.getTime());

		cal.add(Calendar.DAY_OF_MONTH, -Math.abs(days));
		if (Calendar.SUNDAY == cal.get(Calendar.DAY_OF_WEEK)) {
			cal.add(Calendar.DAY_OF_MONTH, -1);
		}
		ret.put(MT4Constants.EOD_FROM_DATE, cal.getTime());

		// cal.setTime(aDate);
		// cal.set(Calendar.DAY_OF_YEAR, 1);

		return ret;
	}

	public static Map<String, Date> getEODDateRange(Date aDate) {
		Map<String, Date> ret = new HashMap<String, Date>();
		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(aDate);
		cal.set(Calendar.HOUR_OF_DAY, 4);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		ret.put(MT4Constants.EOD_FROM_DATE, cal.getTime());

		cal.add(Calendar.DAY_OF_MONTH, 1);
		ret.put(MT4Constants.EOD_TO_DATE, cal.getTime());

		return ret;
	}

	public static Map<String, Date> getEODDateRange(String aDateStr)
			throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		Date aDate = sdf.parse(aDateStr);
		return MT4EODUtil.getEODDateRange(aDate);
	}

	public static void main(String args[]) throws Exception {
		MT4EODUtil.getEODDateRange(new Date());
	}
}
