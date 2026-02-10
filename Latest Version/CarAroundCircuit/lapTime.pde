double[][] lapTime(double[][][] telemetry, double[][][] speeds, int steps, double ratio) 
{
    double[][] times = new double[4][2];

    for (int j = 0; j < 3; j++) {
        double totalTime = 0.0;

        for (int i = 1; i < steps; i++) {
            double dx = speeds[j][i][0] - speeds[j][i-1][0];
            double dy = speeds[j][i][1] - speeds[j][i-1][1];

            double s = Math.sqrt(dx*dx + dy*dy) / ratio;

            double v = telemetry[j][i][2];

            if (v > 1e-9) totalTime += s / v;
        }

        int minutes = (int)(totalTime / 60.0);
        double seconds = totalTime - minutes * 60.0;

        times[j][0] = minutes;
        times[j][1] = seconds;
    }

    double bestTime = getOptimalLap(telemetry, speeds, steps, ratio);

    int bestMin = (int)(bestTime / 60.0);
    double bestSec = bestTime - bestMin * 60.0;

    times[3][0] = bestMin;
    times[3][1] = bestSec;

    return times;
}

double getOptimalLap(double[][][] telemetry, double[][][] speeds, int steps, double ratio)
{
  final double INF = Double.POSITIVE_INFINITY;

  double[][] dp = new double[3][steps];

  int[][] parent = new int[3][steps];

  for (int j = 0; j < 3; j++) {
    dp[j][0] = 0.0;
    parent[j][0] = j;
  }

  for (int i = 1; i < steps; i++) {
    for (int j = 0; j < 3; j++) {

      double bestPrev = dp[j][i - 1];
      int bestlane = j;

      if (j > 0 && dp[j - 1][i - 1] < bestPrev) {
        bestPrev = dp[j - 1][i - 1];
        bestlane = j - 1;
      }
      if (j < 2 && dp[j + 1][i - 1] < bestPrev) {
        bestPrev = dp[j + 1][i - 1];
        bestlane = j + 1;
      }

      double dx = speeds[j][i][0] - speeds[j][i - 1][0];
      double dy = speeds[j][i][1] - speeds[j][i - 1][1];
      double s  = Math.sqrt(dx * dx + dy * dy) / ratio;

      double v  = telemetry[j][i][2];
      double dt = (v > 1e-9) ? (s / v) : INF;

      parent[j][i] = bestlane;
      dp[j][i] = bestPrev + dt;
    }
  }
  println();

  int endlane = 0;
  if (dp[1][steps - 1] < dp[endlane][steps - 1]) endlane = 1;
  if (dp[2][steps - 1] < dp[endlane][steps - 1]) endlane = 2;

  double bestTime = dp[endlane][steps - 1];

  int[] optimalj = new int[steps];
  optimalj[steps - 1] = endlane;
  for (int i = steps - 1; i > 0; i--) {
    optimalj[i - 1] = parent[optimalj[i]][i];
  }
  stroke(0, 255, 0);
  strokeWeight(10);
  
  for (int i = 1; i < steps; i++) {
    int jPrev = optimalj[i - 1];
    int jCurr = optimalj[i];

    float xPrev = (float) speeds[jPrev][i - 1][0];
    float yPrev = (float) speeds[jPrev][i - 1][1];
    float xCurr = (float) speeds[jCurr][i][0];
    float yCurr = (float) speeds[jCurr][i][1];
    
    if(genetic == false)
    {
      line(xPrev, yPrev, xCurr, yCurr);
    }
  }
  stroke(0);
  strokeWeight(2);

  return bestTime;
}
