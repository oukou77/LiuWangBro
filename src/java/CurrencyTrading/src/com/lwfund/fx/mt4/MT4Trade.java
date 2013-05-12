package com.lwfund.fx.mt4;

import java.util.Date;

import com.mongodb.ReflectionDBObject;

public class MT4Trade extends ReflectionDBObject {
	private String AccountID;
	private int ticket;
	private double closePrice;
	private Date closeTime;
	private String comment;
	private double commission;
	private Date expiration;
	private double lots;
	private int magicNumber;
	private double openPrice;
	private Date openTime;
	private double profit;
	private double stopLoss;
	private double swap;
	private String symbol;
	private double takeProfit;
	private int orderType = -1;
	private boolean isClosed = false;
	private Date eodDate;

	public Object get_id() {
		return ticket;
	}

	public String getAlgoID() {
		String ret = null;
		if (this.magicNumber != 0) {
			ret = Integer.toString(this.magicNumber);
		} else {
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

	public double getRealProfit() {
		double ret = profit;
		if (commission < 0) {
			ret += commission;
		}
		if (swap < 0) {
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

	public double getClosePrice() {
		return closePrice;
	}

	public void setClosePrice(double closePrice) {
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

	public double getCommission() {
		return commission;
	}

	public void setCommission(double commission) {
		this.commission = commission;
	}

	public Date getExpiration() {
		return expiration;
	}

	public void setExpiration(Date expiration) {
		this.expiration = expiration;
	}

	public double getLots() {
		return lots;
	}

	public void setLots(double lots) {
		this.lots = lots;
	}

	public int getMagicNumber() {
		return magicNumber;
	}

	public void setMagicNumber(int magicNumber) {
		this.magicNumber = magicNumber;
	}

	public double getOpenPrice() {
		return openPrice;
	}

	public void setOpenPrice(double openPrice) {
		this.openPrice = openPrice;
	}

	public Date getOpenTime() {
		return openTime;
	}

	public void setOpenTime(Date openTime) {
		this.openTime = openTime;
	}

	public double getProfit() {
		return profit;
	}

	public void setProfit(double profit) {
		this.profit = profit;
	}

	public double getStopLoss() {
		return stopLoss;
	}

	public void setStopLoss(double stopLoss) {
		this.stopLoss = stopLoss;
	}

	public double getSwap() {
		return swap;
	}

	public void setSwap(double swap) {
		this.swap = swap;
	}

	public String getSymbol() {
		return symbol;
	}

	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}

	public double getTakeProfit() {
		return takeProfit;
	}

	public void setTakeProfit(double takeProfit) {
		this.takeProfit = takeProfit;
	}

	public int getOrderType() {
		return orderType;
	}

	public void setOrderType(int orderType) {
		this.orderType = orderType;
	}

	public boolean isDepositTrade() {
		return (this.orderType == MT4Constants.TRADE_ORDER_TYPE_BROKER_ACTION
				&& this.comment != null && (this.comment
				.contains(MT4Constants.FIXED_DEPOSIT_COMMENT) || this.comment
				.contains(MT4Constants.FIXED_DEPOSIT_COMMENT_FOREX)));
	}
}
