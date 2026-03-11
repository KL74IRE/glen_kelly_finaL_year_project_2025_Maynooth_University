void main(double[] x, double[] y, int start, int end, int steps, int mTrackLength, boolean showWaypoints, boolean showPoints, boolean showSpeeds, boolean excel, boolean telemetryS, boolean showTPs) {
  double ratio = ratio(x, y, start, end, steps, mTrackLength);
  double[][] trackPoints = getSpline(x, y, start, end, steps);
  double[][][] points = get2DPoints(trackPoints, steps, showTPs);
  double[][][] radius = radius(points, steps, ratio);
  double[][][] speeds = maxSpeed(radius, steps); 
  double[][][] telemetry = carAroundTrack(speeds, ratio, steps);
  double[][] lapTime = lapTime(telemetry, speeds, steps, ratio);
  double geneticBest = 0;
  double [] tyres = getTyres();
  if (genetic == true) {
    geneticBest = getGeneticBestLap(points, ratio, steps, tyres[0]);
  }
  double [] [] stint = null;
  if(stintB == true) {
    stint = getGeneticStint(points, ratio, steps, tyres, laps, mTrackLength);
  }
  if(stats == true) {
    getGeneticStats(points, ratio, steps, tyres);
  }
  drawTrack(x, y, 800);
  visualisationAllLanes(x, y, speeds, telemetry, steps, showWaypoints, showPoints, showSpeeds, telemetryS, lapTime);
  drawLapTimes(lapTime, geneticBest,stint, laps);
  if (excel) {
    saveSpeedsToExcel(steps,telemetry,speeds, ratio, stint);
  }
  testing(ratio, trackPoints, points, radius, speeds, telemetry, lapTime, steps, geneticBest);
}

void drawLapTimes(double[][] times, double geneticBest, double[][] stint, int laps) {
  float x = 1480;
  float y = 20;
  float w = 210;
  float h = 135;
  float padding = 10;

  noStroke();
  fill(245, 245, 255, 240);
  if (stintB == true) {
    rect(x, y, w, h + 80, 16);
  } else {
    rect(x, y, w, h, 16);
  }

  fill(30, 30, 60);
  textSize(18);
  textAlign(LEFT, TOP);
  text("Lap Times", x + padding, y + padding);

  float currentY = y + 40;
  float lineH = 20;

  String[] labels = { "Inside (S)", "Center (S)", "Outside (S)", "Short (S)" };

  color[] laneColors = {
    color(200, 40, 40),
    color(40, 90, 180),
    color(220, 120, 0),
    color(30, 150, 30)
  };

  float labelX = x + padding;
  float timeX = x + w - padding;

  textSize(15);

  for (int j = 0; j < times.length && j < labels.length; j++) {
    int minutes = (int)times[j][0];
    double seconds = times[j][1];

    fill(0);
    textAlign(LEFT, TOP);
    text(labels[j] + ":", labelX, currentY);

    fill(laneColors[j]);
    textAlign(RIGHT, TOP);
    String timeStr = String.format("%02d:%06.3f", minutes, seconds);
    text(timeStr, timeX, currentY);

    currentY += lineH;
  }

  if (geneticBest > 0 && !Double.isInfinite(geneticBest) && !Double.isNaN(geneticBest)) {
    int gMin = (int)(geneticBest / 60.0);
    double gSec = geneticBest - gMin * 60.0;

    fill(100, 50, 150);
    textAlign(LEFT, TOP);
    text("Genetic (S):", labelX, currentY);

    textAlign(RIGHT, TOP);
    String g = String.format("%02d:%06.3f", gMin, gSec);
    text(g, timeX, currentY);

    currentY += lineH;
  }

  if (stintB == true) {
    currentY += 10;

    double time;
    int sMin;
    double sSec;
    String t;

    time = stint[0][0];
    sMin = (int)(time / 60.0);
    sSec = time - sMin * 60.0;
    fill(220, 0, 0);
    textAlign(LEFT, TOP);
    text("Soft (" + laps + "):", labelX, currentY);
    textAlign(RIGHT, TOP);
    t = String.format("%02d:%06.3f", sMin, sSec);
    text(t, timeX, currentY);
    currentY += lineH;

    time = stint[1][0];
    sMin = (int)(time / 60.0);
    sSec = time - sMin * 60.0;
    fill(250, 156, 28);
    textAlign(LEFT, TOP);
    text("Medium (" + laps + "):", labelX, currentY);
    textAlign(RIGHT, TOP);
    t = String.format("%02d:%06.3f", sMin, sSec);
    text(t, timeX, currentY);
    currentY += lineH;

    time = stint[2][0];
    sMin = (int)(time / 60.0);
    sSec = time - sMin * 60.0;
    fill(0);
    textAlign(LEFT, TOP);
    text("Hard (" + laps + "):", labelX, currentY);
    textAlign(RIGHT, TOP);
    t = String.format("%02d:%06.3f", sMin, sSec);
    text(t, timeX, currentY);
  }

  textAlign(LEFT, BASELINE);
}