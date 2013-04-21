package com.lwfund.fx.mt4;

public class MT4Constants {
	
	private MT4Constants(){};
	
	public static final byte TRADE_ORDER_TYPE_BUY = 0;
	public static final byte TRADE_ORDER_TYPE_SELL = 1;
	public static final byte TRADE_ORDER_TYPE_BUYLIMIT = 2;
	public static final byte TRADE_ORDER_TYPE_BUYSTOP = 3;
	public static final byte TRADE_ORDER_TYPE_SELLLIMIT = 4;
	public static final byte TRADE_ORDER_TYPE_SELLSTOP = 5;
	public static final byte TRADE_ORDER_TYPE_BROKER_ACTION = 6;
	
	public static final String TRADE_CLOSE_PRICE = "close price";
	public static final String TRADE_CLOSE_TIME = "close time";
	public static final String TRADE_COMMENT = "comment";
	public static final String TRADE_COMMISSION = "commission";
	public static final String TRADE_EXPIRATION = "expiration";
	public static final String TRADE_LOTS = "lots";
	public static final String TRADE_MAGIC_NUMBER = "magic number";
	public static final String TRADE_OPEN_PRICE = "open price";
	public static final String TRADE_OPEN_TIME = "open time";
	public static final String TRADE_PROFIT = "profit";
	public static final String TRADE_STOP_LOSS = "stop loss";
	public static final String TRADE_SWAP = "swap";
	public static final String TRADE_SYMBOL = "symbol";
	public static final String TRADE_TAKE_PROFIT = "take profit";
	public static final String TRADE_TICKET = "ticket";
	public static final String TRADE_ORDER_TYPE = "order type";
	public static final String DEFAULT_DATE_ZERO_CONVERT = "1970.01.01 00:00";
	public static final String DEFAULT_DATE_FORMAT= "yyyy.MM.dd HH:mm";
	public static final String DEFAULT_DATE_ZERO = "0";
	
	public static final String TEMP_DB_SERVER_ADDRESS="127.0.0.1";
	public static final int TEMP_DB_SERVER_PORT = 27017;
	public static final String MONGODB_FX_DB_NAME = "CurrencyTrading";
	public static final String MONGODB_FX_DB_COLLECTION_NAME = "TradesArchive";
	
	public static final String PERFORMANCE_RPT_PROFIT_EXPECTATION = "ProfitExpecation";
	public static final String PERFORMANCE_RPT_PROFIT_STANDARD_DEVIATION = "ProfitStandardDeviation";
	public static final String PERFORMANCE_RPT_GROSS_PROFIT = "GrossProfit";
	public static final String PERFORMANCE_RPT_GROSS_LOSS = "GrossLoss";
	public static final String PERFORMANCE_RPT_PROFIT_FACTOR = "ProfitFactor";
	public static final String PERFORMANCE_RPT_INITIAL_DEPOSIT = "InitialDeposit";
	public static final String PERFORMANCE_RPT_TOTAL_NET_PROFIT = "TotalNetProfit";
	public static final String PERFORMANCE_RPT_EXPECTED_PAYOFF = "ExpectedPayoff";
	public static final String PERFORMANCE_RPT_TOTAL_TRADES = "TotalTrades";
	public static final String PERFORMANCE_RPT_SHORT_POSITIONS = "ShortPositions";
	public static final String PERFORMANCE_RPT_SHORT_POSITIONS_WON = "ShortPositionsWon";
	public static final String PERFORMANCE_RPT_LONG_POSITIONS = "LongPositions";
	public static final String PERFORMANCE_RPT_LONG_POSITIONS_WON = "LongPositionsWon";
	public static final String PERFORMANCE_RPT_PROFIT_TRADES = "ProfitTrades";
	public static final String PERFORMANCE_RPT_LOSS_TRADES = "LossTrades";
	public static final String PERFORMANCE_RPT_PROFIT_TRADES_PERCENTAGE = "ProfitTradesPercentage";
	public static final String PERFORMANCE_RPT_LOSS_TRADES_PERCENTAGE = "LossTradesPercentage";
	public static final String PERFORMANCE_RPT_LARGEST_PROFIT_TRADE = "LargestProfitTrade";
	public static final String PERFORMANCE_RPT_LARGEST_LOSS_TRADE = "LargestLossTrade";
	public static final String PERFORMANCE_RPT_AVG_PROFIT_TRADE = "AverageProfitTrade";
	public static final String PERFORMANCE_RPT_AVG_LOSS_TRADE = "AverageLossTrade";
	public static final String PERFORMANCE_RPT_MAX_CONSECUTIVE_WINS = "MaximumConsecutiveWins";
	public static final String PERFORMANCE_RPT_MAX_CONSECUTIVE_WINS_MONEY = "MaximumConsecutiveWinsMoney";
	public static final String PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSSES = "MaximumConsecutiveLosses";
	public static final String PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSSES_MONEY = "MaximumConsecutiveLossesMoney";
	public static final String PERFORMANCE_RPT_MAX_CONSECUTIVE_PROFIT ="MaximumConsecutiveProfit";
	public static final String PERFORMANCE_RPT_MAX_CONSECUTIVE_PROFIT_WINS = "MaximumConsecutiveProfitWins";
	public static final String PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSS = "MaximumConsecutiveLoss";
	public static final String PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSS_LOSSES = "MaximumConsecutiveLossLosses";
	public static final String PERFORMANCE_RPT_AVG_CONSECUTIVE_WINS = "AverageConsecutiveWins";
	public static final String PERFORMANCE_RPT_AVG_CONSECUTIVE_LOSSES = "AverageConsecutiveLosses";

}
