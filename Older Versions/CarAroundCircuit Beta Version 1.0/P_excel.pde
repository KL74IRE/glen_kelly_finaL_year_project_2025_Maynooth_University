double[] centerTrackXValues = new double[steps];
double[] centerTrackYValues = new double[steps];
double[] outsideTrackVmax = new double[steps];
double[] centerTrackVmax = new double[steps];
double[] insideTrackVmax = new double[steps];
double[] sVMax = new double[steps];
double[] gVMax = new double[steps];
double[] outsideTrackTelemetry = new double[steps];
double[] centerTrackTelemetry = new double[steps];
double[] insideTrackTelemetry = new double[steps];
double[] sTelemetry = new double[steps];
double[] gTelemetry = new double[steps];

import java.io.FileOutputStream;
import java.io.File;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xddf.usermodel.chart.*;
import org.apache.poi.xssf.usermodel.*;

double MAX_CHART_SPEED = 400.0;
double MS_TO_KMH = 3.6;

void saveSpeedsToExcel(int steps, double[][][] telemetry, double[][][] speeds, double ratio) {
  try {
    XSSFWorkbook workbook = new XSSFWorkbook();
    XSSFSheet dataSheet = workbook.createSheet("Raw Data");

    String[] headers = {
      "Step", "X (m)", "Y (m)", 
      "Outside Vmax", "Center Vmax", "Inside Vmax", "Shortest Vmax", "Genetic Vmax",
      "Outside Actual", "Center Actual", "Inside Actual", "Shortest Actual", "Genetic Actual"
    };

    Row headerRow = dataSheet.createRow(0);
    for (int i = 0; i < headers.length; i++) {
      headerRow.createCell(i).setCellValue(headers[i] + (i > 2 ? " (km/h)" : ""));
    }

    for (int i = 0; i < steps; i++) {
      Row row = dataSheet.createRow(i + 1);
      row.createCell(0).setCellValue(i);
      row.createCell(1).setCellValue(telemetry[1][i][0] / ratio);
      row.createCell(2).setCellValue(telemetry[1][i][1] / ratio);
      row.createCell(3).setCellValue(Math.min(MAX_CHART_SPEED, speeds[0][i][2] * MS_TO_KMH));
      row.createCell(4).setCellValue(Math.min(MAX_CHART_SPEED, speeds[1][i][2] * MS_TO_KMH));
      row.createCell(5).setCellValue(Math.min(MAX_CHART_SPEED, speeds[2][i][2] * MS_TO_KMH));
      row.createCell(6).setCellValue(Math.min(MAX_CHART_SPEED, shortestVmax[i] * MS_TO_KMH));
      row.createCell(7).setCellValue(Math.min(MAX_CHART_SPEED, geneticVMax[i] * MS_TO_KMH));
      row.createCell(8).setCellValue(telemetry[0][i][2] * MS_TO_KMH);
      row.createCell(9).setCellValue(telemetry[1][i][2] * MS_TO_KMH);
      row.createCell(10).setCellValue(telemetry[2][i][2] * MS_TO_KMH);
      row.createCell(11).setCellValue(shortestSpeeds[i] * MS_TO_KMH);
      row.createCell(12).setCellValue(v[i] * MS_TO_KMH);
    }

    String[][] config = {
      {"Outside Track", "3", "8"},
      {"Center Track",  "4", "9"},
      {"Inside Track",  "5", "10"},
      {"Shortest Path", "6", "11"},
      {"Genetic Path",  "7", "12"}
    };

    for (String[] s : config) {
      XSSFSheet sheet = workbook.createSheet(s[0]);
      createFormattedChart(sheet, dataSheet, steps, Integer.parseInt(s[1]), Integer.parseInt(s[2]), s[0]);
    }

    FileOutputStream fileOut = new FileOutputStream(sketchPath("Track_Telemetry_Analysis.xlsx"));
    workbook.write(fileOut);
    fileOut.close();
    workbook.close();
    println("Analysis Exported: Track_Telemetry_Analysis.xlsx");

  } catch (Exception e) {
    println("Excel Error: " + e.getMessage());
    e.printStackTrace();
  }
}

void createFormattedChart(XSSFSheet sheet, XSSFSheet dataSheet, int steps, int colLimit, int colActual, String title) {
  XSSFDrawing drawing = sheet.createDrawingPatriarch();
  XSSFClientAnchor anchor = drawing.createAnchor(0, 0, 0, 0, 1, 1, 18, 30);
  XSSFChart chart = drawing.createChart(anchor);
  chart.setTitleText(title + " Speed Comparison (km/h)");
  chart.setTitleOverlay(false);

  XDDFChartLegend legend = chart.getOrAddLegend();
  legend.setPosition(org.apache.poi.xddf.usermodel.chart.LegendPosition.BOTTOM);

  XDDFCategoryAxis bottomAxis = chart.createCategoryAxis(org.apache.poi.xddf.usermodel.chart.AxisPosition.BOTTOM);
  bottomAxis.setTitle("Step Index");

  if (chart.getCTChart().getPlotArea().getCatAxList().size() > 0) {
    chart.getCTChart().getPlotArea().getCatAxList().get(0).addNewTickLblSkip().setVal(100);
    chart.getCTChart().getPlotArea().getCatAxList().get(0).addNewTickMarkSkip().setVal(100);
  }

  XDDFValueAxis leftAxis = chart.createValueAxis(org.apache.poi.xddf.usermodel.chart.AxisPosition.LEFT);
  leftAxis.setTitle("Speed (km/h)");
  leftAxis.setMinimum(0.0);
  leftAxis.setMaximum(MAX_CHART_SPEED + 20);
  leftAxis.setMajorUnit(50.0);

  XDDFDataSource<Double> xs = XDDFDataSourcesFactory.fromNumericCellRange(dataSheet, new CellRangeAddress(1, steps, 0, 0));
  XDDFNumericalDataSource<Double> yLimit = XDDFDataSourcesFactory.fromNumericCellRange(dataSheet, new CellRangeAddress(1, steps, colLimit, colLimit));
  XDDFNumericalDataSource<Double> yActual = XDDFDataSourcesFactory.fromNumericCellRange(dataSheet, new CellRangeAddress(1, steps, colActual, colActual));

  XDDFScatterChartData data = (XDDFScatterChartData) chart.createData(ChartTypes.SCATTER, bottomAxis, leftAxis);
  data.setStyle(org.apache.poi.xddf.usermodel.chart.ScatterStyle.LINE);

  XDDFScatterChartData.Series seriesLimit = (XDDFScatterChartData.Series) data.addSeries(xs, yLimit);
  seriesLimit.setTitle("Vmax Limit (Capped)", null);
  seriesLimit.setSmooth(true);

  XDDFScatterChartData.Series seriesActual = (XDDFScatterChartData.Series) data.addSeries(xs, yActual);
  seriesActual.setTitle("Actual Telemetry", null);
  seriesActual.setSmooth(true);

  chart.plot(data);
}
