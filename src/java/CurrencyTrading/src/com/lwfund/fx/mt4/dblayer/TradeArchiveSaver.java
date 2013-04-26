package com.lwfund.fx.mt4.dblayer;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.UnknownHostException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;

public class TradeArchiveSaver {
	
	List<DBObject> trades;
	private static final DateFormat sdf = new SimpleDateFormat(
			MT4Constants.DEFAULT_DATE_FORMAT);
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;
	
	List<DBObject> getParsedTrades(){
		//should clone
		//package access level atm
		return trades;
	}
	
	public int persitent() throws Exception {
		int ret = 0;

		if (trades == null || trades.size() == 0){
			MT4Display.outToConsole("No trades found");
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

			DBCollection closedColl = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_CLOSED_TRADE_ARCHIVE_COLLECTION);
			DBCollection openColl = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_OPEN_TRADE_ARCHIVE_COLLECTION);
			
			for (DBObject currentObj : this.trades) {
				MT4Trade currentTrade = (MT4Trade)currentObj;
				if(currentTrade.isClosed()){
					closedColl.insert(currentTrade);
				}else{
					openColl.insert(currentTrade);
				}
			}
			ret = trades.size();

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
			throw ex;
		} catch (MongoException ex) {
			ex.printStackTrace();
			throw ex;
		} finally{
			this.mongoInstance.close();
		}
		MT4Display.outToConsole("insert is done. [" + ret + "] rows affected!");
		return ret;
	}
	
	public void parseTrades(String fileName) throws Exception{
		try {
			Iterable<CSVRecord> parser = CSVFormat.DEFAULT.toBuilder()
					.withHeader().parse(new FileReader(fileName));

			MT4Display.outToConsole("processing file[" + fileName + "]");
			trades = new ArrayList<>();

			for (CSVRecord record : parser) {
				MT4Trade currentTrade = new MT4Trade();

				currentTrade.setClosePrice(Float.parseFloat(record
						.get(MT4Constants.TRADE_CLOSE_PRICE)));
				currentTrade.setCloseTime(sdf.parse(record
						.get(MT4Constants.TRADE_CLOSE_TIME)));
				currentTrade.setComment(record.get(MT4Constants.TRADE_COMMENT));
				currentTrade.setCommission(Float.parseFloat(record
						.get(MT4Constants.TRADE_COMMISSION)));
				currentTrade.setExpiration(sdf.parse(record
						.get(MT4Constants.TRADE_EXPIRATION)));
				currentTrade.setLots(Float.parseFloat(record
						.get(MT4Constants.TRADE_LOTS)));
				currentTrade.setMagicNumber(Integer.parseInt(record
						.get(MT4Constants.TRADE_MAGIC_NUMBER)));
				currentTrade.setOpenPrice(Float.parseFloat(record
						.get(MT4Constants.TRADE_OPEN_PRICE)));
				currentTrade.setOpenTime(sdf.parse(record
						.get(MT4Constants.TRADE_OPEN_TIME)));
				currentTrade.setProfit(Float.parseFloat(record
						.get(MT4Constants.TRADE_PROFIT)));
				currentTrade.setStopLoss(Float.parseFloat(record
						.get(MT4Constants.TRADE_STOP_LOSS)));
				currentTrade.setSwap(Float.parseFloat(record
						.get(MT4Constants.TRADE_SWAP)));
				currentTrade.setSymbol(record.get(MT4Constants.TRADE_SYMBOL));
				currentTrade.setTakeProfit(Float.parseFloat(record
						.get(MT4Constants.TRADE_TAKE_PROFIT)));
				currentTrade.setTicket(Integer.parseInt(record
						.get(MT4Constants.TRADE_TICKET)));
				currentTrade.setOrderType(Byte.parseByte(record
						.get(MT4Constants.TRADE_ORDER_TYPE)));
				currentTrade.setAccountID(record.get(MT4Constants.TRADE_ACCOUNT_ID));
				if(MT4Constants.TRADE_IS_CLOSED_VALUE.equals(record.get(MT4Constants.TRADE_IS_CLOSED))){
					currentTrade.setClosed(true);
				}else{
					currentTrade.setClosed(false);
				}
				currentTrade.setEodDate(sdf.parse(record.get(MT4Constants.TRADE_EOD_DATE)));
				
				trades.add(currentTrade);
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
