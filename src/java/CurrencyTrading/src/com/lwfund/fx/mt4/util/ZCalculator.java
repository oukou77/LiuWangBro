package com.lwfund.fx.mt4.util;

public class ZCalculator {

	private double Znak(double Val) {
		double res = 0;
		// ----
		if (Val < 0)
			res = -1;
		if (Val >= 0)
			res = 1;
		// ----
		return res;
	}

	public double calculate(double[] values) {
		double res = 0;
		int w = 0;
		int l = 0;
		int size = values.length;

		if (size == 0) {
			System.out.println("empty values return 0");
			return res;
		}

		int series[] = new int[size];

		for (int i = 0; i < size; i++) {
			if (i == 0){
				series[i] = 1;
			}else{
				if (Znak(values[i]) * Znak(values[i - 1]) < 0) {
					series[i] = series[i - 1] + 1;
				} else {
					series[i] = series[i - 1];
				}
			}
			if (values[i] >= 0)
				w++;
			if (values[i] < 0)
				l++;
		}

		int r = series[size - 1];
		int x = 0;
		if (l > 0 && w > 0) {
			x = 2 * w * l;
//			System.out.println("size is [" + size + "]");
//			System.out.println("r is [" + r + "]");
//			System.out.println("w is [" + w + "]");
//			System.out.println("l is [" + l + "]");
//			System.out.println("upper is [" + (size * (r - 0.5) - x) + "]");
//			System.out.println("lower is [" + ((x * (x - size)) / (size - 1)) + "]");
			res = (size * (r - 0.5) - x)
					/ Math.sqrt((x * (x - size)) / (size - 1));
		} else {
			if (l == 0)
				res = 100000;
			else
				res = -100000;
			System.out.println("no loss or no profit trades");
		}
		return (res);
	}
	
	public static void main(String args[]){
		double[] test = {1,1,1,-1,-1,-1,-1,1,1,-1,-1,-1,-1,1,1};
		double[] test2 = {1,1,1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,1,-1,-1,-1,1,-1,-1,-1,-1,1,1,1,1,1,1,1,1,1,1};
		ZCalculator z = new ZCalculator();
		System.out.println(z.calculate(test2));
	}
}
