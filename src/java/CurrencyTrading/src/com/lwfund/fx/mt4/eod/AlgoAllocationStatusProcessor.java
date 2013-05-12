package com.lwfund.fx.mt4.eod;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import com.lwfund.fx.mt4.MT4Account;
import com.lwfund.fx.mt4.MT4Algorithm;
import com.lwfund.fx.mt4.MT4AllocationStatus;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.MT4Trade;
import com.lwfund.fx.mt4.calculators.AlgoAllocationStatusCalculator;
import com.lwfund.fx.mt4.calculators.PortfolioAccountAllocStatusCalculator;
import com.lwfund.fx.mt4.dblayer.AlgorithmAccessor;
import com.lwfund.fx.mt4.dblayer.AllocationStatusAccessor;
import com.lwfund.fx.mt4.dblayer.BrokerAccountInfoAccessor;
import com.lwfund.fx.mt4.dblayer.TradeAccessor;
import com.lwfund.fx.mt4.util.MT4Display;
import com.lwfund.fx.mt4.util.MT4EODUtil;

import com.mongodb.DBObject;


public class AlgoAllocationStatusProcessor {

	private static final SimpleDateFormat sdf = new SimpleDateFormat(
			"yyyy_MM_dd");
	private AllocationStatusAccessor asa;
	private TradeAccessor ta;

	public AlgoAllocationStatusProcessor() {
		sdf.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		asa = new AllocationStatusAccessor();
		ta = new TradeAccessor();
	}

	public void processForHoldingPeriod(String startDateStr, String toDateStr)
			throws Exception {
		Date fromDate = sdf.parse(startDateStr);
		Date toDate = sdf.parse(toDateStr);

		if (toDate.before(fromDate)) {
			MT4Display.outToConsole("toDate is before fromDate");
			return;
		}

		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(fromDate);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);

		Date cleanStartDate = cal.getTime();

