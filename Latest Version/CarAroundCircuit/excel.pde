PrintWriter output; //PrintWriter setup

/*
Method to create an excel sheet containing as much telemetry that is available from the track

This version:
- Removes x, y, and radius from the CSV
- Only outputs point number and speeds for Soft, Medium, and Hard tyres
*/

void saveSpeedsToExcel(double[][] radius, int steps, double[] tyres) {
  PrintWriter output = createWriter("data.csv");                                                                //Create .csv file

  output.println("Point,Max Speed (Soft km/h),Max Speed (Medium km/h),Max Speed (Hard km/h)");                   //Output Header

  for (int i = 0; i < steps; i++) {                                                                             //For all Points
    double r = radius[i][2];                                                                                    //Get radius (still needed for speed calc)

    double speeds = 3.6 * Math.sqrt(tyres[0] * 9.81 * r);                                                       //Get max speed on soft tyre
    double speedm = 3.6 * Math.sqrt(tyres[1] * 9.81 * r);                                                       //Get max speed on medium tyre
    double speedh = 3.6 * Math.sqrt(tyres[2] * 9.81 * r);                                                       //Get max speed on hard tyre

    // Cap all speeds at 360
    if (speeds > 360) speeds = 360;
    if (speedm > 360) speedm = 360;
    if (speedh > 360) speedh = 360;

    // Output only point number and speeds
    output.println(i + "," + speeds + "," + speedm + "," + speedh);
  }

  output.flush();                                                                                               //Flush Data
  output.close();                                                                                               //Close File
  println("✅ Data saved to data.csv!");                                                                        //Success Message
  println("  ");
}
