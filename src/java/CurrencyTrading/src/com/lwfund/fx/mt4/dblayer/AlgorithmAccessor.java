package com.lwfund.fx.mt4.dblayer;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.lwfund.fx.mt4.MT4Algorithm;
import com.lwfund.fx.mt4.MT4Constants;
import com.lwfund.fx.mt4.util.MT4Display;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.WriteResult;

public class AlgorithmAccessor {
	private Mongo mongoInstance = null;
	private DB mongoFXDB = null;
	
	public static Map<String, MT4Algorithm> getAllAlgos(){
		Map<String, MT4Algorithm> ret = new HashMap<String, MT4Algorithm>();
		MT4Algorithm mainAlgo = new MT4Algorithm();
		mainAlgo.setAlgoID("30001");
		mainAlgo.setAlgoName("main");
		mainAlgo.setAllocation(2000000);
		mainAlgo.addAppliedAccountID("120768");
		mainAlgo.addAppliedAccountID("10952720");
		mainAlgo.setLeverage(25);
		mainAlgo.setMagicNumber(30001);
		ret.put(mainAlgo.getAlgoID(), mainAlgo);
		
		MT4Algorithm handAlgo = new MT4Algorithm();
		handAlgo.setAlgoID("0");
		handAlgo.setAlgoName("hand");
		handAlgo.setAllocation(1000000);
		handAlgo.addAppliedAccountID("120768");
		handAlgo.addAppliedAccountID("10952720");
		handAlgo.setLeverage(25);
		handAlgo.setMagicNumber(0);		
		ret.put(handAlgo.getAlgoID(), handAlgo);
		
		MT4Algorithm minorAlgo = new MT4Algorithm();
		minorAlgo.setAlgoID("202100");
		minorAlgo.setAlgoName("minor");
		minorAlgo.setAllocation(100000);
		minorAlgo.addAppliedAccountID("120768");
		minorAlgo.addAppliedAccountID("10952720");
		minorAlgo.setLeverage(25);
		minorAlgo.setMagicNumber(202100);	
		ret.put(minorAlgo.getAlgoID(), minorAlgo);
		
		MT4Algorithm fakeAlgo = new MT4Algorithm();
		fakeAlgo.setAlgoID("5124");
		fakeAlgo.setAlgoName("fake");
		fakeAlgo.setAllocation(100000);
		fakeAlgo.addAppliedAccountID("120768");
		fakeAlgo.addAppliedAccountID("10952720");
		fakeAlgo.setLeverage(25);
		fakeAlgo.setMagicNumber(5124);	
		ret.put(fakeAlgo.getAlgoID(), fakeAlgo);
		
		return ret;
	}
	
	public void persistentAlgorithms(List<DBObject> algorithms) throws Exception{
		if (algorithms == null || algorithms.size() == 0) {
			MT4Display.outToConsole("empty algorithm list, stopping.....");
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
					.getCollection(MT4Constants.MONGODB_FX_DB_ALGORITHMS_COLLECTION);
			WriteResult wr = coll.insert(algorithms);

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
		Map<String, MT4Algorithm> algos = AlgorithmAccessor.getAllAlgos();
		AlgorithmAccessor aa = new AlgorithmAccessor();
		List<DBObject> algoList = new ArrayList<DBObject>(algos.values());
		aa.persistentAlgorithms(algoList);
	}
}
