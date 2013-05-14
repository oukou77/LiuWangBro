package com.lwfund.fx.mt4;

import java.util.Date;

import com.mongodb.ReflectionDBObject;

public class MT4GrossPerformance extends ReflectionDBObject{

	private String algoID;
	private int magicNumber;
	private int periodType;
	private Date eodDate;
	private String accountID;
	private String portfolioID;
	
	//MT4 official
	private double profitFactor;
	private double expectedPayOff;
	private double absoluteDrawdown;
	private double maximalDrawdown;
	private double maximalDrawdownPercentage;
	private double relativeDrawdown;
	private double relativeDrawdownPercentage;
	private int totalTrades;
	private int shortPositionWon;
	private double shortPositionWonPercentage;
	private int longPositionWon;
	private double longPositionWonPercentage;
	private int profitTrades;
	private double profitTradesPercentage;
	private int lossTrades;
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
	private double totalPipsInJPY;
	private double avgProfitPipsInJPY;
	private double avgLossPipsInJPY;
	private double balance;
	private double deposit;
	
	//Additional
	private double sharpeRatio;
	private double ZScore;
	private double riskFreeRate;
	private double hprvolatility;
	private double avgLots;
	private double defaultValueAtRisk;
	private double hpr;
	private double profitVolatility;
	
	public double getProfitVolatility() {
		return profitVolatility;
	}
	public void setProfitVolatility(double profitVolatility) {
		this.profitVolatility = profitVolatility;
	}
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
	public int getShortPositionWon() {
		return shortPositionWon;
	}
	public void setShortPositionWon(int shortPositionWon) {
		this.shortPositionWon = shortPositionWon;
	}
	public double getShortPositionWonPercentage() {
		return shortPositionWonPercentage;
	}
	public void setShortPositionWonPercentage(double shortPositionWonPercentage) {
		this.shortPositionWonPercentage = shortPositionWonPercentage;
	}
	public int getLongPositionWon() {
		return longPositionWon;
	}
	public void setLongPositionWon(int longPositionWon) {
		this.longPositionWon = longPositionWon;
	}
	public double getLongPositionWonPercentage() {
		return longPositionWonPercentage;
	}
	public void setLongPositionWonPercentage(double longPositionWonPercentage) {
		this.longPositionWonPercentage = longPositionWonPercentage;
	}
	public int getProfitTrades() {
		return profitTrades;
	}
	public void setProfitTrades(int profitTrades) {
		this.profitTrades = profitTrades;
	}
	public double getProfitTradesPercentage() {
		return profitTradesPercentage;
	}
	public void setProfitTradesPercentage(double profitTradesPercentage) {
		this.profitTradesPercentage = profitTradesPercentage;
	}
	public int getLossTrades() {
		return lossTrades;
	}
	public void setLossTrades(int lossTrades) {
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
	public double getHprVolatility() {
		return hprvolatility;
	}
	public void setHprVolatility(double hprvolatility) {
		this.hprvolatility = hprvolatility;
	}
	public double getAvgLots() {
		return avgLots;
	}
	public void setAvgLots(double avgLots) {
		this.avgLots = avgLots;
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
	public double getTotalPipsInJPY() {
		return totalPipsInJPY;
	}
	public void setTotalPipsInJPY(double totalPipsInJPY) {
		this.totalPipsInJPY = totalPipsInJPY;
	}
	public double getAvgProfitPipsInJPY() {
		return avgProfitPipsInJPY;
	}
	public void setAvgProfitPipsInJPY(double avgProfitPipsInJPY) {
		this.avgProfitPipsInJPY = avgProfitPipsInJPY;
	}
	public double getAvgLossPipsInJPY() {
		return avgLossPipsInJPY;
	}
	public void setAvgLossPipsInJPY(double avgLossPipsInJPY) {
		this.avgLossPipsInJPY = avgLossPipsInJPY;
	}
	public String getAccountID() {
		return accountID;
	}
	public void setAccountID(String accountID) {
		this.accountID = accountID;
	}
	public String getPortfolioID() {
		return portfolioID;
	}
	public void setPortfolioID(String portfolioID) {
		this.portfolioID = portfolioID;
	}
	public double getBalance() {
		return balance;
	}
	public void setBalance(double balance) {
		this.balance = balance;
	}
	public double getDeposit() {
		return deposit;
	}
	public void setDeposit(double deposit) {
		this.deposit = deposit;
	}
	public double getHpr() {
		return hpr;
	}
	public void setHpr(double hpr) {
		this.hpr = hpr;
	}
}
