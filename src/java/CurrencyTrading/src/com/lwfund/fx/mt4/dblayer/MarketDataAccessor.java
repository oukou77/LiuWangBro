package com.lwfund.fx.mt4.dblayer;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4MarketData;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;

public class MarketDataAccessor {
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;
	private List<DBObject> marketDataList;
	
	public int persistentMarketData(List<DBObject> mktDataList) throws Exception{
		int ret = 0;
		if(mktDataList == null || mktDataList.isEmpty()){
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

			DBCollection mktDataColl = this.mongoFXDB.getCollection(MT4Constants.MONGODB_FX_DB_MARKET_DATA_COLLECTION);
			mktDataColl.insert(mktDataList);
			ret = mktDataList.size();

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
			throw ex;
		} catch (MongoException ex) {
			ex.printStackTrace();
			throw ex;
		} finally{
//			this.mongoInstance.close();
		}
		MT4Display.outToConsole("insert is done. [" + ret + "] rows affected!");
		return ret;
	}
	
	public int persistentMarketData() throws Exception{
		return persistentMarketData(marketDataList);
				
	}
	
	public void parseMarketData(String fileName,String symbol,int barType) throws Exception{
		try {
			Iterable<CSVRecord> parser = CSVFormat.DEFAULT.toBuilder().parse(new FileReader(fileName));

			MT4Display.outToConsole("processing file[" + fileName + "]");
			this.marketDataList = new ArrayList<DBObject>();
			
			for (CSVRecord record : parser) {
				MT4MarketData mktData = new MT4MarketData();
				mktData.setSymbol(symbol);
				mktData.setAccountID(MT4Constants.FIXED_MARKET_DATA_SOURCE_ACCT_ID);
				mktData.setDateStr(record.get(0));
				mktData.setHourMinStr(record.get(1));
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
	
	
}
