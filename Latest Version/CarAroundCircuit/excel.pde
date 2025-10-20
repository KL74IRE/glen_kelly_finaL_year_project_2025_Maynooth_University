import java.io.FileOutputStream;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xddf.usermodel.chart.XDDFCategoryAxis;
import org.apache.poi.xddf.usermodel.chart.XDDFValueAxis;
import org.apache.poi.xddf.usermodel.chart.XDDFDataSource;
import org.apache.poi.xddf.usermodel.chart.XDDFNumericalDataSource;
import org.apache.poi.xddf.usermodel.chart.XDDFScatterChartData;
import org.apache.poi.xddf.usermodel.chart.XDDFChartLegend;
import org.apache.poi.xddf.usermodel.chart.AxisPosition;
import org.apache.poi.xddf.usermodel.chart.ChartTypes;
import org.apache.poi.xddf.usermodel.chart.ScatterStyle;
import org.apache.poi.xddf.usermodel.chart.XDDFDataSourcesFactory;

void saveSpeedsToExcel(double[][] radius, int steps, double[] tyres) {
  try {
    XSSFWorkbook workbook = new XSSFWorkbook();
    XSSFSheet sheet = workbook.createSheet("Telemetry");

    // Header
    Row header = sheet.createRow(0);
    header.createCell(0).setCellValue("Point");
    header.createCell(1).setCellValue("Soft (km/h)");
    header.createCell(2).setCellValue("Medium (km/h)");
    header.createCell(3).setCellValue("Hard (km/h)");

    // Data
    for (int i = 0; i < steps; i++) {
      double r = radius[i][2];
      double soft = 3.6 * Math.sqrt(tyres[0] * 9.81 * r);
      double medium = 3.6 * Math.sqrt(tyres[1] * 9.81 * r);
      double hard = 3.6 * Math.sqrt(tyres[2] * 9.81 * r);

      if (soft > 360) soft = 360;
      if (medium > 360) medium = 360;
      if (hard > 360) hard = 360;

      Row row = sheet.createRow(i + 1);
      row.createCell(0).setCellValue(i);
      row.createCell(1).setCellValue(soft);
      row.createCell(2).setCellValue(medium);
      row.createCell(3).setCellValue(hard);
    }

    // === Create scatter chart ===
    XSSFDrawing drawing = sheet.createDrawingPatriarch();
    XSSFClientAnchor anchor = drawing.createAnchor(0, 0, 0, 0, 5, 1, 15, 20);
    XSSFChart chart = drawing.createChart(anchor);
    chart.setTitleText("Max Speeds by Point");
    chart.setTitleOverlay(false);

    XDDFChartLegend legend = chart.getOrAddLegend();
    // 👇 Use full path to avoid ambiguity
    legend.setPosition(org.apache.poi.xddf.usermodel.chart.LegendPosition.RIGHT);

    XDDFCategoryAxis bottomAxis = chart.createCategoryAxis(AxisPosition.BOTTOM);
    bottomAxis.setTitle("Point");
    XDDFValueAxis leftAxis = chart.createValueAxis(AxisPosition.LEFT);
    leftAxis.setTitle("Speed (km/h)");

    XDDFDataSource<Double> points = XDDFDataSourcesFactory.fromNumericCellRange(sheet, new CellRangeAddress(1, steps, 0, 0));
    XDDFNumericalDataSource<Double> softData = XDDFDataSourcesFactory.fromNumericCellRange(sheet, new CellRangeAddress(1, steps, 1, 1));
    XDDFNumericalDataSource<Double> mediumData = XDDFDataSourcesFactory.fromNumericCellRange(sheet, new CellRangeAddress(1, steps, 2, 2));
    XDDFNumericalDataSource<Double> hardData = XDDFDataSourcesFactory.fromNumericCellRange(sheet, new CellRangeAddress(1, steps, 3, 3));

    XDDFScatterChartData data = (XDDFScatterChartData) chart.createData(ChartTypes.SCATTER, bottomAxis, leftAxis);
    data.setStyle(ScatterStyle.LINE);

    data.addSeries(points, softData).setTitle("Soft", null);
    data.addSeries(points, mediumData).setTitle("Medium", null);
    data.addSeries(points, hardData).setTitle("Hard", null);

    chart.plot(data);

    // Autosize columns
    for (int i = 0; i < 4; i++) sheet.autoSizeColumn(i);

    // Save Excel file
    FileOutputStream fileOut = new FileOutputStream(sketchPath("data.xlsx"));
    workbook.write(fileOut);
    fileOut.close();
    workbook.close();

    println("✅ Excel file with scatter plot created: data.xlsx");

  } catch (Exception e) {
    e.printStackTrace();
  }
}
