package com.lwfund.fx.mt4;

import java.util.Date;

import com.mongodb.ReflectionDBObject;

public class MT4ReferencedRate extends ReflectionDBObject{
	private String name;
	private String type;
	private double rate;
	private Date time;
	private String source;
	private int periodInDays;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public double getRate() {
		return rate;
	}
	public void setRate(double rate) {
		this.rate = rate;
	}
	public Date getTime() {
		return time;
	}
	public void setTime(Date time) {
		this.time = time;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public int getPeriodInDays() {
		return periodInDays;
	}
	public void setPeriodInDays(int periodInDays) {
		this.periodInDays = periodInDays;
	}
}
