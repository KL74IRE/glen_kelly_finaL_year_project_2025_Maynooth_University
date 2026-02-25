void testing(double ratio, double[][] trackPoints, double[][][] points, double[][][] radius,
             double[][][] speeds, double[][][] telemetry, double[][] lapTime,
             double geneticBest, int steps)
{
  hasError = false;
  testMessage = "TESTS RUNNING...";

  checkPoints(trackPoints, points, radius, speeds, telemetry, steps);

  testMessage = hasError ? "TESTS FAILED" : "TESTS PASSED";
}

void checkPoints(double[][] trackPoints, double[][][] points, double[][][] radius,double[][][] speeds, double[][][] telemetry, int steps){
  double eps = 1;

  for (int j = 0; j < steps; j++)
  {
    double originalCenterX = trackPoints[j][0];
    double originalCenterY = trackPoints[j][1];

    double originalLeftX   = points[0][j][0];
    double originalLeftY   = points[0][j][1];

    double originalRightX  = points[2][j][0];
    double originalRightY  = points[2][j][1];

    if (Math.abs(originalCenterX - points[1][j][0]) > eps) {
      hasError = true;
      println("CenterX mismatch with points[1][" + j + "][0] | expected " + originalCenterX + " | got " + points[1][j][0]);
    }
    if (Math.abs(originalCenterY - points[1][j][1]) > eps) {
      hasError = true;
      println("CenterY mismatch with points[1][" + j + "][1] | expected " + originalCenterY + " | got " + points[1][j][1]);
    }

    if (Math.abs(originalCenterX - radius[1][j][0]) > eps) {
      hasError = true;
      println("CenterX mismatch with radius[1][" + j + "][0] | expected " + originalCenterX + " | got " + radius[1][j][0]);
    }
    if (Math.abs(originalCenterY - radius[1][j][1]) > eps) {
      hasError = true;
      println("CenterY mismatch with radius[1][" + j + "][1] | expected " + originalCenterY + " | got " + radius[1][j][1]);
    }
    if (Math.abs(originalLeftX - radius[0][j][0]) > eps) {
      hasError = true;
      println("LeftX mismatch with radius[0][" + j + "][0] | expected " + originalLeftX + " | got " + radius[0][j][0]);
    }
    if (Math.abs(originalLeftY - radius[0][j][1]) > eps) {
      hasError = true;
      println("LeftY mismatch with radius[0][" + j + "][1] | expected " + originalLeftY + " | got " + radius[0][j][1]);
    }
    if (Math.abs(originalRightX - radius[2][j][0]) > eps) {
      hasError = true;
      println("RightX mismatch with radius[2][" + j + "][0] | expected " + originalRightX + " | got " + radius[2][j][0]);
    }
    if (Math.abs(originalRightY - radius[2][j][1]) > eps) {
      hasError = true;
      println("RightY mismatch with radius[2][" + j + "][1] | expected " + originalRightY + " | got " + radius[2][j][1]);
    }

    if (Math.abs(originalCenterX - speeds[1][j][0]) > eps) {
      hasError = true;
      println("CenterX mismatch with speeds[1][" + j + "][0] | expected " + originalCenterX + " | got " + speeds[1][j][0]);
    }
    if (Math.abs(originalCenterY - speeds[1][j][1]) > eps) {
      hasError = true;
      println("CenterY mismatch with speeds[1][" + j + "][1] | expected " + originalCenterY + " | got " + speeds[1][j][1]);
    }
    if (Math.abs(originalLeftX - speeds[0][j][0]) > eps) {
      hasError = true;
      println("LeftX mismatch with speeds[0][" + j + "][0] | expected " + originalLeftX + " | got " + speeds[0][j][0]);
    }
    if (Math.abs(originalLeftY - speeds[0][j][1]) > eps) {
      hasError = true;
      println("LeftY mismatch with speeds[0][" + j + "][1] | expected " + originalLeftY + " | got " + speeds[0][j][1]);
    }
    if (Math.abs(originalRightX - speeds[2][j][0]) > eps) {
      hasError = true;
      println("RightX mismatch with speeds[2][" + j + "][0] | expected " + originalRightX + " | got " + speeds[2][j][0]);
    }
    if (Math.abs(originalRightY - speeds[2][j][1]) > eps) {
      hasError = true;
      println("RightY mismatch with speeds[2][" + j + "][1] | expected " + originalRightY + " | got " + speeds[2][j][1]);
    }

    if (Math.abs(originalCenterX - telemetry[1][j][0]) > eps) {
      hasError = true;
      println("CenterX mismatch with telemetry[1][" + j + "][0] | expected " + originalCenterX + " | got " + telemetry[1][j][0]);
    }
    if (Math.abs(originalCenterY - telemetry[1][j][1]) > eps) {
      hasError = true;
      println("CenterY mismatch with telemetry[1][" + j + "][1] | expected " + originalCenterY + " | got " + telemetry[1][j][1]);
    }
    if (Math.abs(originalLeftX - telemetry[0][j][0]) > eps) {
      hasError = true;
      println("LeftX mismatch with telemetry[0][" + j + "][0] | expected " + originalLeftX + " | got " + telemetry[0][j][0]);
    }
    if (Math.abs(originalLeftY - telemetry[0][j][1]) > eps) {
      hasError = true;
      println("LeftY mismatch with telemetry[0][" + j + "][1] | expected " + originalLeftY + " | got " + telemetry[0][j][1]);
    }
    if (Math.abs(originalRightX - telemetry[2][j][0]) > eps) {
      hasError = true;
      println("RightX mismatch with telemetry[2][" + j + "][0] | expected " + originalRightX + " | got " + telemetry[2][j][0]);
    }
    if (Math.abs(originalRightY - telemetry[2][j][1]) > eps) {
      hasError = true;
      println("RightY mismatch with telemetry[2][" + j + "][1] | expected " + originalRightY + " | got " + telemetry[2][j][1]);
    }
  }
}

