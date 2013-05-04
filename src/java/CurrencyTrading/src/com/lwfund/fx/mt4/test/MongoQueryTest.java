package com.lwfund.fx.mt4.test;

import java.util.Date;

import com.lwfund.fx.mt4.MT4Constants;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;

public class MongoQueryTest {
	public static void main(String args[]) throws Exception{
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
		BasicDBObject query = new BasicDBObject("_id", 18716923);
		DBCursor cursor = coll.find(query);
		try {
			   while(cursor.hasNext()) {
				   DBObject currentDBO = cursor.next();
				   Date currentCloseTime = (Date)currentDBO.get("CloseTime");
				   System.out.println(currentCloseTime);
			   }
			} finally {
			   cursor.close();
			}
	}
}
