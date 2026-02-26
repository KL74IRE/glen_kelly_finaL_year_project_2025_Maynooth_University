void main(double[] x, double[] y, int start, int end, int steps, int mTrackLength, boolean showWaypoints, boolean showPoints, boolean showSpeeds, boolean excel, boolean telemetryS, boolean showTPs) {
  double ratio = ratio(x, y, start, end, steps, mTrackLength);
  double[][] trackPoints = getSpline(x, y, start, end, steps);
  double[][][] points = get2DPoints(trackPoints, steps, showTPs);
  double[][][] radius = radius(points, steps, ratio);
  double[][][] speeds = maxSpeed(radius, steps); 
  double[][][] telemetry = carAroundTrack(speeds, ratio, steps);
  double[][] lapTime = lapTime(telemetry, speeds, steps, ratio);
  double geneticBest = 0;
  if (genetic == true) {
    geneticBest = getGeneticBestLap(points, ratio, steps);
  }
  drawLapTimes(lapTime, geneticBest);
  drawTrack(x, y, 800);
  visualisationAllLanes(x, y, speeds, telemetry, steps, showWaypoints, showPoints, showSpeeds, telemetryS, lapTime);
  if (excel) {
    saveSpeedsToExcel(steps,telemetry,speeds, ratio);
  }
  testing(ratio, trackPoints, points, radius, speeds, telemetry, lapTime, steps, geneticBest);
}

void drawLapTimes(double[][] times, double geneticBest) {
  textSize(16);
  textAlign(LEFT, TOP);

  float x = 20;
  float y = 370;
  float lineH = 22;

  String[] labels = { "Inside Lane", "Center Lane", "Outside Lane", "Optimal" };
  color[] colors = {
    color(255, 0, 0),      // Inside Lane - Red
    color(0, 0, 255),      // Center Lane - Blue
    color(255, 165, 0),    // Outside Lane - Orange
    color(0, 200, 0)       // Optimal - Green
  };

  for (int j = 0; j < times.length && j < labels.length; j++) {
    int minutes = (int) times[j][0];
    double seconds = times[j][1];

    fill(colors[j]);
    String s = String.format("%s: %02d:%06.3f", labels[j], minutes, seconds);
    text(s, x, y + j * lineH);
  }

  if (geneticBest > 0 && !Double.isInfinite(geneticBest)) {
    int gMin = (int)(geneticBest / 60.0);
    double gSec = geneticBest - gMin * 60.0;

    fill(128, 0, 128); // Purple for Genetic

    String g = String.format("Genetic: %02d:%06.3f", gMin, gSec);
    text(g, x, y + times.length * lineH);
  }

  textAlign(LEFT, BASELINE);
  textSize(14);
  fill(0);
}