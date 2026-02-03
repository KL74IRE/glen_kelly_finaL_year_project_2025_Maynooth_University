double[][] carAroundTrack(double[][] speeds, double ratio, double steps)
{
  double accel = getAcceleration();
  double decel = getDeceleration();

  double[][] telemetry = new double[(int)steps][4];

  telemetry[0][0] = speeds[0][0];
  telemetry[0][1] = speeds[0][1];
  telemetry[0][2] = 0.0;
  telemetry[0][3] = 0.0;

  for (int i = 1; i < steps; i++) {
    telemetry[i][0] = speeds[i][0];
    telemetry[i][1] = speeds[i][1];

    float dx = (float)(telemetry[i][0] - telemetry[i-1][0]);
    float dy = (float)(telemetry[i][1] - telemetry[i-1][1]);
    float s  = (float)(Math.sqrt(dx*dx + dy*dy) / ratio);

    float vPrev = (float)telemetry[i-1][2];

    float vCalc = (float)Math.sqrt(vPrev * vPrev + 2f * (float)accel * s);
    float vMax = (float)speeds[i][3];

    telemetry[i][2] = Math.min(vCalc, vMax);
  }

  for (int i = (int)steps - 2; i >= 0; i--) {
    float dx = (float)(telemetry[i+1][0] - telemetry[i][0]);
    float dy = (float)(telemetry[i+1][1] - telemetry[i][1]);
    float s  = (float)(Math.sqrt(dx*dx + dy*dy) / ratio);

    float vNext = (float)telemetry[i+1][2];
    float vBrake = (float)Math.sqrt(vNext * vNext + 2f * (float)decel * s);

    if (vBrake < telemetry[i][2]) {
      telemetry[i][2] = vBrake;
    }
  }
  return telemetry;
}
