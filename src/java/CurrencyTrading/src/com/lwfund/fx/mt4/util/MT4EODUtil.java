package com.lwfund.fx.mt4.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Constants;

public class MT4EODUtil {

	private MT4EODUtil(){};
	
	public static Map<String, Date>getEODDateRange(Date aDate){
		Map<String, Date> ret = new HashMap<String, Date>();
		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(aDate);
		cal.set(Calendar.HOUR_OF_DAY, 4);
		cal.set(Calendar.MINUTE,0);
		cal.set(Calendar.SECOND,0);
		ret.put(MT4Constants.EOD_FROM_DATE, cal.getTime());
		
		cal.add(Calendar.DAY_OF_MONTH,1);
		ret.put(MT4Constants.EOD_TO_DATE, cal.getTime());
		
		return ret;
	}
	
	public static Map<String, Date>getEODDateRange(String aDateStr) throws ParseException{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		Date aDate = sdf.parse(aDateStr);
		return MT4EODUtil.getEODDateRange(aDate);
	}
	
	public static void main(String args[]) throws Exception{
		MT4EODUtil.getEODDateRange(new Date());
	}
}
