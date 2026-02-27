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
  drawTrack(x, y, 800);
  visualisationAllLanes(x, y, speeds, telemetry, steps, showWaypoints, showPoints, showSpeeds, telemetryS, lapTime);
  drawLapTimes(lapTime, geneticBest);
  if (excel) {
    saveSpeedsToExcel(steps,telemetry,speeds, ratio);
  }
  testing(ratio, trackPoints, points, radius, speeds, telemetry, lapTime, steps, geneticBest);
}

void drawLapTimes(double[][] times, double geneticBest) {
  float x = 1480;    // Aligned with the UI box
  float y = 20;   // Positioned below the Simulation Settings box
  float w = 210;   // Same width as UI box
  float h = 135;   // Height to fit 4-5 lines of text
  float padding = 10;

  // 1. Draw Background Box (matching your UI style)
  noStroke();
  fill(245, 245, 255, 240); 
  rect(x, y, w, h, 16);

  // 2. Draw Header
  fill(30, 30, 60);
  textSize(18);
  textAlign(LEFT, TOP);
  text("Lap Times", x + padding, y + padding);

  // 3. Draw Lap Time Data
  float currentY = y + 40;
  float lineH = 20;
  String[] labels = { "Inside:", "Center:", "Outside:", "Short (m):" };
  
  // Note: Using your existing colors for the text to differentiate lanes
  color[] laneColors = {
    color(200, 40, 40),   // Darker Red
    color(40, 90, 180),   // Blue (matching your UI blue)
    color(220, 120, 0),   // Orange
    color(30, 150, 30)    // Green
  };

  textSize(15);
  for (int j = 0; j < times.length && j < labels.length; j++) {
    int minutes = (int) times[j][0];
    double seconds = times[j][1];

    fill(0); // Label color
    text(labels[j], x + padding, currentY);
    
    fill(laneColors[j]); // Value color
    String timeStr = String.format("%02d:%06.3f", minutes, seconds);
    text(timeStr, x + 85, currentY); // Offset value to the right
    
    currentY += lineH;
  }

  // 4. Genetic Best (if applicable)
  if (geneticBest > 0 && !Double.isInfinite(geneticBest)) {
    int gMin = (int)(geneticBest / 60.0);
    double gSec = geneticBest - gMin * 60.0;

    fill(100, 50, 150); // Purple for Genetic
    String g = String.format("Genetic: %02d:%06.3f", gMin, gSec);
    text(g, x + padding, currentY);
  }

  // Reset alignment for other functions
  textAlign(LEFT, BASELINE);
}
