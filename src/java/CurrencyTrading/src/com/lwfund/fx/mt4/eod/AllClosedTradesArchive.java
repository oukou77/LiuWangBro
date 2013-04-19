package com.lwfund.fx.mt4.eod;

import java.io.FileReader;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;

public class AllClosedTradesArchive {

	public static void main(String args[]) throws Exception {
		if (args.length < 1) {
			System.out.println("Usage: java AllClosedTradesArchive <csv_file>");
			return;
		}

		Iterable<CSVRecord> parser = CSVFormat.DEFAULT.toBuilder().withHeader()
				.parse(new FileReader(args[0]));
		
		int recordNumber = 0;
		
		for (CSVRecord record : parser) {
			System.out.println(record.get("close time"));
		}
		
		if(recordNumber == 0){
			System.out.println("Empty records!");
			return;
		}

		// CSVParser parser = new CSVParser(new FileReader(args[0]),
		// CSVStrategy.EXCEL_STRATEGY);
		// String[] values = parser.getLine();
		// while (values != null) {
		// printValues(parser.getLineNumber(), values);
		// values = parser.getLine();
		// }
	}

	private static void printValues(int lineNumber, String[] as) {
		System.out.println("Line " + lineNumber + " has " + as.length
				+ " values:");
		for (String s : as) {
			System.out.println("\t|" + s + "|");
		}
		System.out.println();
	}
}
