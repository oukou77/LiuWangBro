package com.lwfund.fx.mt4.calculators;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;

import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.util.MT4Display;

public class GrossPerformanceCalculator implements MT4TradeCalculator {
	private double grossProfit = 0;
	private double grossLoss = 0;
	private double initialDeposit = 0;
	private double minimalBalance = 0;
	private double balance = 0;
	
	private int totalTrades = 0;
	private int profitTrades = 0;
	private int lossTrades = 0;
	private double largestProfit = 0;
	private double largestLoss = 0;
	private int longTrades = 0;
	private int shortTrades = 0;
	private int longProfitTrades = 0;
	private int shortProfitTrades = 0;
	
	private int maxConsecutiveWinNumber = 0;
	private double maxConsecutiveWinMoney = 0;
	private int maxConsecutiveLossesNumber = 0;
	private double maxConsecutiveLossesMoney =0;
	private int consecutiveWinNumber = 0;
	private int consecutiveLossesNumber = 0;
	private double consecutiveWinMoney = 0;
	private double consecutiveLossesMoney =0;
	
	private double consecutiveProfit = 0;
	private double consecutiveLoss = 0;
	private int consecutiveProfitNumber = 0;
	private int consecutiveLossNumber = 0;
	private double maxConsecutiveProfit = 0;
	private int maxConsecutiveProfitNumber = 0;
	private double maxConsecutiveLoss = 0;
	private int maxConsecutiveLossNumber = 0;
	
	private int consecutiveWinsCounts = 0;
	private int consecutiveLossesCounts = 0;
	private int totalConsecutiveWins = 0;
	private int totalConsecutiveLosses = 0;
	
	//0 loss, 1 win
	private byte previousWinLossFlag = -1;
	
	public void init(Map<String,String> parameters){
		if(parameters.containsKey(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT)){
			initialDeposit = Double.parseDouble(parameters.get(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT));
			balance = initialDeposit;
		}
	}
	
	@Override
	public void process(MT4Trade trade) {
		if(trade == null) return;
		
		totalTrades += 1;
		
		if(trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_BUY){
			longTrades += 1;
			if(trade.getRealProfit() >= 0){
				longProfitTrades += 1;
			}
		}else if(trade.getOrderType() == MT4Constants.TRADE_ORDER_TYPE_SELL){
			shortTrades += 1;
			if(trade.getRealProfit() >= 0){
				shortProfitTrades += 1;
			}
		}
		
		if(trade.getRealProfit() >= 0){
			grossProfit += trade.getRealProfit();
			profitTrades += 1;
			if(largestProfit < trade.getRealProfit()){
				largestProfit = trade.getRealProfit();
			}
		}else{
			grossLoss += trade.getRealProfit();
			lossTrades += 1;
			if(largestLoss > trade.getRealProfit()){
				largestLoss = trade.getRealProfit();
			}
		}
		
		balance += trade.getRealProfit();
		if(minimalBalance >= balance){
			minimalBalance = balance;
		}
		
		//consecutive counters
		if(previousWinLossFlag == 1){
			if(trade.getRealProfit() > 0){
				consecutiveWinNumber += 1;
				consecutiveWinMoney += trade.getRealProfit();
				if(maxConsecutiveWinNumber < consecutiveWinNumber){
					maxConsecutiveWinNumber = consecutiveWinNumber;
					maxConsecutiveWinMoney = consecutiveWinMoney;
				}
				
				consecutiveProfit += trade.getRealProfit();
				consecutiveProfitNumber += 1;
				if(maxConsecutiveProfit < consecutiveProfit){
					maxConsecutiveProfit = consecutiveProfit;
					maxConsecutiveProfitNumber = consecutiveProfitNumber;
				}
			}else if(trade.getRealProfit() < 0){
				
				if(consecutiveWinNumber > 1){
					totalConsecutiveWins += consecutiveWinNumber;
					consecutiveWinsCounts += 1;
				}
				
				consecutiveProfit = 0;
				consecutiveProfitNumber = 0;
				consecutiveWinMoney = 0;
				consecutiveWinNumber = 0;
				consecutiveLoss = trade.getRealProfit();
				consecutiveLossesMoney = trade.getRealProfit();
				consecutiveLossesNumber = 1;
				consecutiveLossNumber = 1;
				previousWinLossFlag = 0;
			}
			
		}else if(previousWinLossFlag == 0){
			if(trade.getRealProfit()< 0){
				consecutiveLossNumber += 1;
				consecutiveLossesNumber += 1;
				consecutiveLoss += trade.getRealProfit();
				consecutiveLossesMoney += trade.getRealProfit();
				if(maxConsecutiveLoss > consecutiveLoss){
					maxConsecutiveLoss = consecutiveLoss;
					maxConsecutiveLossNumber = consecutiveLossNumber;
				}
				
				if(maxConsecutiveLossesNumber < consecutiveLossesNumber){
					maxConsecutiveLossesNumber = consecutiveLossesNumber;
					maxConsecutiveLossesMoney = consecutiveLossesMoney;
				}
			}else if(trade.getRealProfit() > 0){
				if(consecutiveLossesNumber > 1){
					totalConsecutiveLosses += consecutiveLossesNumber;
					consecutiveLossesCounts += 1;
				}
				
				consecutiveLoss = 0;
				consecutiveLossesMoney = 0;
				consecutiveLossesNumber = 0;
				consecutiveLossNumber = 0;
				consecutiveProfit = trade.getRealProfit();
				consecutiveProfitNumber = 1;
				consecutiveWinMoney = trade.getRealProfit();
				consecutiveWinNumber = 1;
				previousWinLossFlag = 1;
			}
		}else{
			if(trade.getRealProfit() >= 0){
				previousWinLossFlag = 1;
				maxConsecutiveWinNumber = 1;
				maxConsecutiveWinMoney = trade.getRealProfit();
				consecutiveWinNumber = 1;
				consecutiveWinMoney = trade.getRealProfit();
				consecutiveProfit = trade.getRealProfit();
				consecutiveProfitNumber = 1;
				maxConsecutiveProfit = trade.getRealProfit();
				maxConsecutiveProfitNumber = 1;
			}else{
				previousWinLossFlag = 0;
				maxConsecutiveLossesNumber=1;
				maxConsecutiveLossesMoney = trade.getRealProfit();
				consecutiveLossesNumber=1;
				consecutiveLossesMoney = trade.getRealProfit();
				consecutiveLoss = trade.getRealProfit();
				consecutiveLossNumber = 1;
				maxConsecutiveLoss = trade.getRealProfit();
				maxConsecutiveLossNumber = 1;
			}
		}
		
	}

