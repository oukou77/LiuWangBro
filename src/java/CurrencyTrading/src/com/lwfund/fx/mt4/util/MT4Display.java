package com.lwfund.fx.mt4.util;

import java.util.TimeZone;

public class MT4Display {
	private MT4Display(){};
	
	public static void outToConsole(String msg){
		System.out.println(msg);
	}
	
	public static void outToConsole(int number){
		System.out.println(number);
	}
	
	public static void outToConsole(double number){
		System.out.println(number);
	}

	public static void main(String args[])throws Exception{
		for (int i = 0; i < TimeZone.getAvailableIDs().length; i++) {
			System.out.println(TimeZone.getAvailableIDs()[i]);
		}
	}
}
