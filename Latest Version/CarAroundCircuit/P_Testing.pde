void testing(double ratio, double[][] trackPoints, double[][][] points, double[][][] radius,
       double[][][] speeds, double[][][] telemetry, double[][] lapTime, int steps, double geneticBest)
{
  hasError = false;
  testMessage = "TESTS RUNNING...";

  checkPoints(trackPoints, points, radius, speeds, telemetry, steps);
  checkRandomRadius(radius, steps, ratio);
  checkRandomSpeed(speeds,radius,steps);
  checkLaptime(lapTime, geneticBest);

  testMessage = hasError ? "TESTS FAILED" : "TESTS PASSED";
}

void checkPoints(double[][] trackPoints, double[][][] points, double[][][] radius, double[][][] speeds, double[][][] telemetry, int steps)
{
  double eps = 1;
  int temp = offset;
  offset = 10;

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
  offset = temp;
  }
}

void checkRandomRadius(double[][][] radius, int steps, double ratio)
{
  for (int i = 0; i < 10; i++)
  {
  double randomLane = Math.random() * 2;
  int randomIndex = (int)(Math.random() * steps);
  int prevIndex = (randomIndex == 0) ? steps - 1 : randomIndex - 1;

  double x1 = radius[(int)randomLane][prevIndex][0];
  double y1 = radius[(int)randomLane][prevIndex][1];
  double x2 = radius[(int)randomLane][randomIndex][0];
  double y2 = radius[(int)randomLane][randomIndex][1];
  double x3 = radius[(int)randomLane][randomIndex][0];
  double y3 = radius[(int)randomLane][randomIndex][1];

  double a = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
  double b = Math.sqrt((x3 - x2) * (x3 - x2) + (y3 - y2) * (y3 - y2));
  double c = Math.sqrt((x1 - x3) * (x1 - x3) + (y1 - y3) * (y1 - y3));
  double area = abs((float)(x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2))) * 0.5;
  double expectedRadius = (a * b * c) / (4 * area);
  expectedRadius = expectedRadius / ratio;

  if (Math.abs(expectedRadius - radius[(int)randomLane][randomIndex][2]) > 1) {
    hasError = true;
    println("Radius mismatch at lane " + (int)randomLane + " index " + randomIndex + " | expected " + expectedRadius + " | got " + radius[(int)randomLane][randomIndex][2]);
  }
  }
}


void checkRandomSpeed(double[][][] speeds, double[][][] radius, int steps)
{
  for (int i = 0; i < 10; i++)
  {
  double randomLane = Math.random() * 2;
  int randomIndex = (int)(Math.random() * steps);

  double Tyres = getTyres()[0];
  double expectedSpeed = Math.sqrt(Tyres * 9.81 * radius[(int)randomLane][randomIndex][2]);
  if (Math.abs(expectedSpeed - speeds[(int)randomLane][randomIndex][3]) > 1) {
    hasError = true;
    println("Speed mismatch at lane " + (int)randomLane + " index " + randomIndex + " | expected " + expectedSpeed + " | got " + speeds[(int)randomLane][randomIndex][3]);
  }
  }
}

void checkLaptime(double[][] lapTime, double geneticBest)
{
  double lapTimeInsideSeconds = lapTime[2][0] * 60;
  lapTimeInsideSeconds += lapTime[2][1];
    double lapTimeShortSeconds = lapTime[3][0] * 60;
  lapTimeShortSeconds += lapTime[2][1];
  if (geneticBest > lapTimeInsideSeconds) {
  hasError = true;
  println("Genetic SLOWER Lap time | Original Laptime " + lapTime[3][lapTime[0].length - 1] + " | Genetic: " + geneticBest);
  }
  else if (geneticBest > lapTimeShortSeconds) {
  hasError = true;
  println("Genetic SLOWER Lap time | Original Laptime " + lapTime[3][lapTime[0].length - 1] + " | Genetic: " + geneticBest);
  }
  else if (lapTimeShortSeconds > lapTimeInsideSeconds) {
  hasError = true;
  println("Genetic SLOWER Lap time | Original Laptime " + lapTime[3][lapTime[0].length - 1] + " | Genetic: " + geneticBest);
  }
}
