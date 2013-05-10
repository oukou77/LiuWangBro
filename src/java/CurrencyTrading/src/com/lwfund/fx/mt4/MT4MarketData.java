package com.lwfund.fx.mt4;

import com.mongodb.ReflectionDBObject;

public class MT4MarketData extends ReflectionDBObject {

	private String accountID;
	private String symbol;
	private String dateStr;
	private String hourMinStr;
	private int barPeriodType;
	private double open;
	private double close;
	private double high;
	private double low;
	private double volume;
	
	public String getAccountID() {
		return accountID;
	}
	public void setAccountID(String accountID) {
		this.accountID = accountID;
	}
	public String getSymbol() {
		return symbol;
	}
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}
	public String getDateStr() {
		return dateStr;
	}
	public void setDateStr(String dateStr) {
		this.dateStr = dateStr;
	}
	public String getHourMinStr() {
		return hourMinStr;
	}
	public void setHourMinStr(String hourMinStr) {
		this.hourMinStr = hourMinStr;
	}
	public int getBarPeriodType() {
		return barPeriodType;
	}
	public void setBarPeriodType(int barPeriodType) {
		this.barPeriodType = barPeriodType;
	}
	public double getOpen() {
		return open;
	}
	public void setOpen(double open) {
		this.open = open;
	}
	public double getClose() {
		return close;
	}
	public void setClose(double close) {
		this.close = close;
	}
	public double getHigh() {
		return high;
	}
	public void setHigh(double high) {
		this.high = high;
	}
	public double getLow() {
		return low;
	}
	public void setLow(double low) {
		this.low = low;
	}
	public double getVolume() {
		return volume;
	}
	public void setVolume(double volume) {
		this.volume = volume;
	}
	
	
	
}
