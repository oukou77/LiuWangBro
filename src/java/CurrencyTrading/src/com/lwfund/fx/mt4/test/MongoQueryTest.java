package com.lwfund.fx.mt4.test;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Constants;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;

public class MongoQueryTest {
	public static void main(String args[]) throws Exception{
		
		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.set(Calendar.DAY_OF_YEAR, 1);
		System.out.println(cal.getTime());
		
		
		Mongo mongoInstance = null;
		DB mongoFXDB = null;
		
		mongoInstance = new Mongo(
				MT4Constants.TEMP_DB_SERVER_ADDRESS,
				MT4Constants.TEMP_DB_SERVER_PORT);
		
		mongoFXDB = mongoInstance
		.getDB(MT4Constants.MONGODB_FX_DB_NAME);
		
		DBCollection coll = mongoFXDB
		.getCollection(MT4Constants.MONGODB_FX_DB_CLOSED_TRADE_ARCHIVE_COLLECTION);
		
		DBObject dbo = coll.findOne();
		System.out.println(dbo);
		Date test = (Date)dbo.get("CloseTime");
		System.out.println(test);

		List<Integer> orderTypeList = new ArrayList<Integer>();
		orderTypeList.add(new Integer(MT4Constants.TRADE_ORDER_TYPE_BUY));
		orderTypeList.add(new Integer(MT4Constants.TRADE_ORDER_TYPE_SELL));
		
		//BasicDBObject query = new BasicDBObject("OrderType", new BasicDBObject("$in", orderTypeList));
		
		BasicDBObject query = new BasicDBObject();

		String fromDateStr = "2012_12_27";
		String toDateStr = "2013_04_26";
		
		SimpleDateFormat sdf = new SimpleDateFormat(
				"yyyy_MM_dd");
		
		Date fromDate = sdf.parse(fromDateStr);
		Date toDate = sdf.parse(toDateStr);
		query.put(MT4Constants.TRADE_CLOSE_TIME_IN_MONGO, new BasicDBObject(
				"$gte", fromDate).append("$lte", toDate));
		
		System.out.println(query);
		
		DBCursor cursor = coll.find(query);
		
		System.out.println(cursor.size());
		
		try {
			   while(cursor.hasNext()) {
				   DBObject currentDBO = cursor.next();
				   System.out.println(currentDBO.get("CloseTime"));
			   }
			} finally {
			   cursor.close();
			}
	}
}
