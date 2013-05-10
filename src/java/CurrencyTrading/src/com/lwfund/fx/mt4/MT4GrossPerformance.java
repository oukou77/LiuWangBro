package com.lwfund.fx.mt4;

import java.util.Date;

import com.mongodb.ReflectionDBObject;

public class MT4GrossPerformance extends ReflectionDBObject{

	private String algoID;
	private int magicNumber;
	private int periodType;
	private Date eodDate;
	
	//MT4 official
	private double profitFactor;
	private double expectedPayOff;
	private double absoluteDrawdown;
	private double maximalDrawdown;
	private double maximalDrawdownPercentage;
	private double relativeDrawdown;
	private double relativeDrawdownPercentage;
	private int totalTrades;
	private double shortPositionWon;
	private double shortPositionWonPercentage;
	private double longPositionWon;
	private double longPositionWonPercentage;
	private double profitTrades;
	private double profitTradesPercentage;
	private double lossTrades;
	private double lossTradesPercentage;
	private double largestProfitTrade;
	private double largestLossTrade;
	private double avgProfitTrade;
	private double avgLossTrade;
	private int maxConsecutiveWins;
	private double maxConsecutiveWinsProfit;
	private int maxConsecutiveLosses;
	private double maxConsecutiveLossesLoss;
	private int maxConsecutiveProfitWins;
	private double maxConsecutiveProfit;
	private int maxConsecutiveLossLosses;
	private double maxConsecutiveLoss;
	private int avgConsecutiveWins;
	private int avgConsecutiveLosses;
	
	//Additional
	private double sharpeRatio;
	private double ZScore;
	private double riskFreeRate;
	private double volatility;
	private double avgLots;
	private double avgPipsInJpy;
	private double defaultValueAtRisk;
	
