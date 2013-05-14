package com.lwfund.fx.mt4.dblayer;

import java.net.UnknownHostException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4GrossPerformance;
import com.lwfund.fx.mt4.util.MT4Display;
import com.lwfund.fx.mt4.util.MT4EODUtil;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.WriteResult;

public class GrossPerformanceAccessor {
	private List<DBObject> grossPerformanceList;
	private static final DateFormat sdf = new SimpleDateFormat(
			MT4Constants.DEFAULT_DATE_FORMAT);
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;

	public static MT4GrossPerformance buildGrossPerformanceFromMap(
			Map<String, Map<String, String>> results) {

		if (results == null || results.isEmpty()) {
			return null;
		}

		Map<String, String> gpMap = results
				.get(MT4Constants.RESULTS_GROSS_PERFORMANCE);
		Map<String, String> ddMap = results.get(MT4Constants.RESULTS_DRAWDOWN);
		Map<String, String> ratioMap = results.get(MT4Constants.RESULTS_RATIOS);
		
		MT4GrossPerformance ret = new MT4GrossPerformance();

		// From gross performance calculator
		ret.setAvgConsecutiveLosses((int)Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_AVG_CONSECUTIVE_LOSSES)));
		ret.setAvgConsecutiveWins((int)Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_AVG_CONSECUTIVE_WINS)));
		ret.setAvgLossTrade(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_AVG_LOSS_TRADE)));
		ret.setAvgLots(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_AVG_LOT)));
		ret.setTotalPipsInJPY(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_TOTAL_PIPS)));
		ret.setAvgProfitPipsInJPY(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_PROFIT_PIPS)));
		ret.setAvgLossPipsInJPY(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_LOSS_PIPS)));
		ret.setAvgProfitTrade(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_AVG_PROFIT_TRADE)));
		ret.setDefaultValueAtRisk(0);
		ret.setExpectedPayOff(Double
				.parseDouble(gpMap.get(MT4Constants.PERFORMANCE_RPT_EXPECTED_PAYOFF)));
		ret.setLargestLossTrade(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_LARGEST_LOSS_TRADE)));
		ret.setLargestProfitTrade(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_LARGEST_PROFIT_TRADE)));
		ret.setLongPositionWon(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_LONG_POSITIONS)));
		ret.setLongPositionWonPercentage(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_LONG_POSITIONS_WON)));
		ret.setLossTrades(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_LOSS_TRADES)));
		ret.setLossTradesPercentage(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_LOSS_TRADES_PERCENTAGE)));
		ret.setMaxConsecutiveLoss(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSS)));
		ret.setMaxConsecutiveLosses(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSSES)));
		ret.setMaxConsecutiveLossesLoss(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSSES_MONEY)));
		ret.setMaxConsecutiveLossLosses(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSS_LOSSES)));
		ret.setMaxConsecutiveProfit(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_PROFIT)));
		ret.setMaxConsecutiveProfitWins(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_PROFIT_WINS)));
		ret.setMaxConsecutiveWins(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_WINS)));
		ret.setMaxConsecutiveWinsProfit(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_WINS_MONEY)));
		ret.setProfitFactor(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_PROFIT_FACTOR)));
		ret.setProfitTrades(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_PROFIT_TRADES)));
		ret.setProfitTradesPercentage(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_PROFIT_TRADES_PERCENTAGE)));
		ret.setShortPositionWon(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_SHORT_POSITIONS)));
		ret.setShortPositionWonPercentage(Double.parseDouble(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_SHORT_POSITIONS_WON)));
		ret.setTotalTrades(Integer.parseInt(gpMap
				.get(MT4Constants.PERFORMANCE_RPT_TOTAL_TRADES)));
		ret.setBalance(Double.parseDouble(gpMap.get(MT4Constants.PERFORMANCE_RPT_BALANCE)));
		
		// From draw down calculator results
		ret.setAbsoluteDrawdown(Double.parseDouble(ddMap
				.get(MT4Constants.PERFORMANCE_RPT_ABSOLUTE_DRAWDOWN)));
		ret.setMaximalDrawdown(Double.parseDouble(ddMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_DRAWDOWN)));
		ret.setMaximalDrawdownPercentage(Double.parseDouble(ddMap
				.get(MT4Constants.PERFORMANCE_RPT_MAX_DRAWDOWN_PERCENT)));
		ret.setRelativeDrawdown(Double.parseDouble(ddMap
				.get(MT4Constants.PERFORMANCE_RPT_RELATIVE_DRAWDOWN)));
		ret.setRelativeDrawdownPercentage(Double.parseDouble(ddMap
				.get(MT4Constants.PERFORMANCE_RPT_RELATIVE_DRAWDOWN_PERCENT)));

		// From stats calculator results
		ret.setProfitVolatility(Double.parseDouble(ratioMap.get(MT4Constants.PERFORMANCE_RPT_PROFIT_STANDARD_DEVIATION)));
		ret.setZScore(Double.parseDouble(ratioMap.get(MT4Constants.PERFORMANCE_Z_SCORE)));
		ret.setSharpeRatio(Double.parseDouble(ratioMap.get(MT4Constants.PERFORMANCE_SHARPE_RATIO)));
		ret.setHpr(Double.parseDouble(ratioMap.get(MT4Constants.PERFORMANCE_RPT_HPR)));
		ret.setRiskFreeRate(Double.parseDouble(ratioMap.get(MT4Constants.PERFORMANCE_RISK_FREE_RATE)));
		ret.setHprVolatility(Double.parseDouble(ratioMap.get(MT4Constants.PERFORMANCE_HPR_VOLATILITY)));

		return ret;
	}

	public GrossPerformanceAccessor() {
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
	}

	public List<MT4GrossPerformance> getLatestPerformanceByPeriodTypeAndIDs(
			int periodType, String algoID, String accountID, String portfolioID, Date eodDate)
			throws Exception {
		List<MT4GrossPerformance> ret = new ArrayList<MT4GrossPerformance>();

		List<Date> targetDates = MT4EODUtil.getLatestYearDatesByInteval(periodType, eodDate);
		if(targetDates == null || targetDates.size() == 0){
			return ret;
		}
		
		BasicDBObject query = new BasicDBObject();
		query.put(MT4Constants.GROSS_PERFORMANCE_ACCOUNTID_IN_MONGO, accountID);
		query.put(MT4Constants.GROSS_PERFORMANCE_ALGOID_IN_MONGO, algoID);
		query.put(MT4Constants.GROSS_PERFORMANCE_PORTFOLIOID_IN_MONGO, portfolioID);
		query.put(MT4Constants.GROSS_PERFORMANCE_PERIODTYPE_IN_MONGO, periodType);
		query.put(MT4Constants.GROSS_PERFORMANCE_EODDATE_IN_MONGO, new BasicDBObject("$in", targetDates));
		
		DBCursor cursor = null;
		
		try {
			if ((this.mongoInstance == null)
					|| (!this.mongoInstance.getConnector().isOpen())) {
				this.mongoInstance = new Mongo(
						MT4Constants.TEMP_DB_SERVER_ADDRESS,
						MT4Constants.TEMP_DB_SERVER_PORT);
			}

			if (this.mongoFXDB == null) {
				this.mongoFXDB = this.mongoInstance
						.getDB(MT4Constants.MONGODB_FX_DB_NAME);
			}

			DBCollection coll = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_GROSS_PERFORMANCE_COLLECTION);
			coll.setObjectClass(MT4GrossPerformance.class);
			
			cursor = coll.find(query).sort(new BasicDBObject(MT4Constants.GROSS_PERFORMANCE_EODDATE_IN_MONGO, -1));
			
			while(cursor.hasNext()){
				ret.add((MT4GrossPerformance)cursor.next());
			}

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
			throw ex;
		} catch (MongoException ex) {
			ex.printStackTrace();
			throw ex;
		} finally {
			// this.mongoInstance.close();
			// this.mongoInstance = null;
			if(cursor != null){
				cursor.close();
			}
		}		
		
		return ret;
	}

	public int peristent(List<DBObject> performances) throws Exception{
		int ret = 0;
		if (performances == null || performances.isEmpty()) {
			MT4Display.outToConsole("Performance list is empty");
			return ret;
		}

		try {
			if (this.mongoInstance == null) {
				this.mongoInstance = new Mongo(
						MT4Constants.TEMP_DB_SERVER_ADDRESS,
						MT4Constants.TEMP_DB_SERVER_PORT);
			}

			if (this.mongoFXDB == null) {
				this.mongoFXDB = this.mongoInstance
						.getDB(MT4Constants.MONGODB_FX_DB_NAME);
			}

			DBCollection performanceColl = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_GROSS_PERFORMANCE_COLLECTION);
			performanceColl.insert(performances);
			ret = performances.size();

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
			throw ex;
		} catch (MongoException ex) {
			ex.printStackTrace();
			throw ex;
		} finally {
			// this.mongoInstance.close();
		}
		MT4Display.outToConsole("insert is done. [" + ret + "] rows affected!");
		return ret;
	}
	
	public int removeGrossPerformanceForDateRange(Date fromDate, Date toDate)
			throws Exception {
		int ret = 0;

		BasicDBObject query = new BasicDBObject();

		query.put(MT4Constants.EOD_DATE_IN_MONGO, new BasicDBObject("$gte",
				fromDate).append("$lte", toDate));

		try {
			if ((this.mongoInstance == null)
					|| (!this.mongoInstance.getConnector().isOpen())) {
				this.mongoInstance = new Mongo(
						MT4Constants.TEMP_DB_SERVER_ADDRESS,
						MT4Constants.TEMP_DB_SERVER_PORT);
			}

			if (this.mongoFXDB == null) {
				this.mongoFXDB = this.mongoInstance
						.getDB(MT4Constants.MONGODB_FX_DB_NAME);
			}

			DBCollection coll = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_GROSS_PERFORMANCE_COLLECTION);
			WriteResult wr = coll.remove(query);
			ret = wr.getN();

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
			throw ex;
		} catch (MongoException ex) {
			ex.printStackTrace();
			throw ex;
		} finally {
			// this.mongoInstance.close();
			// this.mongoInstance = null;
		}
		MT4Display.outToConsole("remove is done. [" + ret + "] rows affected!");

		return ret;
	}
}
