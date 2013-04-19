package com.lwfund.fx.mt4.eod;

import java.io.FileReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;

public class AllClosedTradesArchive {
	
	private List<MT4Trade> trades = null;
	private static final DateFormat sdf = new SimpleDateFormat(MT4Constants.DEFAULT_DATE_FORMAT);
	
	public void retrieveTradesToBuffer(String fileName) throws Exception{
		
		Iterable<CSVRecord> parser = CSVFormat.DEFAULT.toBuilder().withHeader()
				.parse(new FileReader(fileName));
		
		trades = new ArrayList<>();

		for (CSVRecord record : parser) {
			
			MT4Trade currentTrade = new MT4Trade();

			currentTrade.setClosePrice(Float.parseFloat(record.get(MT4Constants.TRADE_CLOSE_PRICE)));
			currentTrade.setCloseTime(sdf.parse(record.get(MT4Constants.TRADE_CLOSE_TIME)));
			currentTrade.setComment(record.get(MT4Constants.TRADE_COMMENT));
			currentTrade.setCommission(Float.parseFloat(record.get(MT4Constants.TRADE_COMMISSION)));
			currentTrade.setExpiration(sdf.parse(record.get(MT4Constants.TRADE_EXPIRATION)));
			currentTrade.setLots(Float.parseFloat(record.get(MT4Constants.TRADE_LOTS)));
			currentTrade.setMagicNumber(Integer.parseInt(record.get(MT4Constants.TRADE_MAGIC_NUMBER)));
			currentTrade.setOpenPrice(Float.parseFloat(record.get(MT4Constants.TRADE_OPEN_PRICE)));
			currentTrade.setOpenTime(sdf.parse(record.get(MT4Constants.TRADE_OPEN_TIME)));
			currentTrade.setProfit(Float.parseFloat(record.get(MT4Constants.TRADE_PROFIT)));
			currentTrade.setStopLoss(Float.parseFloat(record.get(MT4Constants.TRADE_STOP_LOSS)));
			currentTrade.setSwap(Float.parseFloat(record.get(MT4Constants.TRADE_SWAP)));
			currentTrade.setSymbol(record.get(record.get(MT4Constants.TRADE_SYMBOL)));
			currentTrade.setTakeProfit(Float.parseFloat(record.get(MT4Constants.TRADE_TAKE_PROFIT)));
			currentTrade.setTicket(Integer.parseInt(record.get(MT4Constants.TRADE_TICKET)));
			currentTrade.setOrderType(Byte.parseByte(record.get(MT4Constants.TRADE_ORDER_TYPE)));
			
			trades.add(currentTrade);
		}
		
		System.out.println("loaded [" + trades.size() + "] trades......");
	}
	
	public static void main(String args[]) throws Exception {
		if (args.length < 1) {
			System.out.println("Usage: java AllClosedTradesArchive <csv_file>");
			return;
		}
		
		AllClosedTradesArchive ata = new AllClosedTradesArchive();
		//load trades to buffer
		ata.retrieveTradesToBuffer(args[0]);
		
		
		
		System.out.println("done");
		

	}
}
