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
double MAX_CHART_SPEED = 400.0;
double MS_TO_KMH = 3.6;

import java.io.FileOutputStream;
import java.io.File;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xddf.usermodel.*;
import org.apache.poi.xddf.usermodel.chart.*;
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;


void saveSpeedsToExcel(int steps, double[][][] telemetry, double[][][] speeds, double ratio) {
  try {
    XSSFWorkbook workbook = new XSSFWorkbook();
    String circuit = edit ? "Editing Mode" : brands ? "Brands Hatch Indy Circuit" : bahrain ? "Bahrain International GP Circuit" : circle ? "Circle Track" : "No Track Selected";

    XSSFSheet dataSheet = workbook.createSheet("Raw Data");
    
    XSSFFont titleFont = workbook.createFont();
    titleFont.setBold(true);
    titleFont.setFontHeightInPoints((short)16);
    XSSFCellStyle titleStyle = workbook.createCellStyle();
    titleStyle.setFont(titleFont);
    titleStyle.setAlignment(HorizontalAlignment.CENTER);

    Row titleRow = dataSheet.createRow(0);
    XSSFCell titleCell = (XSSFCell) titleRow.createCell(0);
    titleCell.setCellValue(circuit.toUpperCase());
    titleCell.setCellStyle(titleStyle);
    dataSheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 12));

    String[] headers = {
      "Step", "X (m)", "Y (m)", 
      "Outside Vmax", "Center Vmax", "Inside Vmax", "Shortest Vmax", "Genetic Vmax",
      "Outside Actual", "Center Actual", "Inside Actual", "Shortest Actual", "Genetic Actual"
    };
    Row headerRow = dataSheet.createRow(1);
    for (int i = 0; i < headers.length; i++) {
      headerRow.createCell(i).setCellValue(headers[i] + (i > 2 ? " (km/h)" : ""));
    }

    for (int i = 0; i < steps; i++) {
      Row row = dataSheet.createRow(i + 2);
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

    for (int i = 0; i < headers.length; i++) {
      dataSheet.autoSizeColumn(i);
    }

    XSSFSheet multiTrackSheet = workbook.createSheet("Original Tracks Comparison");
    createMultiSeriesChart(multiTrackSheet, dataSheet, steps, circuit + " - Track Comparison", 
        new int[]{8, 9, 10}, new String[]{"Outside Actual", "Center Actual", "Inside Actual"}, 
        new int[]{3}, new String[]{"Outside Vmax Limit"});

    XSSFSheet optimizedSheet = workbook.createSheet("Optimized Comparison");
    createMultiSeriesChart(optimizedSheet, dataSheet, steps, circuit + " - Optimized Comparison", 
        new int[]{11, 12}, new String[]{"Shortest Actual", "Genetic Actual"}, 
        new int[]{7}, new String[]{"Genetic Vmax Limit"});

    FileOutputStream fileOut = new FileOutputStream(sketchPath("Track_Telemetry_Analysis.xlsx"));
    workbook.write(fileOut);
    fileOut.close();
    workbook.close();
    println("Analysis Exported successfully.");

  } catch (Exception e) {
    println("Excel Error: " + e.getMessage());
    e.printStackTrace();
  }
}

void createMultiSeriesChart(XSSFSheet sheet, XSSFSheet dataSheet, int steps, String title, int[] actualCols, String[] actualLabels, int[] limitCols, String[] limitLabels) {
  XSSFDrawing drawing = sheet.createDrawingPatriarch();
  XSSFClientAnchor anchor = drawing.createAnchor(0, 0, 0, 0, 1, 1, 22, 36);
  XSSFChart chart = drawing.createChart(anchor);
  chart.setTitleText(title);
  chart.setTitleOverlay(false);

  XDDFChartLegend legend = chart.getOrAddLegend();
  legend.setPosition(org.apache.poi.xddf.usermodel.chart.LegendPosition.BOTTOM);

  XDDFCategoryAxis bottomAxis = chart.createCategoryAxis(org.apache.poi.xddf.usermodel.chart.AxisPosition.BOTTOM);
  XDDFValueAxis leftAxis = chart.createValueAxis(org.apache.poi.xddf.usermodel.chart.AxisPosition.LEFT);
  leftAxis.setTitle("Speed (km/h)");

  XDDFDataSource<Double> xs = XDDFDataSourcesFactory.fromNumericCellRange(dataSheet, new CellRangeAddress(2, steps + 1, 0, 0));
  XDDFScatterChartData data = (XDDFScatterChartData) chart.createData(ChartTypes.SCATTER, bottomAxis, leftAxis);
  data.setStyle(org.apache.poi.xddf.usermodel.chart.ScatterStyle.LINE);

  for (int i = 0; i < limitCols.length; i++) {
    XDDFNumericalDataSource<Double> ys = XDDFDataSourcesFactory.fromNumericCellRange(dataSheet, new CellRangeAddress(2, steps + 1, limitCols[i], limitCols[i]));
    XDDFScatterChartData.Series series = (XDDFScatterChartData.Series) data.addSeries(xs, ys);
    series.setTitle(limitLabels[i], null);
    series.setSmooth(true);
    setSeriesColor(series, 150, 150, 150, true); 
  }

  for (int i = 0; i < actualCols.length; i++) {
    XDDFNumericalDataSource<Double> ys = XDDFDataSourcesFactory.fromNumericCellRange(dataSheet, new CellRangeAddress(2, steps + 1, actualCols[i], actualCols[i]));
    XDDFScatterChartData.Series series = (XDDFScatterChartData.Series) data.addSeries(xs, ys);
    series.setTitle(actualLabels[i], null);
    series.setSmooth(true);

    if (actualLabels[i].contains("Outside")) setSeriesColor(series, 0, 0, 255, false);
    else if (actualLabels[i].contains("Center"))  setSeriesColor(series, 128, 0, 128, false);
    else if (actualLabels[i].contains("Inside"))  setSeriesColor(series, 255, 0, 0, false);
    else if (actualLabels[i].contains("Shortest")) setSeriesColor(series, 0, 200, 0, false);
    else if (actualLabels[i].contains("Genetic"))setSeriesColor(series, 255, 0, 255, false);
  }
  chart.plot(data);
}

void setSeriesColor(XDDFScatterChartData.Series series, int r, int g, int b, boolean isLimit) {
  try {
    XDDFShapeProperties props = series.getShapeProperties();
    if (props == null) props = new XDDFShapeProperties();
    
    XDDFLineProperties line = new XDDFLineProperties();
    
    byte[] rgb = new byte[]{(byte)r, (byte)g, (byte)b};
    line.setFillProperties(new XDDFSolidFillProperties(XDDFColor.from(rgb)));
    
    if (isLimit) {
      line.setWidth(Double.valueOf(1.0)); 
    } else {
      line.setWidth(Double.valueOf(3.0)); 
    }
    
    props.setLineProperties(line);
    series.setShapeProperties(props);
  } catch (Exception e) {
    println("Coloring Error: " + e.getMessage());
  }
}
