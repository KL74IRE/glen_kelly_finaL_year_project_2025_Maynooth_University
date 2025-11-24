double[] lapTime(double[][] telemetry, double[][] speeds, int steps, double ratio) 
{
    double totalTime = 0.0;

    for (int i = 1; i < steps; i++) {
        double dx = speeds[i][0] - speeds[i-1][0];
        double dy = speeds[i][1] - speeds[i-1][1];

        double s = Math.sqrt(dx*dx + dy*dy) / ratio;

        double v = telemetry[i][2];

        totalTime += (s / v);
    }

    int minutes = (int)(totalTime / 60.0);
    double seconds = totalTime - (minutes * 60.0);

    System.out.printf("FINAL LAP TIME: %.3f seconds\n", totalTime);
    System.out.printf("Lap Time = %02d:%06.3f\n", minutes, seconds);

    return new double[] { minutes, seconds };
}
