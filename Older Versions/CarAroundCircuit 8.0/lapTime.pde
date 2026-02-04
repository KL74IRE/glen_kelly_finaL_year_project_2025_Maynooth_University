double[][] lapTime(double[][][] telemetry, double[][][] speeds, int steps, double ratio) 
{
    double[][] times = new double[4][2];

    for (int j = 0; j < 3; j++) {
        double totalTime = 0.0;

        for (int i = 1; i < steps; i++) {
            double dx = speeds[j][i][0] - speeds[j][i-1][0];
            double dy = speeds[j][i][1] - speeds[j][i-1][1];

            double s = Math.sqrt(dx*dx + dy*dy) / ratio;

            double v = telemetry[j][i][2]; // ✅ FIXED

            if (v > 1e-9) totalTime += s / v;
        }

        int minutes = (int)(totalTime / 60.0);
        double seconds = totalTime - minutes * 60.0;

        System.out.printf("Car %d Lap Time = %02d:%06.3f\n", j, minutes, seconds);

        times[j][0] = minutes;
        times[j][1] = seconds;
    }

    double bestTime = getOptimalLap(telemetry, speeds, steps, ratio);

    int bestMin = (int)(bestTime / 60.0);
    double bestSec = bestTime - bestMin * 60.0;

    System.out.printf("Optimal Lap Time = %02d:%06.3f\n", bestMin, bestSec);

    times[3][0] = bestMin;
    times[3][1] = bestSec;

    return times;
}

double getOptimalLap(double[][][] telemetry, double[][][] speeds, int steps, double ratio)
{
  final double INF = Double.POSITIVE_INFINITY;

  // dp[lane][i] = best (minimum) time to reach step i while being in `lane`
  double[][] dp = new double[3][steps];

  // parent[lane][i] = lane at step i-1 that led to best dp[lane][i]
  int[][] parent = new int[3][steps];

  // ---- init ----
  for (int lane = 0; lane < 3; lane++) {
    dp[lane][0] = 0.0;
    parent[lane][0] = lane;
  }

  // ---- fill DP ----
  for (int i = 1; i < steps; i++) {
    for (int lane = 0; lane < 3; lane++) {

      // pick best previous lane (stay / switch to adjacent)
      double bestPrev = dp[lane][i - 1];
      int bestLane = lane;

      if (lane > 0 && dp[lane - 1][i - 1] < bestPrev) {
        bestPrev = dp[lane - 1][i - 1];
        bestLane = lane - 1;
      }
      if (lane < 2 && dp[lane + 1][i - 1] < bestPrev) {
        bestPrev = dp[lane + 1][i - 1];
        bestLane = lane + 1;
      }

      // step cost if we end up in `lane` at step i
      double dx = speeds[lane][i][0] - speeds[lane][i - 1][0];
      double dy = speeds[lane][i][1] - speeds[lane][i - 1][1];
      double s  = Math.sqrt(dx * dx + dy * dy) / ratio;

      double v  = telemetry[lane][i][2];
      double dt = (v > 1e-9) ? (s / v) : INF;

      parent[lane][i] = bestLane;
      dp[lane][i] = bestPrev + dt;
    }
  }

  // ---- choose best finishing lane ----
  int endLane = 0;
  if (dp[1][steps - 1] < dp[endLane][steps - 1]) endLane = 1;
  if (dp[2][steps - 1] < dp[endLane][steps - 1]) endLane = 2;

  double bestTime = dp[endLane][steps - 1];

  // ---- backtrack optimal lane choice per step ----
  int[] optimalLane = new int[steps];
  optimalLane[steps - 1] = endLane;
  for (int i = steps - 1; i > 0; i--) {
    optimalLane[i - 1] = parent[optimalLane[i]][i];
  }

  // ---- draw chosen path bright green using line segments ----
  stroke(0, 255, 0);     // bright green
  strokeWeight(6);

  for (int i = 1; i < steps; i++) {
    int lanePrev = optimalLane[i - 1];
    int laneCurr = optimalLane[i];

    float xPrev = (float) speeds[lanePrev][i - 1][0];
    float yPrev = (float) speeds[lanePrev][i - 1][1];
    float xCurr = (float) speeds[laneCurr][i][0];
    float yCurr = (float) speeds[laneCurr][i][1];

    line(xPrev, yPrev, xCurr, yCurr);
  }

  // reset style (optional)
  stroke(0);
  strokeWeight(2);

  return bestTime;
}
