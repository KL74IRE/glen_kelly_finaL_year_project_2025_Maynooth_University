PrintWriter output;

void saveSpeedsToExcel(double[][] radius, int steps, double[] tyres) {
  PrintWriter output = createWriter("data.csv");

  // Header
  output.println("Point,x,y,Radius (m),Max Speed (Soft km/h),Max Speed (Medium km/h),Max Speed (Hard km/h)");

  for (int i = 0; i < steps; i++) {
    double x = radius[i][0];
    double y = radius[i][1];
    double r = radius[i][2];

    // Calculate speeds
    double speeds = 3.6 * Math.sqrt(tyres[0] * 9.81 * r);
    double speedm = 3.6 * Math.sqrt(tyres[1] * 9.81 * r);
    double speedh = 3.6 * Math.sqrt(tyres[2] * 9.81 * r);

    // Cap at 360 km/h
    if (speeds > 360) speeds = 360;
    if (speedm > 360) speedm = 360;
    if (speedh > 360) speedh = 360;

    output.println(i + "," + x + "," + y + "," + r + "," + speeds + "," + speedm + "," + speedh);
  }

  output.flush();
  output.close();
  println("✅ Data saved to data.csv!");
  println("  ");
}
