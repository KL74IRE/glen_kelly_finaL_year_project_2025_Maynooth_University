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


void saveSpeedsToExcel(int steps, double[][][] telemetry, double[][][] speeds, double ratio, double [] [] stint) {
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

    XSSFSheet fullComparisonSheet = workbook.createSheet("Path Optimization Comparison");
    createMultiSeriesChart(fullComparisonSheet, dataSheet, steps, 
        circuit + " - Path Logic Comparison", 
        new int[]{9, 11, 12}, // Indices for Center, Shortest, and Genetic Actuals
        new String[]{"Center (Baseline)", "Shortest Path", "Genetic Algorithm"}, 
        new int[]{7},          // Limit line (Genetic Vmax is a good reference here)
        new String[]{"Global Vmax Limit"});
    
if (stint != null) {
    XSSFSheet stintSheet = workbook.createSheet("Stint Analysis");
    int totalLaps = stint[0].length - 1; // Note: using stint[0].length based on your first snippet

    String[] sHeaders = {"Lap", "Soft Lap", "Medium Lap", "Hard Lap", "Soft Total", "Medium Total", "Hard Total"};
    Row sHeaderRow = stintSheet.createRow(0);
    for(int i = 0; i < sHeaders.length; i++) sHeaderRow.createCell(i).setCellValue(sHeaders[i]);

    double[] runningTotals = new double[3];

    for (int j = 1; j <= totalLaps; j++) {
        Row row = stintSheet.createRow(j);
        row.createCell(0).setCellValue(j);
        
        for (int i = 0; i < 3; i++) {
            // APPLY LIMIT: If lap time > 250, cap it at 250 (Tyre Failure)
            double currentLap = Math.min(250.0, stint[i][j]);
            runningTotals[i] += currentLap;
            
            row.createCell(i + 1).setCellValue(currentLap);
            row.createCell(i + 4).setCellValue(runningTotals[i]);
        }
    }
    
    // Create the charts (Lap times capped at 250s)
    createStintChart(stintSheet, totalLaps, "Lap-by-Lap (Max 250s Limit)", 1, 5); 
    createStintChart(stintSheet, totalLaps, "Total Race Time", 4, 15);
}


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

void createStintChart(XSSFSheet sheet, int laps, String title, int startCol, int anchorCol) {
  XSSFDrawing drawing = sheet.createDrawingPatriarch();
  // Anchor defines chart position: (col1, row1, col2, row2)
  // anchorCol is where the left side starts; +9 defines the width
  XSSFClientAnchor anchor = drawing.createAnchor(0, 0, 0, 0, anchorCol, 1, anchorCol + 9, 25);
  XSSFChart chart = drawing.createChart(anchor);
  chart.setTitleText(title);
  chart.setTitleOverlay(false);

  XDDFChartLegend legend = chart.getOrAddLegend();
  legend.setPosition(org.apache.poi.xddf.usermodel.chart.LegendPosition.BOTTOM);

  // X-Axis (Lap Number)
  XDDFCategoryAxis bottomAxis = chart.createCategoryAxis(org.apache.poi.xddf.usermodel.chart.AxisPosition.BOTTOM);
  bottomAxis.setTitle("Lap Number");

  // Y-Axis (Time)
  XDDFValueAxis leftAxis = chart.createValueAxis(org.apache.poi.xddf.usermodel.chart.AxisPosition.LEFT);
  
  // Apply the 250s limit visual capping to individual lap charts only
  if (startCol <= 3) {
    leftAxis.setTitle("Lap Time (s)");
    leftAxis.setMaximum(250.0); // Hard ceiling for tyre failure visualization
    leftAxis.setMinimum(0.0);
  } else {
    leftAxis.setTitle("Total Elapsed Time (s)");
  }

  // Data Source for X-Axis (Laps are always in Column 0)
  XDDFDataSource<Double> xs = XDDFDataSourcesFactory.fromNumericCellRange(sheet, new CellRangeAddress(1, laps, 0, 0));
  
  // Use Scatter with Lines to show degradation curves
  XDDFScatterChartData data = (XDDFScatterChartData) chart.createData(ChartTypes.SCATTER, bottomAxis, leftAxis);
  data.setStyle(org.apache.poi.xddf.usermodel.chart.ScatterStyle.LINE);

  String[] compounds = {"Soft", "Medium", "Hard"};

  for (int i = 0; i < 3; i++) {
    // Select the correct column based on startCol (1-3 for Laps, 4-6 for Total)
    XDDFNumericalDataSource<Double> ys = XDDFDataSourcesFactory.fromNumericCellRange(sheet, new CellRangeAddress(1, laps, startCol + i, startCol + i));
    
    XDDFScatterChartData.Series series = (XDDFScatterChartData.Series) data.addSeries(xs, ys);
    series.setTitle(compounds[i], null);
    series.setSmooth(false); // Sharp lines represent discrete lap events better

    // Apply Colors: Red (Soft), Yellow (Medium), Silver/White (Hard)
    // Note: ensure your setSeriesColor helper is compatible with these parameters
    if (i == 0)      setSeriesColor(series, 255, 0, 0, false);   // Red
    else if (i == 1) setSeriesColor(series, 255, 200, 0, false); // Yellow
    else             setSeriesColor(series, 180, 180, 180, false); // Silver
  }

  chart.plot(data);
}
