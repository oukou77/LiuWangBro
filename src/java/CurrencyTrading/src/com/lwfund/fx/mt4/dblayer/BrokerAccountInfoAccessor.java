package com.lwfund.fx.mt4.dblayer;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import com.lwfund.fx.mt4.MT4Account;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.WriteResult;

public class BrokerAccountInfoAccessor {
	
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;
	private static List<MT4Account> accounts = null;
	
	public static List<MT4Account> getAccoutInfoList(){
		if(accounts != null){
			return accounts;
		}
		accounts = new ArrayList<MT4Account>();
		MT4Account account1 = new MT4Account();
		account1.setAccountID("120768");
		account1.setBrokerName("ThinkForex");
		account1.setInitialDeposit((float)999546.0);
		account1.setLeverage(100);
		account1.setLocation("LDN");
		account1.setCcy("JPY");
		account1.setTimeZone(MT4Constants.TIMEZONE_LONDON);
		accounts.add(account1);
		
		MT4Account account2 = new MT4Account();
		account2.setAccountID("10952720");
		account2.setBrokerName("Forex.com");
		account2.setInitialDeposit((float)1013394.0);
		account2.setLeverage(25);
		account2.setLocation("TKO");
		account2.setCcy("JPY");
		account2.setTimeZone(MT4Constants.TIMEZONE_TOKYO);
		
		accounts.add(account2);
		
		return accounts;
	}
	
	public void persistentBrokerAccountInfo(List<DBObject> brokerAccounts){
		if (brokerAccounts == null || brokerAccounts.size() == 0) {
			MT4Display.outToConsole("empty broker account list, stopping.....");
			return;
		}

		try {
			if (this.mongoInstance == null) {
				this.mongoInstance = new Mongo(
						MT4Constants.TEMP_DB_SERVER_ADDRESS,
						MT4Constants.TEMP_DB_SERVER_PORT);
			}

			if (this.mongoFXDB == null) {
				this.mongoFXDB = this.mongoInstance
						.getDB(MT4Constants.MONGODB_FX_DB_NAME);
			}

			DBCollection coll = this.mongoFXDB
					.getCollection(MT4Constants.MONGODB_FX_DB_BROKER_ACCOUNT_COLLECTION);
			WriteResult wr = coll.insert(brokerAccounts);

			MT4Display.outToConsole("insert is done. [" + wr.getN()
					+ "] rows affected!");

		} catch (UnknownHostException ex) {
			ex.printStackTrace();
		} catch (MongoException ex) {
			ex.printStackTrace();
		} finally{
			this.mongoInstance.close();
		}
	}
	
	public static void main(String args[]) throws Exception{
		List<DBObject> accounts = new ArrayList<DBObject>();
		MT4Account account1 = new MT4Account();
		account1.setAccountID("120768");
		account1.setBrokerName("ThinkForex");
		account1.setInitialDeposit((float)999546.0);
		account1.setLeverage(100);
		account1.setLocation("LDN");
		account1.setCcy("JPY");
		account1.setTimeZone(MT4Constants.TIMEZONE_LONDON);
		accounts.add(account1);
		
		MT4Account account2 = new MT4Account();
		account2.setAccountID("10952720");
		account2.setBrokerName("Forex.com");
		account2.setInitialDeposit((float)1013394.0);
		account2.setLeverage(25);
		account2.setLocation("TKO");
		account2.setCcy("JPY");
		account2.setTimeZone(MT4Constants.TIMEZONE_TOKYO);
		
		accounts.add(account2);
		
		BrokerAccountInfoAccessor saver = new BrokerAccountInfoAccessor();
		saver.persistentBrokerAccountInfo(accounts);
	}
}
