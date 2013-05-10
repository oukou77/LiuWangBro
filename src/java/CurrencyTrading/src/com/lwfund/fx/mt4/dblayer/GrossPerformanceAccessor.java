package com.lwfund.fx.mt4.dblayer;

import java.net.UnknownHostException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
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
	
	public GrossPerformanceAccessor(){
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
	}
	
	public int removeGrossPerformanceForDateRange(Date fromDate, Date toDate) throws Exception{
		int ret = 0;
		
		BasicDBObject query = new BasicDBObject();

		query.put(MT4Constants.EOD_DATE_IN_MONGO, new BasicDBObject(
				"$gte", fromDate));
		query.put(MT4Constants.EOD_DATE_IN_MONGO, new BasicDBObject(
				"$lte", toDate));
		
		try {
			if ((this.mongoInstance == null) || (!this.mongoInstance.getConnector().isOpen())) {
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
		} finally{
//			this.mongoInstance.close();
//			this.mongoInstance = null;
		}
		MT4Display.outToConsole("remove is done. [" + ret + "] rows affected!");
		
		return ret;
	}
}
