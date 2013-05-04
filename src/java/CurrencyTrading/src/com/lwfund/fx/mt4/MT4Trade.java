package com.lwfund.fx.mt4;

import java.util.Date;

import com.mongodb.ReflectionDBObject;

public class MT4Trade extends ReflectionDBObject {
	private String AccountID;
	private int ticket;
	private float closePrice;
	private Date closeTime;
	private String comment;
	private float commission;
	private Date expiration;
	private float lots;
	private int magicNumber;
	private float openPrice;
	private Date openTime;
	private float profit;
	private float stopLoss;
	private float swap;
	private String symbol;
	private float takeProfit;
	private byte orderType = -1;
	private boolean isClosed = false;
	private Date eodDate;
//	private int _id;
	
	public Object get_id() {
		return ticket;
	}

	public String getAlgoID(){
		String ret = null;
		if(this.magicNumber != 0){
			ret = Integer.toString(this.magicNumber);
		}else{
			ret = MT4Constants.ALLOCATION_NON_ALGO_FLAG;
		}
		return ret; 
	}
	
	public boolean isClosed() {
		return isClosed;
	}

	public void setClosed(boolean isClosed) {
		this.isClosed = isClosed;
	}

	public Date getEodDate() {
		return eodDate;
	}

	public void setEodDate(Date eodDate) {
		this.eodDate = eodDate;
	}

	public float getRealProfit() {
		float ret = profit;
		if(commission < 0){
			ret += commission;
		}
		if(swap < 0){
			ret += swap;
		}
		return ret;
	}
	
	public String getAccountID() {
		return AccountID;
	}

	public void setAccountID(String accountID) {
		AccountID = accountID;
	}

	public int getTicket() {
		return ticket;
	}
	public void setTicket(int ticket) {
		this.ticket = ticket;
	}
	public float getClosePrice() {
		return closePrice;
	}
	public void setClosePrice(float closePrice) {
		this.closePrice = closePrice;
	}
	public Date getCloseTime() {
		return closeTime;
	}
	public void setCloseTime(Date closeTime) {
		this.closeTime = closeTime;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public float getCommission() {
		return commission;
	}
	public void setCommission(float commission) {
		this.commission = commission;
	}
	public Date getExpiration() {
		return expiration;
	}
	public void setExpiration(Date expiration) {
		this.expiration = expiration;
	}
	public float getLots() {
		return lots;
	}
	public void setLots(float lots) {
		this.lots = lots;
	}
	public int getMagicNumber() {
		return magicNumber;
	}
	public void setMagicNumber(int magicNumber) {
		this.magicNumber = magicNumber;
	}
	public float getOpenPrice() {
		return openPrice;
	}
	public void setOpenPrice(float openPrice) {
		this.openPrice = openPrice;
	}
	public Date getOpenTime() {
		return openTime;
	}
	public void setOpenTime(Date openTime) {
		this.openTime = openTime;
	}
	public float getProfit(){
		return profit;
	}
	public void setProfit(float profit) {
		this.profit = profit;
	}
	public float getStopLoss() {
		return stopLoss;
	}
	public void setStopLoss(float stopLoss) {
		this.stopLoss = stopLoss;
	}
	public float getSwap() {
		return swap;
	}
	public void setSwap(float swap) {
		this.swap = swap;
	}
	public String getSymbol() {
		return symbol;
	}
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}
	public float getTakeProfit() {
		return takeProfit;
	}
	public void setTakeProfit(float takeProfit) {
		this.takeProfit = takeProfit;
	}
	public byte getOrderType() {
		return orderType;
	}
	public void setOrderType(byte orderType) {
		this.orderType = orderType;
	}
}
