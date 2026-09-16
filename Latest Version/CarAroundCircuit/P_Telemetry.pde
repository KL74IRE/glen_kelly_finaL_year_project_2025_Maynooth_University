double[][][] carAroundTrack(double[][][] speeds, double ratio, int steps) {
  double accel = getAcceleration();
  double decel = Math.abs(getDeceleration());
  double[][][] telemetry = new double[3][steps][3];

  for (int j = 0; j < 3; j++) {
    telemetry[j][0][0] = speeds[j][0][0];
    telemetry[j][0][1] = speeds[j][0][1];
    telemetry[j][0][2] = 0.0;

    for (int i = 1; i < steps; i++) {
      telemetry[j][i][0] = speeds[j][i][0];
      telemetry[j][i][1] = speeds[j][i][1];
      double dx = telemetry[j][i][0] - telemetry[j][i - 1][0];
      double dy = telemetry[j][i][1] - telemetry[j][i - 1][1];
      double s = Math.sqrt(dx * dx + dy * dy) / ratio;
      double vPrev = telemetry[j][i - 1][2];
      double vCalc = Math.sqrt(vPrev * vPrev + 2.0 * accel * s);
      double vMax = speeds[j][i][3];
      telemetry[j][i][2] = Math.min(vCalc, vMax);
    }

    for (int i = steps - 2; i >= 0; i--) {
      double dx = telemetry[j][i + 1][0] - telemetry[j][i][0];
      double dy = telemetry[j][i + 1][1] - telemetry[j][i][1];
      double s = Math.sqrt(dx * dx + dy * dy) / ratio;
      double vNext = telemetry[j][i + 1][2];
      double vBrake = Math.sqrt(vNext * vNext + 2.0 * decel * s);
      if (vBrake < telemetry[j][i][2]) {
        telemetry[j][i][2] = vBrake;
      }
    }
  }
  return telemetry;
}
