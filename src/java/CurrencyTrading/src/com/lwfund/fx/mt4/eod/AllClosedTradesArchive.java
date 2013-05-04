package com.lwfund.fx.mt4.eod;

import java.io.FileReader;
import java.net.UnknownHostException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

import com.lwfund.fx.mt4.MT4Account;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.dblayer.BrokerAccountInfoAccessor;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.WriteResult;

public class AllClosedTradesArchive {

	private List<DBObject> trades = null;
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;
	private static final DateFormat sdf = new SimpleDateFormat(
			MT4Constants.DEFAULT_DATE_FORMAT);
	
	public List<DBObject> retrieveTradesToBuffer(String fileName) throws Exception {

		Iterable<CSVRecord> parser = CSVFormat.DEFAULT.toBuilder().withHeader()
				.parse(new FileReader(fileName));

		List<MT4Account> accounts = BrokerAccountInfoAccessor.getAccoutInfoList();
		Map<String,MT4Account> accountsMap = new HashMap<String, MT4Account>(); 
		for (MT4Account mt4Account : accounts) {
			accountsMap.put(mt4Account.getAccountID(), mt4Account);
		}
		
		trades = new ArrayList<DBObject>();

		for (CSVRecord record : parser) {

			MT4Trade currentTrade = new MT4Trade();
			
			currentTrade.setAccountID(record.get(MT4Constants.TRADE_ACCOUNT_ID));
			sdf.setTimeZone(TimeZone.getTimeZone(accountsMap.get(currentTrade.getAccountID()).getTimeZone()));
			
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
			
			if(MT4Constants.TRADE_IS_CLOSED_VALUE.equals(record.get(MT4Constants.TRADE_IS_CLOSED))){
				currentTrade.setClosed(true);
			}else{
				currentTrade.setClosed(false);
			}
			currentTrade.setEodDate(sdf.parse(record.get(MT4Constants.TRADE_EOD_DATE)));
			trades.add(currentTrade);
		}

		MT4Display.outToConsole("loaded [" + trades.size() + "] trades......");
		
		return trades;
	}

	public void persistentTrades() {
		if (trades == null || trades.size() == 0) {
			MT4Display.outToConsole("empty trade list, stopping.....");
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
					.getCollection(MT4Constants.MONGODB_FX_DB_CLOSED_TRADE_ARCHIVE_COLLECTION);
			WriteResult wr = coll.insert(this.trades);

			MT4Display.outToConsole("insert is done. [" + wr.getN()
					+ "] rows affected!");

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
		} catch (MongoException ex) {
			ex.printStackTrace();
		} finally{
//			this.mongoInstance.close();
		}
	}

	public static void main(String args[]) throws Exception {
		if (args.length < 1) {
			MT4Display
					.outToConsole("Usage: java AllClosedTradesArchive <csv_file>");
			return;
		}

		AllClosedTradesArchive ata = new AllClosedTradesArchive();
		// load trades to buffer
		ata.retrieveTradesToBuffer(args[0]);
		
		//Persistent the trades to Mongodb
		ata.persistentTrades();

		MT4Display.outToConsole("done");

	}
}
