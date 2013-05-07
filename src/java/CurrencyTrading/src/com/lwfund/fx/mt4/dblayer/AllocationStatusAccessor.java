package com.lwfund.fx.mt4.dblayer;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.UnknownHostException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

import com.lwfund.fx.mt4.MT4AllocationStatus;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;

public class AllocationStatusAccessor {

	private List<DBObject> allocations;
	private static final DateFormat sdf = new SimpleDateFormat(
			MT4Constants.DEFAULT_DATE_FORMAT);
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;

	public AllocationStatusAccessor(){
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
	}
	
	List<DBObject> getAccountStatus() {
		// should clone
		// so not public function atm
		return allocations;
	}
	
	public List<MT4AllocationStatus> getAlgoAllocationStatusByAlgoIDAndDate(String algoID, Date eodDate) throws Exception{
		List<MT4AllocationStatus> ret = new ArrayList<MT4AllocationStatus>();
		
		if(algoID == null || algoID.length() == 0){
			MT4Display.outToConsole("algoID is empty!");
			return ret;
		}
	
		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(eodDate);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		
		Date cleanEodDate = cal.getTime();
		DBCursor cursor = null;
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
					.getCollection(MT4Constants.MONGODB_FX_DB_ALLOCATION_STATUS_COLLECTION);
			coll.setObjectClass(MT4AllocationStatus.class);
			
			BasicDBObject query = new BasicDBObject();
			query.put(MT4Constants.ALGORITHM_ID_IN_MONGO, algoID);
			query.put(MT4Constants.EOD_DATE_IN_MONGO, cleanEodDate);
			cursor = coll.find(query);
			while (cursor.hasNext()) {
				ret.add((MT4AllocationStatus)cursor.next());
			}

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
			throw ex;
		} catch (MongoException ex) {
			ex.printStackTrace();
			throw ex;
		} finally{
			if(cursor != null){
				cursor.close();
			}
			//How to close?
		}
		
		return ret;
	}
	
	public int persistent(List<DBObject> target) throws Exception{
		int ret = 0;

		if (target == null || target.size() == 0)
			return ret;

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
					.getCollection(MT4Constants.MONGODB_FX_DB_ALLOCATION_STATUS_COLLECTION);
			coll.insert(target);
			ret = target.size();

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
		MT4Display.outToConsole("insert is done. [" + ret + "] rows affected!");
		return ret;
	}
	
	public int persistent(DBObject currentAlgoAllocation) throws Exception{
		int ret = 0;

		if (currentAlgoAllocation == null)
			return ret;

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
					.getCollection(MT4Constants.MONGODB_FX_DB_ALLOCATION_STATUS_COLLECTION);
			coll.insert(currentAlgoAllocation);
			ret = 1;

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
		MT4Display.outToConsole("insert is done. [" + ret + "] rows affected!");
		return ret;
	}
	
	public int persitent() throws Exception {
		int ret = 0;

		if (allocations == null || allocations.size() == 0)
			return ret;

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
					.getCollection(MT4Constants.MONGODB_FX_DB_ALLOCATION_STATUS_COLLECTION);
			coll.insert(allocations);
			ret = allocations.size();

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
		MT4Display.outToConsole("insert is done. [" + ret + "] rows affected!");
		return ret;
	}
	
	public void parseAccountAllocationStatus(String fileName) throws Exception {
		try {
			Iterable<CSVRecord> parser = CSVFormat.DEFAULT.toBuilder()
					.withHeader().parse(new FileReader(fileName));

			MT4Display.outToConsole("processing file[" + fileName + "]");
			allocations = new ArrayList<DBObject>();

			for (CSVRecord record : parser) {
				MT4AllocationStatus allocation = new MT4AllocationStatus();
				allocation.setAccountID(record.get(MT4Constants.ACCOUNT_ID));
				allocation.setAlgoID(MT4Constants.ALLOCATION_NON_ALGO_FLAG);
				allocation.setBalance(Double.parseDouble(record
						.get(MT4Constants.ACCOUNT_BALANCE)));
				allocation.setEquity(Double.parseDouble(record
						.get(MT4Constants.ACCOUNT_EQUITY)));
				allocation.setEodDate(sdf.parse(record
						.get(MT4Constants.EOD_DATE)));
				allocation.setFreeMargin(Double.parseDouble(record
						.get(MT4Constants.ACCOUNT_FREE_MARGIN)));
				allocation.setMargin(Double.parseDouble(record
						.get(MT4Constants.ACCOUNT_MARGIN)));
				allocation.setProfit(Double.parseDouble(record
						.get(MT4Constants.ACCOUNT_PROFIT)));
				allocations.add(allocation);
			}

		} catch (ParseException e) {
			MT4Display.outToConsole("Can't parse EOD date column of file["
					+ fileName + "]");
			e.printStackTrace();
			throw e;
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
}
