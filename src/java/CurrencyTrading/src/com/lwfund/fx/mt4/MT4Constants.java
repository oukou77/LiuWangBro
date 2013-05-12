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
	
	public static final int CHART_PERIOD_TYPE_M1 = 1;
	public static final int CHART_PERIOD_TYPE_M5 = 2;
	public static final int CHART_PERIOD_TYPE_M15 = 3;
	public static final int CHART_PERIOD_TYPE_M30 = 4;
	public static final int CHART_PERIOD_TYPE_H1 = 5;
	public static final int CHART_PERIOD_TYPE_H4 = 6;
	public static final int CHART_PERIOD_TYPE_D1 = 7;
	public static final int CHART_PERIOD_TYPE_W1 = 8;
	public static final int CHART_PERIOD_TYPE_MN = 9;
	
	public static final int REPORT_PERIOD_7DAYS = 7;
	public static final int REPORT_PERIOD_30DAYS = 30;
	public static final int REPORT_PERIOD_300DAYS = 300;
	public static final int REPORT_PERIOD_YTD = 1;
	
	public static final String PERFORMANCE_RPT_TYPE = "PerformanceReportType";
	
	public static final String RESULTS_GROSS_PERFORMANCE = "GrossPerformance";
	public static final String RESULTS_DRAWDOWN = "Drawdown";
	
	public static final int MARKET_DATA_PRICE_TYPE_OPEN = 1;
	public static final int MARKET_DATA_PRICE_TYPE_CLOSE = 2;
	public static final int MARKET_DATA_PRICE_TYPE_HIGH = 3;
	public static final int MARKET_DATA_PRICE_TYPE_LOW = 4;
	public static final int MARKET_DATA_PRICE_TYPE_VOLUME = 5;
	
	public static final String MARKET_DATA_BAR_PERIOD_TYPE = "BarPeriodType";
	public static final String MARKET_DATA_CLOSE = "Close";
	public static final String MARKET_DATA_HIGH = "High";
	public static final String MARKET_DATA_TIME = "Time";
	public static final String MARKET_DATA_LOW = "Low";
	public static final String MARKET_DATA_OPEN = "Open";
	public static final String MARKET_DATA_SYMBOL = "Symbol";
	public static final String MARKET_DATA_VOLUME = "Volume";
	
	public static final String FIXED_MARKET_DATA_SOURCE_ACCT_ID = "10952720";
	public static final int FIXED_MARKET_DATA_BAR_TYPE = 1;
	public static final String FIXED_MARKET_DATA_FILE_SUFFIX = "TKO.csv";
	public static final String[] FX_SYMBOL_ARRAY = {"EURUSDpro","USDJPYpro","EURJPYpro","GBPJPYpro","AUDJPYpro","NZDJPYpro"};
	public static final String FIXED_DEPOSIT_COMMENT = "Deposit";
	public static final String FIXED_DEPOSIT_COMMENT_FOREX = "Wires";
	public static final String FIXED_JPY_SYMBOL = "JPY";
	public static final int FIXED_DAYS_IN_YEAR = 360;
	
	public static final String EOD_INPUT_FILE_ACCOUNT_INFO = "AccountInfoFor#As@.csv";
	public static final String EOD_INPUT_FILE_TRADE_ARCHIVE = "TradesArchiveFor#As@.csv";
	public static final String EOD_INPUT_MKT_DATA = "#@TKOtime.csv";
	public static final String EOD_FROM_DATE = "from date";
	public static final String EOD_TO_DATE = "to date";
	
	public static final String ACCOUNT_ID = "account number";
	public static final String ACCOUNT_ID_IN_MONGO = "AccountID";
	public static final String ACCOUNT_BALANCE = "account balance";
	public static final String ACCOUNT_PROFIT = "account profit";
	public static final String ACCOUNT_EQUITY = "account equity";
	public static final String ACCOUNT_FREE_MARGIN = "account free margin";
	public static final String ACCOUNT_MARGIN = "account margin";
	public static final String ALLOCATION_NON_ALGO_FLAG = "0";
	public static final String ALLOCATION_NON_ACCOUNT_FLAG = "0";
	public static final String ALGORITHM_ID = "algo id";
	public static final String ALGORITHM_ID_IN_MONGO = "AlgoID";
	public static final String ALGORITHM_BALANCE = "algo balance";
	public static final String ALGORITHM_EQUITY = "algo equity";
	public static final String ALGORITHM_MARGIN = "algo margin";
	public static final String ALGORITHM_FREE_MARGIN = "algo free margin";
	public static final String ACCOUNT_DEPOSIT = "account deposit";
	
	public static final String EOD_DATE = "eod date";
	public static final String EOD_DATE_IN_MONGO = "EodDate";
	
	public static final String TIMEZONE_LONDON = "Europe/London";
	public static final String TIMEZONE_TOKYO = "Asia/Tokyo";
	public static final String TIMEZONE_HONGKONG = "Asia/Hong_Kong";
	
	public static final String TRADE_CLOSE_PRICE = "close price";
	public static final String TRADE_CLOSE_TIME = "close time";
	public static final String TRADE_CLOSE_TIME_IN_MONGO = "CloseTime";
	public static final String TRADE_COMMENT = "comment";
	public static final String TRADE_COMMISSION = "commission";
	public static final String TRADE_EXPIRATION = "expiration";
	public static final String TRADE_LOTS = "lots";
	public static final String TRADE_MAGIC_NUMBER = "magic number";
	public static final String TRADE_MAGIC_NUMBER_IN_MONGO = "MagicNumber";
	public static final String TRADE_OPEN_PRICE = "open price";
	public static final String TRADE_OPEN_TIME = "open time";
	public static final String TRADE_PROFIT = "profit";
	public static final String TRADE_STOP_LOSS = "stop loss";
	public static final String TRADE_SWAP = "swap";
	public static final String TRADE_SYMBOL = "symbol";
	public static final String TRADE_TAKE_PROFIT = "take profit";
	public static final String TRADE_TICKET = "ticket";
	public static final String TRADE_ORDER_TYPE = "order type";
	public static final String TRADE_ORDER_TYPE_IN_MONGO = "OrderType";
	public static final String TRADE_ACCOUNT_ID = "account id";
	public static final String TRADE_ACCOUNT_ID_IN_MONGO = "AccountID";
	public static final String TRADE_IS_CLOSED = "is closed";
	public static final String TRADE_EOD_DATE = "eod date";
	public static final String TRADE_IS_CLOSED_VALUE = "1";
	
	public static final String DEFAULT_DATE_ZERO_CONVERT = "1970.01.01 00:00";
	public static final String DEFAULT_DATE_FORMAT= "yyyy.MM.dd HH:mm";
	public static final String DEFAULT_MARKET_DATA_TIME_FORMAT = "yyyy.MM.ddHH:mm";
	public static final String DEFAULT_DATE_ZERO = "0";
	
	public static final String HTML_RPT_ID = "#";
	public static final String HTML_RPT_TIME = "Time";
	public static final String HTML_RPT_TYPE = "Type";
	public static final String HTML_RPT_ORDER = "Order";
	public static final String HTML_RPT_SIZE = "Size";
	public static final String HTML_RPT_PRICE = "Price";
	public static final String HTML_RPT_STOPLOSS = "S / L";
	public static final String HTML_RPT_TAKEPROFIT = "T / P";
	public static final String HTML_RPT_PROFIT = "Profit";
	public static final String HTML_RPT_BALANCE = "Balance";
	public static final String HTML_RPT_BUY_VALUE = "buy";
	public static final String HTML_RPT_SELL_VALUE = "sell";
	
	public static final String TEMP_DB_SERVER_ADDRESS="127.0.0.1";
	public static final int TEMP_DB_SERVER_PORT = 27017;
	public static final String MONGODB_FX_DB_NAME = "CurrencyTrading";
	public static final String MONGODB_FX_DB_CLOSED_TRADE_ARCHIVE_COLLECTION = "ClosedTradesArchive";
	public static final String MONGODB_FX_DB_OPEN_TRADE_ARCHIVE_COLLECTION = "OpenTradesArchive";
	public static final String MONGODB_FX_DB_ALGORITHMS_COLLECTION = "Algorithms";
	public static final String MONGODB_FX_DB_BROKER_ACCOUNT_COLLECTION = "BrokerAccounts";
	public static final String MONGODB_FX_DB_ALLOCATION_STATUS_COLLECTION ="AllocationStatus";
	public static final String MONGODB_FX_DB_MARKET_DATA_COLLECTION = "MarketData";
	public static final String MONGODB_FX_DB_GROSS_PERFORMANCE_COLLECTION = "GrossPerformance";
	public static final String MONGODB_FX_DB_REFERENCED_RATES_COLLECTION = "ReferencedRates";
	
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
	public static final String PERFORMANCE_RPT_ABSOLUTE_DRAWDOWN = "AbsoluteDrawdown";
	public static final String PERFORMANCE_RPT_MAX_DRAWDOWN = "MaximalDrawdown";
	public static final String PERFORMANCE_RPT_MAX_DRAWDOWN_PERCENT = "MaximalDrawdownPercent";
	public static final String PERFORMANCE_RPT_RELATIVE_DRAWDOWN = "RelativeDrawdown";
	public static final String PERFORMANCE_RPT_RELATIVE_DRAWDOWN_PERCENT = "RelativeDrawdownPercent";
	public static final String PERFORMANCE_RPT_AVG_LOT = "AverageLot";
	public static final String PERFORMANCE_RPT_TOTAL_PIPS = "totalPips";
	public static final String PERFORMANCE_RPT_PROFIT_PIPS = "profitPips";
	public static final String PERFORMANCE_RPT_LOSS_PIPS = "lossPips";
}
