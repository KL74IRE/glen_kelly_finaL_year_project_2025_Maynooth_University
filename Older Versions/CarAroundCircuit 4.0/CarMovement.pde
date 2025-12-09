double [] [] carAroundTrack(double [] [] speeds,double ratio, double steps)
{
  double [] car = new double [3];
  car [0] = getAcceleration();
  car [1] = getDeceleration();
  car [2] = 0;
  double [] [] telemetry = new double [(int)steps][3];
  telemetry [0] [0] = speeds [0] [0];
  telemetry [0] [1] = speeds [0] [1];
  telemetry [0] [2] = 0;
  println("point: (" + telemetry [0] [0] + "," + telemetry [0] [1]+ "), velocity: " + telemetry [0] [2]);
  
  //s = (u*t) + (1/2)*(a)*(t*t)
  //(v*v) = (u*u) + (2)*(a)*(s)
  
  
  for(int i =1; i< steps-1; i++)
  {
    telemetry [i] [0] = speeds [i] [0];
    telemetry [i] [1] = speeds [i] [1];
    double x1 = telemetry [i] [0], x2 = telemetry [i+1] [0], y1 = telemetry [i] [1], y2 = telemetry [i+1] [1];
    double s = sqrt((float)(((x2-x1)*(x2-x1)) + ((y2-y1)*(y2-y1))));
    s = s / ratio;
    println("sqrt(("+ x2 + "-" + x1 + ")^2 + ("+ y2 + "-" + y1 + ")^2)");
    telemetry [i] [2] = sqrt((float)((telemetry [i-1] [2])*(telemetry [i-1] [2])+(2*car[0]*s)));
    println("sqrt(("+ telemetry [i-1] [2] + ")^2 + ("+ 2 + "*" + car[0] + "*" + s + ")");
    println("v_calc=" + telemetry[i][2] + "  v_max=" + speeds[i][3]);
    if (telemetry[i][2] > speeds[i][3]) {
      telemetry[i][2] = speeds[i][3];
      println("TOO FAST! -> clamped to " + telemetry[i][2]);
    }

    println("point: (" + telemetry [i] [0] + "," + telemetry [i] [1]+ "), velocity: " + telemetry [i] [2]);
  }
  
  return telemetry;
  
}
