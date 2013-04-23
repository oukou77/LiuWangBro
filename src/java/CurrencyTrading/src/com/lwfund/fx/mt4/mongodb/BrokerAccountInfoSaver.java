package com.lwfund.fx.mt4.mongodb;

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

public class BrokerAccountInfoSaver {
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;
	
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
		}
	}
	
	public static void main(String args[]) throws Exception{
		List<DBObject> accounts = new ArrayList<>();
		MT4Account account1 = new MT4Account();
		account1.setAccountID("120768");
		account1.setBrokerName("ThinkForex");
		account1.setInitialDeposit((float)999546.0);
		account1.setLeverage(100);
		account1.setLocation("LDN");
		
		accounts.add(account1);
		
		MT4Account account2 = new MT4Account();
		account2.setAccountID("10952720");
		account2.setBrokerName("Forex.com");
		account2.setInitialDeposit((float)1000000.0);
		account2.setLeverage(25);
		account2.setLocation("TKO");
		
		accounts.add(account2);
		
		BrokerAccountInfoSaver saver = new BrokerAccountInfoSaver();
		saver.persistentBrokerAccountInfo(accounts);
	}
}
