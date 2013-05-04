package com.lwfund.fx.mt4;

import java.util.ArrayList;
import java.util.List;

import com.mongodb.ReflectionDBObject;

public class MT4Algorithm extends ReflectionDBObject {
	private String algoID;
	private double allocation;
	private double leverage;
	private List<String> appliedAccountIDs;
	private int magicNumber;
	private String algoName;
	
	public Object get_id() {
		return algoID;
	}

	public String getAlgoID() {
		return algoID;
	}

	public void setAlgoID(String algoID) {
		this.algoID = algoID;
	}

	public double getAllocation() {
		return allocation;
	}

	public void setAllocation(double allocation) {
		this.allocation = allocation;
	}

	public double getLeverage() {
		return leverage;
	}

	public void setLeverage(double leverage) {
		this.leverage = leverage;
	}

	public List<String> getAppliedAccountIDs() {
		return appliedAccountIDs;
	}

	public void addAppliedAccountID(String accountID){
		if(this.appliedAccountIDs == null){
			this.appliedAccountIDs = new ArrayList<String>();
		}
		this.appliedAccountIDs.add(accountID);
	}
	
	public void setAppliedAccountIDs(List<String> appliedAccountIDs) {
		this.appliedAccountIDs = appliedAccountIDs;
	}

	public int getMagicNumber() {
		return magicNumber;
	}

	public void setMagicNumber(int magicNumber) {
		this.magicNumber = magicNumber;
	}

	public String getAlgoName() {
		return algoName;
	}

	public void setAlgoName(String algoName) {
		this.algoName = algoName;
	}
	
}
