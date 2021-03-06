package com.lwfund.fx.mt4;

import com.mongodb.ReflectionDBObject;

public class MT4Account extends ReflectionDBObject{
	private String brokerName;
	private String location;
	private String accountID;
	private float initialDeposit;
	private int leverage;
	private String ccy;
	private String timeZone;
	
	public String getCcy() {
		return ccy;
	}
	public void setCcy(String ccy) {
		this.ccy = ccy;
	}
	public String getTimeZone() {
		return timeZone;
	}
	public void setTimeZone(String timeZone) {
		this.timeZone = timeZone;
	}
	public String getBrokerName() {
		return brokerName;
	}
	public void setBrokerName(String brokerName) {
		this.brokerName = brokerName;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getAccountID() {
		return accountID;
	}
	public void setAccountID(String accountID) {
		this.accountID = accountID;
	}
	public float getInitialDeposit() {
		return initialDeposit;
	}
	public void setInitialDeposit(float initialDeposit) {
		this.initialDeposit = initialDeposit;
	}
	public int getLeverage() {
		return leverage;
	}
	public void setLeverage(int leverage) {
		this.leverage = leverage;
	}
	
	
}