		cal.setTime(toDate);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);

		Date cleanToDate = cal.getTime();

		// clean up(remove) the target data first
		asa.removeAlgoAllocationStatusForDateRange(cleanStartDate, cleanToDate);

		this.processForDateRange(startDateStr, toDateStr, true);
	}

	public void processForDateRange(String fromDateStr, String toDateStr,
			boolean isForceFlag) throws Exception {

		// clean up the dates
		Date fromDate = sdf.parse(fromDateStr);
		Date toDate = sdf.parse(toDateStr);

		Map<String, MT4Algorithm> allAlgos = AlgorithmAccessor.getAllAlgos();

		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(fromDate);
		Date currentDate = fromDate;

		// Monday needs to be adjusted to Sat's EOD
		if (2 == cal.get(Calendar.DAY_OF_WEEK)) {
			cal.add(Calendar.DAY_OF_MONTH, -2);
		} else {
			cal.add(Calendar.DAY_OF_MONTH, -1);
		}

		Date priorDate = cal.getTime();
		System.out.println("priordate " + priorDate);
		cal.setTime(fromDate);

		// first check if previous date's status is out there
		AllocationStatusAccessor asa = new AllocationStatusAccessor();

		if (!isForceFlag) {
			List<MT4AllocationStatus> previousAllocationStatus = asa
					.getAlgoAllocationStatusByDate(priorDate);
			if (previousAllocationStatus == null
					|| previousAllocationStatus.isEmpty()) {
				MT4Display.outToConsole("previous allocation status for ["
						+ priorDate + "] is empty! please fill in it first");
				return;
			}
		}

		Map<String, Date>adjustedEOD = MT4EODUtil.getEODDateRange(fromDate);
		Date adjustedFromDate = adjustedEOD.get(MT4Constants.EOD_FROM_DATE);
		
		adjustedEOD = MT4EODUtil.getEODDateRange(toDate);
		Date adjustedToDate = adjustedEOD.get(MT4Constants.EOD_TO_DATE);
		
		List<MT4Trade> trades = 
				ta.getAllTradesByDateRange(adjustedFromDate, adjustedToDate, false);

		AlgoAllocationStatusCalculator aasc = new AlgoAllocationStatusCalculator();

		List<MT4AllocationStatus> allocations = null;
		List<DBObject> algoAllocations = new ArrayList<DBObject>();

		while (toDate.after(currentDate) || toDate.equals(currentDate)) {
			for (Iterator<String> iterator = allAlgos.keySet().iterator(); iterator
					.hasNext();) {
				MT4Algorithm currentAlgo = allAlgos.get(iterator.next());

				allocations = asa.getAlgoAllocationStatusByAlgoIDAndDate(
						currentAlgo.getAlgoID(), priorDate);

				double balance = 0;
				double equity = 0;
				double margin = 0;
				double freeMargin = 0;

				if (allocations != null && allocations.size() > 0) {
					balance = allocations.get(0).getBalance();
					equity = allocations.get(0).getEquity();
					margin = allocations.get(0).getMargin();
					freeMargin = allocations.get(0).getFreeMargin();
				} else {
					if (!isForceFlag) {
						MT4Display
								.outToConsole("Allocation status for ["
										+ currentAlgo.getAlgoID()
										+ "] date ["
										+ priorDate
										+ "] is missing, skipping this algo processing now, please fill in !!!!!!!");
						continue;
					}
				}

				if (balance == 0 && equity == 0) {
					balance = currentAlgo.getAllocation();
					equity = balance;
					margin = balance;
					freeMargin = balance;
				}

				Map<String, String> parameters = new HashMap<String, String>();
				parameters.put(MT4Constants.ALGORITHM_ID,
						currentAlgo.getAlgoID());
				parameters.put(MT4Constants.EOD_DATE, sdf.format(currentDate));
				parameters.put(MT4Constants.ALGORITHM_BALANCE,
						Double.toString(balance));
				parameters.put(MT4Constants.ALGORITHM_EQUITY,
						Double.toString(equity));
				parameters.put(MT4Constants.ALGORITHM_FREE_MARGIN,
						Double.toString(freeMargin));
				parameters.put(MT4Constants.ALGORITHM_MARGIN,
						Double.toString(margin));

				aasc.init(parameters);
				for (MT4Trade currentTrade : trades) {
					aasc.process(currentTrade);
				}

				Map<String, String> calculationResult = aasc.calculate();
				if (calculationResult != null && !calculationResult.isEmpty()) {
					MT4AllocationStatus algoAllocation = new MT4AllocationStatus();
					balance = Double.parseDouble(calculationResult
							.get(MT4Constants.ALGORITHM_BALANCE));
					equity = Double.parseDouble(calculationResult
							.get(MT4Constants.ALGORITHM_EQUITY));
					margin = Double.parseDouble(calculationResult
							.get(MT4Constants.ALGORITHM_MARGIN));

					algoAllocation
							.setAccountID(MT4Constants.ALLOCATION_NON_ACCOUNT_FLAG);
					algoAllocation.setAlgoID(currentAlgo.getAlgoID());
					algoAllocation.setBalance(balance);
					algoAllocation.setEodDate(currentDate);
					algoAllocation.setEquity(equity);
					algoAllocation.setFreeMargin(freeMargin);
					algoAllocation.setMargin(margin);
					algoAllocation.setProfit(balance
							- currentAlgo.getAllocation());

					asa.persistent(algoAllocation);
					algoAllocations.add(algoAllocation);
				}
				aasc.deinit();
			}
			priorDate = currentDate;
			cal.add(Calendar.DAY_OF_MONTH, 1);
			currentDate = cal.getTime();
		}

		if (algoAllocations.size() > 0) {
			System.out.println(algoAllocations.size());
		}
	}

	public void processForDate(String eodDateStr, boolean isForceFlag)
			throws Exception {
		this.processForDateRange(eodDateStr, eodDateStr, isForceFlag);
	}

	public void processAccountForHoldingPeriod(String fromDateStr, String toDateStr) throws Exception{
		// clean up the dates
		Date fromDate = sdf.parse(fromDateStr);
		Date toDate = sdf.parse(toDateStr);

		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeZone.getTimeZone(MT4Constants.TIMEZONE_HONGKONG));
		cal.setTime(fromDate);
		Date currentDate = fromDate;

		// Monday needs to be adjusted to Sat's EOD
		if (2 == cal.get(Calendar.DAY_OF_WEEK)) {
			cal.add(Calendar.DAY_OF_MONTH, -2);
		} else {
			cal.add(Calendar.DAY_OF_MONTH, -1);
		}

		Date priorDate = cal.getTime();
		
		System.out.println("priordate " + priorDate);
		cal.setTime(fromDate);
		
		Map<String, Date>adjustedEOD = MT4EODUtil.getEODDateRange(fromDate);
		Date adjustedFromDate = adjustedEOD.get(MT4Constants.EOD_FROM_DATE);
		
		adjustedEOD = MT4EODUtil.getEODDateRange(toDate);
		Date adjustedToDate = adjustedEOD.get(MT4Constants.EOD_TO_DATE);
		
		List<MT4Trade> trades = 
				ta.getAllTradesByDateRange(adjustedFromDate, adjustedToDate, true);
		
		System.out.println(trades.size());
		//first remove all target overlap
		asa.removeAccountAllocationStatusForDateRange(fromDate, toDate);
		
		List<MT4Account> accounts = BrokerAccountInfoAccessor.getAccoutInfoList();
		
		List<MT4AllocationStatus> previousAllocations = null;
		List<DBObject> accountAllocations = new ArrayList<DBObject>();
		
		PortfolioAccountAllocStatusCalculator oaac = new PortfolioAccountAllocStatusCalculator();
		
		while(toDate.after(currentDate) || toDate.equals(currentDate)) {
			for (MT4Account mt4Account : accounts) {
				
				previousAllocations = asa.getAccountAllocationStatusByAccountAndDate(
						mt4Account.getAccountID(), priorDate);

				double balance = 0;
				double equity = 0;
				double margin = 0;
				double freeMargin = 0;
				double deposit = 0;

				if (previousAllocations != null && previousAllocations.size() > 0) {
					balance = previousAllocations.get(0).getBalance();
					equity = previousAllocations.get(0).getEquity();
					margin = previousAllocations.get(0).getMargin();
					freeMargin = previousAllocations.get(0).getFreeMargin();
					deposit = previousAllocations.get(0).getDeposit();
				}else{
					balance = 0;
					deposit = 0;
					equity = balance;
					margin = balance;
					freeMargin = balance;
				}

				Map<String, String> parameters = new HashMap<String, String>();
				parameters.put(MT4Constants.ACCOUNT_ID,
						mt4Account.getAccountID());
				parameters.put(MT4Constants.EOD_DATE, sdf.format(currentDate));
				parameters.put(MT4Constants.ACCOUNT_BALANCE,
						Double.toString(balance));
				parameters.put(MT4Constants.ACCOUNT_EQUITY,
						Double.toString(equity));
				parameters.put(MT4Constants.ACCOUNT_FREE_MARGIN,
						Double.toString(freeMargin));
				parameters.put(MT4Constants.ACCOUNT_MARGIN,
						Double.toString(margin));

				oaac.init(parameters);

				for (MT4Trade currentTrade : trades) {
					oaac.process(currentTrade);
				}

				Map<String, String> calculationResult = oaac.calculate();
				if (calculationResult != null && !calculationResult.isEmpty()) {
					MT4AllocationStatus accountAllocation = new MT4AllocationStatus();
					balance = Double.parseDouble(calculationResult
							.get(MT4Constants.ACCOUNT_BALANCE));
					equity = Double.parseDouble(calculationResult
							.get(MT4Constants.ACCOUNT_EQUITY));
					margin = Double.parseDouble(calculationResult
							.get(MT4Constants.ACCOUNT_MARGIN));
					deposit += Double.parseDouble(calculationResult.get(MT4Constants.ACCOUNT_DEPOSIT));
					
					accountAllocation
							.setAccountID(mt4Account.getAccountID());
					accountAllocation.setAlgoID(MT4Constants.ALLOCATION_NON_ALGO_FLAG);
					accountAllocation.setBalance(balance);
					accountAllocation.setEodDate(currentDate);
					accountAllocation.setEquity(equity);
					accountAllocation.setFreeMargin(freeMargin);
					accountAllocation.setMargin(margin);
					accountAllocation.setDeposit(deposit);
					accountAllocation.setProfit(balance - deposit);

					asa.persistent(accountAllocation);
					accountAllocations.add(accountAllocation);
				}
				oaac.deinit();
				
			}

			priorDate = currentDate;
			cal.add(Calendar.DAY_OF_MONTH, 1);
			currentDate = cal.getTime();
		}
	}
	
	public static void main(String args[]) throws Exception {
		if (args.length < 1) {
			MT4Display
					.outToConsole("Usage: java AlgoAllocationStatusCumulator fromDate toDate");
			return;
		}

		AlgoAllocationStatusProcessor asa = new AlgoAllocationStatusProcessor();
		asa.processForHoldingPeriod(args[0], args[1]);
		asa.processAccountForHoldingPeriod(args[0], args[1]);
	}
}
