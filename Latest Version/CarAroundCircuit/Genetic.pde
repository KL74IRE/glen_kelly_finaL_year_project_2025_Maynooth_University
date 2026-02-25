double getGeneticBestLap(double [][][] points, double ratio, int steps)
{
  int generations = 5000;
  double [] [] [] bestTimes = new double [generations][5][2];  //Records 5 best times from each generation [generation][time][0=x][1=y]
  
  for(int i = 0; i < generations; i++)
  {
    //points[i(where 0 is outer track,1 is center track,2 is inner track)][step along track points n][0 = x, 1 = y]
    //Ratio is difference from m to pixels
    
    //choose a point along line between x,y at i = 0 and i = 2 for all steps
    
    //Calculate a Lap Time
    double [] radius = new double [steps];
    double [] speed = new double [steps];
    for(int j = 0; j < steps; j++)
    {
      //Calculate the radius of the corner from n-1, n, n + 1
      radius [j] = getRadius(x1,y1,x2,y2,x3, y3);
      
      //Calculate the max speed at each point
      double tyres [] = getTyres();
      speed [j] = ((Math.sqrt(((float)tyres[0])*(9.81)*((float)radius [j] [i] [2]))));
      
      //Get Telemetry by adapting this code for a single lap
      double [] telemetry = getTelemetry();
    }
  }
}

double [] getTelemetry()
{
  double [] telemetry;
  
  /*double[][][] carAroundTrack(double[][][] speeds, double ratio, int steps)
  {
    double accel = getAcceleration();
    double decel = Math.abs(getDeceleration());
  
    double[][][] telemetry = new double[3][steps][4];
  
    for (int j = 0; j < 3; j++) {
      telemetry[j][0][0] = speeds[j][0][0];
      telemetry[j][0][1] = speeds[j][0][1];
      telemetry[j][0][2] = 0.0;
      telemetry[j][0][3] = 0.0;
  
      for (int i = 1; i < steps; i++) {
        telemetry[j][i][0] = speeds[j][i][0];
        telemetry[j][i][1] = speeds[j][i][1];
  
        double dx = telemetry[j][i][0] - telemetry[j][i - 1][0];
        double dy = telemetry[j][i][1] - telemetry[j][i - 1][1];
        double s  = Math.sqrt(dx * dx + dy * dy) / ratio;
  
        double vPrev = telemetry[j][i - 1][2];
        double vCalc = Math.sqrt(vPrev * vPrev + 2.0 * accel * s);
        double vMax  = speeds[j][i][3];
  
        telemetry[j][i][2] = Math.min(vCalc, vMax);
      }
  
      for (int i = steps - 2; i >= 0; i--) {
        double dx = telemetry[j][i + 1][0] - telemetry[j][i][0];
        double dy = telemetry[j][i + 1][1] - telemetry[j][i][1];
        double s  = Math.sqrt(dx * dx + dy * dy) / ratio;
  
        double vNext  = telemetry[j][i + 1][2];
        double vBrake = Math.sqrt(vNext * vNext + 2.0 * decel * s);
  
        if (vBrake < telemetry[j][i][2]) {
          telemetry[j][i][2] = vBrake;
        }
      }
    }
  
    return telemetry;
  }*/

return telemetry;
}
