package com.lwfund.fx.mt4.eod;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;


import com.lwfund.fx.mt4.MT4Account;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.dblayer.AllocationStatusSaver;
import com.lwfund.fx.mt4.dblayer.BrokerAccountInfoAccessor;
import com.lwfund.fx.mt4.dblayer.TradeArchiveSaver;
import com.lwfund.fx.mt4.util.MT4Display;

public class DailyMT4EODProcessor {

	public static void main(String args[]) throws Exception{
		if(args.length != 1){
			MT4Display.outToConsole("Usage: main class + EOD_files_folder");
			return;
		}
		
		if('\\' != args[0].charAt(args[0].length()-1)){
			args[0] += "\\";
		}
		System.out.println(args[0]);
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone(MT4Constants.TIMEZONE_TOKYO));
		
		System.out.println(cal.getTime());
		
		//Monday needs to adjust to Sat's EOD
//		if(2 == cal.get(Calendar.DAY_OF_WEEK)){
//			cal.add(Calendar.DAY_OF_MONTH, -2);
//		}else{
//			cal.add(Calendar.DAY_OF_MONTH, -1);
//		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
		String cutoffDateStr = sdf.format(cal.getTime());
		
		BrokerAccountInfoAccessor baia = new BrokerAccountInfoAccessor();
		List<MT4Account> accountList = baia.getAccoutInfoList();
		AllocationStatusSaver ass = new AllocationStatusSaver();
		TradeArchiveSaver tas = new TradeArchiveSaver();
		
		for (MT4Account mt4Account : accountList) {
			String accountAllocationStatusFileName = 
					MT4Constants.EOD_INPUT_FILE_ACCOUNT_INFO.replaceAll("#", mt4Account.getAccountID());
			accountAllocationStatusFileName = 
					accountAllocationStatusFileName.replaceAll("@", cutoffDateStr);
			accountAllocationStatusFileName = args[0] + accountAllocationStatusFileName;
			ass.parseAccountAllocationStatus(accountAllocationStatusFileName);
			ass.persitent();
			String tradeArchiveFileName = 
					MT4Constants.EOD_INPUT_FILE_TRADE_ARCHIVE.replaceAll("#", mt4Account.getAccountID());
			tradeArchiveFileName = tradeArchiveFileName.replaceAll("@", cutoffDateStr);
			tradeArchiveFileName = args[0] + tradeArchiveFileName;
			tas.parseTrades(tradeArchiveFileName);
			tas.persitent();
		}
	}
	
}
