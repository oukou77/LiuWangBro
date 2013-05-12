package com.lwfund.fx.mt4;

import java.util.Date;

import com.mongodb.ReflectionDBObject;

public class MT4AllocationStatus extends ReflectionDBObject{

	private String accountID;
	private String algoID;
	private double balance;
	private double profit;
	private double equity;
	private double freeMargin;
	private double margin;
	private Date eodDate;
	private double deposit;
	
	public String getAccountID() {
		return accountID;
	}
	public void setAccountID(String accountID) {
		this.accountID = accountID;
	}
	public String getAlgoID() {
		return algoID;
	}
	public void setAlgoID(String algoID) {
		this.algoID = algoID;
	}
	public double getBalance() {
		return balance;
	}
	public void setBalance(double balance) {
		this.balance = balance;
	}
	public double getProfit() {
		return profit;
	}
	public void setProfit(double profit) {
		this.profit = profit;
	}
	public double getEquity() {
		return equity;
	}
	public void setEquity(double equity) {
		this.equity = equity;
	}
	public double getFreeMargin() {
		return freeMargin;
	}
	public void setFreeMargin(double freeMargin) {
		this.freeMargin = freeMargin;
	}
	public double getMargin() {
		return margin;
	}
	public void setMargin(double margin) {
		this.margin = margin;
	}
	public Date getEodDate() {
		return eodDate;
	}
	public void setEodDate(Date eodDate) {
		this.eodDate = eodDate;
	}
	public double getDeposit() {
		return deposit;
	}
	public void setDeposit(double deposit) {
		this.deposit = deposit;
	}
	
}
