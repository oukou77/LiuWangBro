package com.lwfund.fx.mt4.dblayer;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4ReferencedRate;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.WriteResult;

public class ReferencedRatesAccessor {

	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;

	public MT4ReferencedRate getLatestRiskFreeRate()
			throws Exception {
		MT4ReferencedRate ret = null;
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

			DBCollection coll = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_REFERENCED_RATES_COLLECTION);
			coll.setObjectClass(MT4ReferencedRate.class);

			BasicDBObject query = new BasicDBObject(MT4Constants.MARKET_DATA_TIME,-1);
			cursor = coll.find().sort(query).limit(1);
			while(cursor.hasNext()){
				ret = (MT4ReferencedRate)cursor.next();
			}

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
		} catch (MongoException ex) {
			ex.printStackTrace();
		} finally {
			if(cursor != null){
				cursor = null;
			}
		}
		return ret;
	}

	public void persistentRates(List<DBObject> rates) throws Exception {
		if (rates == null || rates.size() == 0) {
			MT4Display.outToConsole("empty rate list, stopping.....");
			return;
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

			DBCollection coll = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_REFERENCED_RATES_COLLECTION);
			WriteResult wr = coll.insert(rates);

			MT4Display.outToConsole("insert is done. [" + wr.getN()
					+ "] rows affected!");

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
		} catch (MongoException ex) {
			ex.printStackTrace();
		} finally {
			this.mongoInstance.close();
		}
	}

	public static void main(String args[]) throws Exception {
		MT4ReferencedRate rate = new MT4ReferencedRate();
		rate.setName("China bank deposit interest rate");
		rate.setPeriodInDays(MT4Constants.FIXED_DAYS_IN_YEAR);
		rate.setRate(0.0350);
		rate.setSource("Google Finance");
		rate.setTime(new Date());
		rate.setType("1yr");

		List<DBObject> rates = new ArrayList<DBObject>();
		rates.add(rate);

		ReferencedRatesAccessor rra = new ReferencedRatesAccessor();
		rra.persistentRates(rates);
	}
}
