package com.lwfund.fx.mt4.report;

import java.io.FileOutputStream;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartFrame;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;

public class JfreeChartExample {

	public static void main(String args[]) throws Exception {
		// create a dataset...
		DefaultPieDataset dataset = new DefaultPieDataset();
		dataset.setValue("Category 1", 43.2);
		dataset.setValue("Category 2", 27.9);
		dataset.setValue("Category 3", 79.5);
		// create a chart...
		JFreeChart chart = ChartFactory.createPieChart("Sample Pie Chart",
				dataset, true, // legend?
				true, // tooltips?
				false // URLs?
				);

		FileOutputStream fos_jpg = null;
		try {
			fos_jpg = new FileOutputStream("C:\\test\\ok.jpg");
			/*
			 * 第二个参数如果为100，会报异常： java.lang.IllegalArgumentException: The
			 * 'quality' must be in the range 0.0f to 1.0f
			 * 限制quality必须小于等于1,把100改成 0.1f。
			 */
			ChartUtilities.writeChartAsJPEG(fos_jpg, 0.99f, chart, 600, 300,
					null);

		} catch (Exception e) {
			System.out.println("[e]" + e);
		} finally {
			try {
				fos_jpg.close();
			} catch (Exception e) {

			}
		}
		// create and display a frame...
		ChartFrame frame = new ChartFrame("First", chart);
		frame.pack();
		frame.setVisible(true);
	}

}
