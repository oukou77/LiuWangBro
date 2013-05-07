package com.lwfund.fx.mt4.eod;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Algorithm;
import com.lwfund.fx.mt4.MT4AllocationStatus;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.calculators.AlgoAllocationStatusCalculator;
import com.lwfund.fx.mt4.dblayer.AlgorithmAccessor;
import com.lwfund.fx.mt4.dblayer.AllocationStatusAccessor;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;

public class AlgoAllocationStatusCumulator {

	public static void main(String args[]) throws Exception {
		if (args.length < 1) {
			MT4Display
					.outToConsole("Usage: java AlgoAllocationStatusCumulator fromDate toDate");
			return;
		}

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		
		Date fromDate = sdf.parse(args[0]);
		Date toDate = sdf.parse(args[1]);

		if (toDate.before(fromDate)) {
			MT4Display.outToConsole("toDate is before fromDate");
			return;
		}

		Mongo mongoInstance = null;
		DB mongoFXDB = null;

		mongoInstance = new Mongo(MT4Constants.TEMP_DB_SERVER_ADDRESS,
				MT4Constants.TEMP_DB_SERVER_PORT);

		mongoFXDB = mongoInstance.getDB(MT4Constants.MONGODB_FX_DB_NAME);

		DBCollection closedTradesColl = mongoFXDB
				.getCollection(MT4Constants.MONGODB_FX_DB_CLOSED_TRADE_ARCHIVE_COLLECTION);
		closedTradesColl.setObjectClass(MT4Trade.class);
		DBCollection openTradesColl = mongoFXDB
				.getCollection(MT4Constants.MONGODB_FX_DB_OPEN_TRADE_ARCHIVE_COLLECTION);
		openTradesColl.setObjectClass(MT4Trade.class);
		DBCollection allocationStatusColl = mongoFXDB
				.getCollection(MT4Constants.MONGODB_FX_DB_ALLOCATION_STATUS_COLLECTION);
		allocationStatusColl.setObjectClass(MT4AllocationStatus.class);
		
		List<MT4Trade> trades = new ArrayList<MT4Trade>();
		BasicDBObject query = new BasicDBObject();

		query.put(MT4Constants.TRADE_CLOSE_TIME_IN_MONGO, new BasicDBObject(
				"$gte", fromDate));
		query.put(MT4Constants.TRADE_CLOSE_TIME_IN_MONGO, new BasicDBObject(
				"$lte", toDate));
		DBCursor currentCursor = closedTradesColl.find(query).sort(
				new BasicDBObject(MT4Constants.TRADE_CLOSE_TIME_IN_MONGO, 1));
		try {
			while (currentCursor.hasNext()) {
				MT4Trade currentClosedTrade = (MT4Trade)currentCursor.next();
				currentClosedTrade.setClosed(true);
				trades.add(currentClosedTrade);
			}
		} finally {
			currentCursor.close();
		}
		
		currentCursor = openTradesColl.find(query).sort(
				new BasicDBObject(MT4Constants.TRADE_CLOSE_TIME_IN_MONGO, 1));
		try {
			while (currentCursor.hasNext()) {
				MT4Trade currentOpenTrade = (MT4Trade)currentCursor.next();
				currentOpenTrade.setClosed(false);
				trades.add(currentOpenTrade);
			}
		} finally {
			currentCursor.close();
		}
		
		Map<String, MT4Algorithm> allAlgos = AlgorithmAccessor.getAllAlgos();
		
		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(fromDate);
		Date currentDate = fromDate;
		AlgoAllocationStatusCalculator aasc = new AlgoAllocationStatusCalculator();
		AllocationStatusAccessor asa = new AllocationStatusAccessor();
		
		List<MT4AllocationStatus> allocations = null;
		List<DBObject> algoAllocations = new ArrayList<DBObject>();
		
		//Monday needs to adjust to Sat's EOD
		if(2 == cal.get(Calendar.DAY_OF_WEEK)){
			cal.add(Calendar.DAY_OF_MONTH, -2);
		}else{
			cal.add(Calendar.DAY_OF_MONTH, -1);
		}
		Date priorDate = cal.getTime();
		System.out.println("priordate " + priorDate);
		cal.setTime(fromDate);
		System.out.println(cal);
		
		
		while (toDate.after(currentDate)) {
			for (Iterator<String> iterator = allAlgos.keySet().iterator(); iterator.hasNext();) {
				MT4Algorithm currentAlgo = allAlgos.get(iterator.next());
				allocations = asa.getAlgoAllocationStatusByAlgoIDAndDate(currentAlgo.getAlgoID(), priorDate);

				double balance = 0;
				double equity = 0;
				double margin = 0;
				double freeMargin = 0 ;

				if(allocations != null && allocations.size() >0 ){
					balance = allocations.get(0).getBalance();
					equity = allocations.get(0).getEquity();
					margin = allocations.get(0).getMargin();
					freeMargin = allocations.get(0).getFreeMargin();
				}
				
				if(balance == 0 && equity == 0){
					balance = currentAlgo.getAllocation();
					equity = balance;
					margin = balance;
					freeMargin = balance;
				}
				
				Map<String, String> parameters = new HashMap<String, String>();
				parameters.put(MT4Constants.ALGORITHM_ID, currentAlgo.getAlgoID());	
				parameters.put(MT4Constants.EOD_DATE, sdf.format(currentDate));
				parameters.put(MT4Constants.ALGORITHM_BALANCE, Double.toString(balance));
				parameters.put(MT4Constants.ALGORITHM_EQUITY, Double.toString(equity));
				parameters.put(MT4Constants.ALGORITHM_FREE_MARGIN, Double.toString(freeMargin));
				parameters.put(MT4Constants.ALGORITHM_MARGIN, Double.toString(margin));
				
				aasc.init(parameters); 
				for (MT4Trade currentTrade : trades) {
					aasc.process(currentTrade);
				}
				
				Map<String, String> calculationResult = aasc.calculate();
				if(calculationResult != null && !calculationResult.isEmpty()){
					MT4AllocationStatus algoAllocation = new MT4AllocationStatus();
					balance = Double.parseDouble(calculationResult.get(MT4Constants.ALGORITHM_BALANCE));
					equity = Double.parseDouble(calculationResult.get(MT4Constants.ALGORITHM_EQUITY));
					margin = Double.parseDouble(calculationResult.get(MT4Constants.ALGORITHM_MARGIN));
					
					algoAllocation.setAccountID(MT4Constants.ALLOCATION_NON_ACCOUNT_FLAG);
					algoAllocation.setAlgoID(currentAlgo.getAlgoID());
					algoAllocation.setBalance(balance);
					algoAllocation.setEodDate(currentDate);
					algoAllocation.setEquity(equity);
					algoAllocation.setFreeMargin(freeMargin);
					algoAllocation.setMargin(margin);
					algoAllocation.setProfit(balance-currentAlgo.getAllocation());
					
					asa.persistent(algoAllocation);
					algoAllocations.add(algoAllocation);
				}
			}
			priorDate = currentDate;
			cal.add(Calendar.DAY_OF_MONTH, 1);
			currentDate = cal.getTime();
		}
		
		if(algoAllocations.size() > 0){
			System.out.println(algoAllocations.size());
//			asa.persistent(algoAllocations);
		}
	}
}