	public String getAlgoID() {
		return algoID;
	}
	public void setAlgoID(String algoID) {
		this.algoID = algoID;
	}
	public int getMagicNumber() {
		return magicNumber;
	}
	public void setMagicNumber(int magicNumber) {
		this.magicNumber = magicNumber;
	}
	public int getPeriodType() {
		return periodType;
	}
	public void setPeriodType(int periodType) {
		this.periodType = periodType;
	}
	public double getProfitFactor() {
		return profitFactor;
	}
	public void setProfitFactor(double profitFactor) {
		this.profitFactor = profitFactor;
	}
	public double getExpectedPayOff() {
		return expectedPayOff;
	}
	public void setExpectedPayOff(double expectedPayOff) {
		this.expectedPayOff = expectedPayOff;
	}
	public double getAbsoluteDrawdown() {
		return absoluteDrawdown;
	}
	public void setAbsoluteDrawdown(double absoluteDrawdown) {
		this.absoluteDrawdown = absoluteDrawdown;
	}
	public double getMaximalDrawdown() {
		return maximalDrawdown;
	}
	public void setMaximalDrawdown(double maximalDrawdown) {
		this.maximalDrawdown = maximalDrawdown;
	}
	public double getMaximalDrawdownPercentage() {
		return maximalDrawdownPercentage;
	}
	public void setMaximalDrawdownPercentage(double maximalDrawdownPercentage) {
		this.maximalDrawdownPercentage = maximalDrawdownPercentage;
	}
	public double getRelativeDrawdown() {
		return relativeDrawdown;
	}
	public void setRelativeDrawdown(double relativeDrawdown) {
		this.relativeDrawdown = relativeDrawdown;
	}
	public double getRelativeDrawdownPercentage() {
		return relativeDrawdownPercentage;
	}
	public void setRelativeDrawdownPercentage(double relativeDrawdownPercentage) {
		this.relativeDrawdownPercentage = relativeDrawdownPercentage;
	}
	public int getTotalTrades() {
		return totalTrades;
	}
	public void setTotalTrades(int totalTrades) {
		this.totalTrades = totalTrades;
	}
	public double getShortPositionWon() {
		return shortPositionWon;
	}
	public void setShortPositionWon(double shortPositionWon) {
		this.shortPositionWon = shortPositionWon;
	}
	public double getShortPositionWonPercentage() {
		return shortPositionWonPercentage;
	}
	public void setShortPositionWonPercentage(double shortPositionWonPercentage) {
		this.shortPositionWonPercentage = shortPositionWonPercentage;
	}
	public double getLongPositionWon() {
		return longPositionWon;
	}
	public void setLongPositionWon(double longPositionWon) {
		this.longPositionWon = longPositionWon;
	}
	public double getLongPositionWonPercentage() {
		return longPositionWonPercentage;
	}
	public void setLongPositionWonPercentage(double longPositionWonPercentage) {
		this.longPositionWonPercentage = longPositionWonPercentage;
	}
	public double getProfitTrades() {
		return profitTrades;
	}
	public void setProfitTrades(double profitTrades) {
		this.profitTrades = profitTrades;
	}
	public double getProfitTradesPercentage() {
		return profitTradesPercentage;
	}
	public void setProfitTradesPercentage(double profitTradesPercentage) {
		this.profitTradesPercentage = profitTradesPercentage;
	}
	public double getLossTrades() {
		return lossTrades;
	}
	public void setLossTrades(double lossTrades) {
		this.lossTrades = lossTrades;
	}
	public double getLossTradesPercentage() {
		return lossTradesPercentage;
	}
	public void setLossTradesPercentage(double lossTradesPercentage) {
		this.lossTradesPercentage = lossTradesPercentage;
	}
	public double getLargestProfitTrade() {
		return largestProfitTrade;
	}
	public void setLargestProfitTrade(double largestProfitTrade) {
		this.largestProfitTrade = largestProfitTrade;
	}
	public double getLargestLossTrade() {
		return largestLossTrade;
	}
	public void setLargestLossTrade(double largestLossTrade) {
		this.largestLossTrade = largestLossTrade;
	}
	public double getAvgProfitTrade() {
		return avgProfitTrade;
	}
	public void setAvgProfitTrade(double avgProfitTrade) {
		this.avgProfitTrade = avgProfitTrade;
	}
	public double getAvgLossTrade() {
		return avgLossTrade;
	}
	public void setAvgLossTrade(double avgLossTrade) {
		this.avgLossTrade = avgLossTrade;
	}
	public int getMaxConsecutiveWins() {
		return maxConsecutiveWins;
	}
	public void setMaxConsecutiveWins(int maxConsecutiveWins) {
		this.maxConsecutiveWins = maxConsecutiveWins;
	}
	public double getMaxConsecutiveWinsProfit() {
		return maxConsecutiveWinsProfit;
	}
	public void setMaxConsecutiveWinsProfit(double maxConsecutiveWinsProfit) {
		this.maxConsecutiveWinsProfit = maxConsecutiveWinsProfit;
	}
	public int getMaxConsecutiveLosses() {
		return maxConsecutiveLosses;
	}
	public void setMaxConsecutiveLosses(int maxConsecutiveLosses) {
		this.maxConsecutiveLosses = maxConsecutiveLosses;
	}
	public double getMaxConsecutiveLossesLoss() {
		return maxConsecutiveLossesLoss;
	}
	public void setMaxConsecutiveLossesLoss(double maxConsecutiveLossesLoss) {
		this.maxConsecutiveLossesLoss = maxConsecutiveLossesLoss;
	}
	public int getMaxConsecutiveProfitWins() {
		return maxConsecutiveProfitWins;
	}
	public void setMaxConsecutiveProfitWins(int maxConsecutiveProfitWins) {
		this.maxConsecutiveProfitWins = maxConsecutiveProfitWins;
	}
	public double getMaxConsecutiveProfit() {
		return maxConsecutiveProfit;
	}
	public void setMaxConsecutiveProfit(double maxConsecutiveProfit) {
		this.maxConsecutiveProfit = maxConsecutiveProfit;
	}
	public int getMaxConsecutiveLossLosses() {
		return maxConsecutiveLossLosses;
	}
	public void setMaxConsecutiveLossLosses(int maxConsecutiveLossLosses) {
		this.maxConsecutiveLossLosses = maxConsecutiveLossLosses;
	}
	public double getMaxConsecutiveLoss() {
		return maxConsecutiveLoss;
	}
	public void setMaxConsecutiveLoss(double maxConsecutiveLoss) {
		this.maxConsecutiveLoss = maxConsecutiveLoss;
	}
	public int getAvgConsecutiveWins() {
		return avgConsecutiveWins;
	}
	public void setAvgConsecutiveWins(int avgConsecutiveWins) {
		this.avgConsecutiveWins = avgConsecutiveWins;
	}
	public int getAvgConsecutiveLosses() {
		return avgConsecutiveLosses;
	}
	public void setAvgConsecutiveLosses(int avgConsecutiveLosses) {
		this.avgConsecutiveLosses = avgConsecutiveLosses;
	}
	public double getSharpeRatio() {
		return sharpeRatio;
	}
	public void setSharpeRatio(double sharpeRatio) {
		this.sharpeRatio = sharpeRatio;
	}
	public double getZScore() {
		return ZScore;
	}
	public void setZScore(double zScore) {
		ZScore = zScore;
	}
	public double getRiskFreeRate() {
		return riskFreeRate;
	}
	public void setRiskFreeRate(double riskFreeRate) {
		this.riskFreeRate = riskFreeRate;
	}
	public double getVolatility() {
		return volatility;
	}
	public void setVolatility(double volatility) {
		this.volatility = volatility;
	}
	public double getAvgLots() {
		return avgLots;
	}
	public void setAvgLots(double avgLots) {
		this.avgLots = avgLots;
	}
	public double getAvgPipsInJpy() {
		return avgPipsInJpy;
	}
	public void setAvgPipsInJpy(double avgPipsInJpy) {
		this.avgPipsInJpy = avgPipsInJpy;
	}
	public double getDefaultValueAtRisk() {
		return defaultValueAtRisk;
	}
	public void setDefaultValueAtRisk(double defaultVar) {
		this.defaultValueAtRisk = defaultVar;
	}
	public Date getEodDate() {
		return eodDate;
	}
	public void setEodDate(Date eodDate) {
		this.eodDate = eodDate;
	}
	
}
