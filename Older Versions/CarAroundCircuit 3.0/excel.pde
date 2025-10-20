PrintWriter output; //PrintWriter setup

/*
Method to create an excel sheet containing as much telemetry that is available from the track

Method should Create the .csv file,
should create a header,
should input the x,y co-ordinates,
should input the radius of the corner,
should calculate the max speed for all tyres,
should cap all speeds at 360km/h representing top speed,
should output the information to the sheet,
should finalise the sheet and export it,
Should send a message to advise user that sheet is created.
*/

void saveSpeedsToExcel(double[][] radius, int steps, double[] tyres) {
  PrintWriter output = createWriter("data.csv");                                                                //Create .csv file

  output.println("Point,x,y,Radius (m),Max Speed (Soft km/h),Max Speed (Medium km/h),Max Speed (Hard km/h)");   //Output Header

  for (int i = 0; i < steps; i++) {                                                                             //For all Points
    double x = radius[i][0];                                                                                      //Get x
    double y = radius[i][1];                                                                                      //Get y
    double r = radius[i][2];                                                                                      //Get radius

    double speeds = 3.6 * Math.sqrt(tyres[0] * 9.81 * r);                                                         //Get max speed on soft tyre
    double speedm = 3.6 * Math.sqrt(tyres[1] * 9.81 * r);                                                         //Get max speed on medium tyre
    double speedh = 3.6 * Math.sqrt(tyres[2] * 9.81 * r);                                                         //Get max speed on hard tyre

    if (speeds > 360) speeds = 360; if (speedm > 360) speedm = 360; if (speedh > 360) speedh = 360;               //cap all speeds at 360

    output.println(i + "," + x + "," + y + "," + r + "," + speeds + "," + speedm + "," + speedh);                 //Output data line by line
  }

  output.flush();                                                                                               //Flush Data
  output.close();                                                                                               //Close File
  println("✅ Data saved to data.csv!");                                                                        //Success Message
  println("  ");
}
