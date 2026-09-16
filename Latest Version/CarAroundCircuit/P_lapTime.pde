double[][] lapTime(double[][][] telemetry, double[][][] speeds, int steps, double ratio) {
    double[][] times = new double[4][2];
    for (int j = 0; j < 3; j++) {
        double totalTime = 0.0;
        for (int i = 1; i < steps; i++) {
            double dx = speeds[j][i][0] - speeds[j][i-1][0];
            double dy = speeds[j][i][1] - speeds[j][i-1][1];
            double s = Math.sqrt(dx * dx + dy * dy) / ratio;
            double v = telemetry[j][i][2];
            if (v > 1e-9) totalTime += s / v;
        }
        int minutes = (int)(totalTime / 60.0);
        double seconds = totalTime - minutes * 60.0;
        times[j][0] = minutes;
        times[j][1] = seconds;
    }
    double bestTime = getShortestLap(telemetry, ratio, steps);
    int bestMin = (int)(bestTime / 60.0);
    double bestSec = bestTime - bestMin * 60.0;
    times[3][0] = bestMin;
    times[3][1] = bestSec;
    return times;
}
