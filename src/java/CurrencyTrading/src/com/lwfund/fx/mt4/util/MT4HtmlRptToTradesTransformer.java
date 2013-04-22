package com.lwfund.fx.mt4.util;

import java.io.FileReader;
import java.io.FileWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;

public class MT4HtmlRptToTradesTransformer {
	private static 	final DateFormat sdf = new SimpleDateFormat(
			MT4Constants.DEFAULT_DATE_FORMAT);
	private Map<String, MT4Trade>orderKeyedTrades = new HashMap<String, MT4Trade>();
	private List<MT4Trade> trades = new ArrayList<>();
	
	public List<MT4Trade> pairUpTrades(String inputFileName) throws Exception{
		Iterable<CSVRecord> parser = CSVFormat.DEFAULT.toBuilder().withHeader()
				.parse(new FileReader(inputFileName));

		for (CSVRecord record : parser) {

			MT4Trade currentTrade = null;
			String profit = record.get(MT4Constants.HTML_RPT_PROFIT);
			String order = record.get(MT4Constants.HTML_RPT_ORDER);
			String type = record.get(MT4Constants.HTML_RPT_TYPE);
			
			if(null == profit || "".equals(profit.trim())){
				currentTrade = new MT4Trade();
				if(MT4Constants.HTML_RPT_BUY_VALUE.equals(type)){
					currentTrade.setOrderType(MT4Constants.TRADE_ORDER_TYPE_BUY);
				}else if(MT4Constants.HTML_RPT_SELL_VALUE.equals(type)){
					currentTrade.setOrderType(MT4Constants.TRADE_ORDER_TYPE_SELL);
				}
				currentTrade.setOpenTime(sdf.parse(record.get(MT4Constants.HTML_RPT_TIME)));
				currentTrade.setLots(Float.parseFloat(record.get(MT4Constants.HTML_RPT_SIZE)));
				currentTrade.setOpenPrice(Float.parseFloat(record.get(MT4Constants.HTML_RPT_PRICE)));
				currentTrade.setStopLoss(Float.parseFloat(record.get(MT4Constants.HTML_RPT_STOPLOSS)));
				currentTrade.setTakeProfit(Float.parseFloat(record.get(MT4Constants.HTML_RPT_TAKEPROFIT)));
				
				if(orderKeyedTrades.containsKey(order)){
					MT4Display.outToConsole("sth is wrong, key map already had key[" + order +"]");
					throw new Exception("sth is wrong, key map already had key[" + order +"]");
				}
				orderKeyedTrades.put(order, currentTrade);
			}else{
				if(!orderKeyedTrades.containsKey(order)){
					MT4Display.outToConsole("sth is wrong, key map does not have key[" + order +"]");
					throw new Exception("sth is wrong, key map does not have key[" + order +"]");
				}				
				currentTrade = orderKeyedTrades.get(order);
				currentTrade.setLots(Float.parseFloat(record.get(MT4Constants.HTML_RPT_SIZE)));
				currentTrade.setCloseTime(sdf.parse(record.get(MT4Constants.HTML_RPT_TIME)));
				currentTrade.setClosePrice(Float.parseFloat(record.get(MT4Constants.HTML_RPT_PRICE)));
				currentTrade.setStopLoss(Float.parseFloat(record.get(MT4Constants.HTML_RPT_STOPLOSS)));
				currentTrade.setTakeProfit(Float.parseFloat(record.get(MT4Constants.HTML_RPT_TAKEPROFIT)));				
				currentTrade.setProfit(Float.parseFloat(record.get(MT4Constants.HTML_RPT_PROFIT)));
				trades.add(currentTrade);
			}
		}

		MT4Display.outToConsole("loaded [" + trades.size() + "] pair trades......");
		
		return trades;
	}
	
	public void outputTradesToCSV(String outputFileName) throws Exception{
		
		if(trades == null || trades.size() == 0){
			MT4Display.outToConsole("Buffer does not have any trade yet!");
			return;
		}
		
		MT4Display.outToConsole("dumping [" + trades.size() + "] trades...");
		
		FileWriter writer = new FileWriter(outputFileName);
		CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT);
		
		//Header
		csvPrinter.print(MT4Constants.TRADE_CLOSE_PRICE);
		csvPrinter.print(MT4Constants.TRADE_CLOSE_TIME);
		csvPrinter.print(MT4Constants.TRADE_COMMENT);
		csvPrinter.print(MT4Constants.TRADE_COMMISSION);
		csvPrinter.print(MT4Constants.TRADE_EXPIRATION);
		csvPrinter.print(MT4Constants.TRADE_LOTS);
		csvPrinter.print(MT4Constants.TRADE_MAGIC_NUMBER);
		csvPrinter.print(MT4Constants.TRADE_OPEN_PRICE);
		csvPrinter.print(MT4Constants.TRADE_OPEN_TIME);
		csvPrinter.print(MT4Constants.TRADE_PROFIT);
		csvPrinter.print(MT4Constants.TRADE_STOP_LOSS);
		csvPrinter.print(MT4Constants.TRADE_SWAP);
		csvPrinter.print(MT4Constants.TRADE_SYMBOL);
		csvPrinter.print(MT4Constants.TRADE_TAKE_PROFIT);
		csvPrinter.print(MT4Constants.TRADE_TICKET);
		csvPrinter.print(MT4Constants.TRADE_ORDER_TYPE);
		csvPrinter.println();
		
		for (MT4Trade currentTrade : trades) {
			csvPrinter.print(currentTrade.getClosePrice());
			csvPrinter.print(sdf.format(currentTrade.getCloseTime()));
			csvPrinter.print("convert from HTML");
			csvPrinter.print(0);
			csvPrinter.print(0);
			csvPrinter.print(currentTrade.getLots());
			csvPrinter.print(0);
			csvPrinter.print(currentTrade.getOpenPrice());
			csvPrinter.print(sdf.format(currentTrade.getOpenTime()));
			csvPrinter.print(currentTrade.getProfit());
			csvPrinter.print(currentTrade.getStopLoss());
			csvPrinter.print(0);
			csvPrinter.print("");
			csvPrinter.print(currentTrade.getTakeProfit());
			csvPrinter.print(0);
			csvPrinter.print(currentTrade.getOrderType());
			csvPrinter.println();
		}
		
		csvPrinter.close();
		writer.close();
		
		MT4Display.outToConsole("done");
	}
	
	public static void main(String args[]) throws Exception{
		String srcFileName = "C:\\test\\trade1.csv";
		String targetFileName = "C:\\test\\trade1MT4.csv";
		if(args != null && args.length == 2){
			srcFileName = args[0];
			targetFileName = args[1];
		}
		
		MT4HtmlRptToTradesTransformer mocker = new MT4HtmlRptToTradesTransformer();
		mocker.pairUpTrades(srcFileName);
		mocker.outputTradesToCSV(targetFileName);
	}
}
