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
    saveSpeedsToExcel(radius, steps, getTyres(), telemetry);
  }
  testing(ratio, trackPoints, points, radius, speeds, telemetry, lapTime, steps, geneticBest);
}