	@Override
	public Map<String, String> calculate() {
		Map<String,String> ret = new HashMap<String, String>();
		DecimalFormat dfDefault  =  new DecimalFormat("0.00"); 
		DecimalFormat dfPercent = new DecimalFormat("0.00%");
		MT4Display.outToConsole((double)profitTrades/totalTrades);
		ret.put(MT4Constants.PERFORMANCE_RPT_INITIAL_DEPOSIT, dfDefault.format(initialDeposit));
		ret.put(MT4Constants.PERFORMANCE_RPT_TOTAL_NET_PROFIT, dfDefault.format(balance-initialDeposit));
		ret.put(MT4Constants.PERFORMANCE_RPT_GROSS_PROFIT, dfDefault.format(grossProfit));
		ret.put(MT4Constants.PERFORMANCE_RPT_GROSS_LOSS, dfDefault.format(grossLoss));
		ret.put(MT4Constants.PERFORMANCE_RPT_PROFIT_FACTOR, dfDefault.format(Math.abs((double)grossProfit/grossLoss)));
		//Expected Payoff = (ProfitTrades / TotalTrades) * (GrossProfit / ProfitTrades) - 
        //(LossTrades / TotalTrades) * (GrossLoss / LossTrades)
		double expectedPayoff = ((double)profitTrades/(double)totalTrades) * (grossProfit/(double)profitTrades) - 
								Math.abs(((double)lossTrades/(double)totalTrades) * (grossLoss/(double)lossTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_EXPECTED_PAYOFF, dfDefault.format(expectedPayoff));
		
		ret.put(MT4Constants.PERFORMANCE_RPT_TOTAL_TRADES, Integer.toString(totalTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_PROFIT_TRADES,Integer.toString(profitTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_PROFIT_TRADES_PERCENTAGE, dfPercent.format((double)profitTrades/totalTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_LOSS_TRADES, Integer.toString(lossTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_LOSS_TRADES_PERCENTAGE, dfPercent.format((double)lossTrades/totalTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_SHORT_POSITIONS,Integer.toString(shortTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_SHORT_POSITIONS_WON, dfPercent.format((double)shortProfitTrades/shortTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_LONG_POSITIONS, Integer.toString(longTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_LONG_POSITIONS_WON, dfPercent.format((double)longProfitTrades/longTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_LARGEST_PROFIT_TRADE, dfDefault.format(largestProfit));
		ret.put(MT4Constants.PERFORMANCE_RPT_LARGEST_LOSS_TRADE, dfDefault.format(largestLoss));
		ret.put(MT4Constants.PERFORMANCE_RPT_AVG_PROFIT_TRADE, dfDefault.format((double)grossProfit/profitTrades));
		ret.put(MT4Constants.PERFORMANCE_RPT_AVG_LOSS_TRADE, dfDefault.format((double)grossLoss/lossTrades));
		
		ret.put(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_WINS,Integer.toString(maxConsecutiveWinNumber));
		ret.put(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_WINS_MONEY, dfDefault.format(maxConsecutiveWinMoney));
		ret.put(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSSES, Integer.toString(maxConsecutiveLossesNumber));
		ret.put(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSSES_MONEY, dfDefault.format(maxConsecutiveLossesMoney));
		
		ret.put(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_PROFIT, dfDefault.format(maxConsecutiveProfit));
		ret.put(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_PROFIT_WINS, Integer.toString(maxConsecutiveProfitNumber));
		ret.put(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSS, dfDefault.format(maxConsecutiveLoss));
		ret.put(MT4Constants.PERFORMANCE_RPT_MAX_CONSECUTIVE_LOSS_LOSSES, Integer.toString(maxConsecutiveLossNumber));
		ret.put(MT4Constants.PERFORMANCE_RPT_AVG_CONSECUTIVE_WINS, dfDefault.format((double)totalConsecutiveWins/consecutiveWinsCounts));
		ret.put(MT4Constants.PERFORMANCE_RPT_AVG_CONSECUTIVE_LOSSES, dfDefault.format((double)totalConsecutiveLosses/consecutiveLossesCounts));
		
		return ret;
	}

	public static void main(String[] args) throws Exception{
		double x = (double)6665.12345;
		System.out.println(x);
		DecimalFormat  dfDefault  =  new  DecimalFormat("0.00");
		System.out.println(dfDefault.format(x));
		
		double y = (double)0.7784;
		DecimalFormat dfPercent = new DecimalFormat("0.00%");
		System.out.println(dfPercent.format(y));
	}
	
}
