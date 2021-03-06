package com.lwfund.fx.mt4.dblayer;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.UnknownHostException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

import com.lwfund.fx.mt4.MT4Account;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4MarketData;
import com.lwfund.fx.mt4.util.MT4Display;
import com.lwfund.fx.mt4.util.MT4EODUtil;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;

public class MarketDataAccessor {
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;
	private List<DBObject> marketDataList;
	
	public MT4MarketData getLatestCloseMarketDataBySymbol(String symbol) throws Exception{
		if(symbol == null || symbol.isEmpty()){
			return null;
		}
		
		Map<String, Date> eodDateMap = MT4EODUtil.getEODDateRange(new Date());
		
		Date eodDate = eodDateMap.get(MT4Constants.EOD_FROM_DATE);
		
		return this.getPriorClosestMarketData(symbol, eodDate, MT4Constants.CHART_PERIOD_TYPE_M1);
	}
	
	public MT4MarketData getPriorClosestMarketData(String symbol,
			Date exactDateTime, int barPeriodType) throws Exception {
		MT4MarketData ret = null;
		DBCursor cursor = null;

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

			DBCollection mktDataColl = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_MARKET_DATA_COLLECTION);
			mktDataColl.setObjectClass(MT4MarketData.class);

			BasicDBObject query = new BasicDBObject();
			query.put(MT4Constants.MARKET_DATA_BAR_PERIOD_TYPE, barPeriodType);
			query.put(MT4Constants.MARKET_DATA_SYMBOL, symbol);
			query.put(MT4Constants.MARKET_DATA_TIME, new BasicDBObject("$lte",
					exactDateTime));

			cursor = mktDataColl.find(query)
					.sort(new BasicDBObject(MT4Constants.MARKET_DATA_TIME, -1))
					.limit(1);

			if (cursor.hasNext()) {
				ret = (MT4MarketData) cursor.next();
			}

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
			throw ex;
		} catch (MongoException ex) {
			ex.printStackTrace();
			throw ex;
		} finally {
			// this.mongoInstance.close();
			if (cursor != null) {
				cursor.close();
			}
		}

		return ret;
	}

	public MT4MarketData getExactMarketDate(String symbol, Date exactDateTime,
			int barPeriodType) throws Exception {

		DBCursor cursor = null;
		MT4MarketData ret = null;

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

			DBCollection mktDataColl = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_MARKET_DATA_COLLECTION);
			mktDataColl.setObjectClass(MT4MarketData.class);

			BasicDBObject query = new BasicDBObject();
			query.put(MT4Constants.MARKET_DATA_BAR_PERIOD_TYPE, barPeriodType);
			query.put(MT4Constants.MARKET_DATA_SYMBOL, symbol);
			query.put(MT4Constants.MARKET_DATA_TIME, exactDateTime);

			cursor = mktDataColl.find(query);
			if (cursor.hasNext()) {
				ret = (MT4MarketData) cursor.next();
			}

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
			throw ex;
		} catch (MongoException ex) {
			ex.printStackTrace();
			throw ex;
		} finally {
			// this.mongoInstance.close();
			if (cursor != null) {
				cursor.close();
			}
		}
		return ret;
	}

	public int persistentMarketData(List<DBObject> mktDataList)
			throws Exception {
		int ret = 0;
		if (mktDataList == null || mktDataList.isEmpty()) {
			MT4Display.outToConsole("MarketData list is empty");
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

			DBCollection mktDataColl = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_MARKET_DATA_COLLECTION);
			mktDataColl.insert(mktDataList);
			ret = mktDataList.size();

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

	public int persistentMarketData() throws Exception {
		return persistentMarketData(marketDataList);

	}

	public void parseMarketData(String fileName, String symbol, int barType)
			throws Exception {

		List<MT4Account> accounts = BrokerAccountInfoAccessor
				.getAccoutInfoList();
		Map<String, MT4Account> accountsMap = new HashMap<String, MT4Account>();
		for (MT4Account mt4Account : accounts) {
			accountsMap.put(mt4Account.getAccountID(), mt4Account);
		}

		DateFormat parseSdf = new SimpleDateFormat(
				MT4Constants.DEFAULT_MARKET_DATA_TIME_FORMAT);
		parseSdf.setTimeZone(TimeZone.getTimeZone(accountsMap.get(
				MT4Constants.FIXED_MARKET_DATA_SOURCE_ACCT_ID).getTimeZone()));

		try {
			Iterable<CSVRecord> parser = CSVFormat.DEFAULT.toBuilder().parse(
					new FileReader(fileName));

			MT4Display.outToConsole("processing file[" + fileName + "]");
			this.marketDataList = new ArrayList<DBObject>();

			for (CSVRecord record : parser) {
				MT4MarketData mktData = new MT4MarketData();
				mktData.setSymbol(symbol);
				mktData.setAccountID(MT4Constants.FIXED_MARKET_DATA_SOURCE_ACCT_ID);
				String timeStr = record.get(0) + record.get(1);
				Date time = parseSdf.parse(timeStr);
				mktData.setTime(time);
				mktData.setOpen(Double.parseDouble(record.get(2)));
				mktData.setHigh(Double.parseDouble(record.get(3)));
				mktData.setLow(Double.parseDouble(record.get(4)));
				mktData.setClose(Double.parseDouble(record.get(5)));
				mktData.setVolume(Double.parseDouble(record.get(6)));
				mktData.setBarPeriodType(barType);

				this.marketDataList.add(mktData);
			}

		} catch (FileNotFoundException e) {
			MT4Display.outToConsole("Couldn't find file[" + fileName + "]");
			e.printStackTrace();
			throw e;
		} catch (IOException e) {
			MT4Display.outToConsole("Can't read file[" + fileName + "]");
			e.printStackTrace();
			throw e;
		}
	}

	public static void main(String args[]) throws Exception {
		MarketDataAccessor mda = new MarketDataAccessor();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
		Date exactDate = sdf.parse("2013.04.26 15:20");
		// MT4MarketData marketData = mda.getExactMarketDate("EURUSDpro",
		// exactDate, 1);
		MT4MarketData marketData = mda.getPriorClosestMarketData("EURUSDpro",
				exactDate, 1);
		System.out.println(marketData.getTime());
		System.out.println(marketData.getOpen());
		System.out.println(marketData.getClose());
	}
}
