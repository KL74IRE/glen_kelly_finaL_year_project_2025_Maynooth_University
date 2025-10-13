void basicCircle(int steps)
{
    boolean showWaypoints = true;
    boolean showPoints = true;
    boolean showSpeeds = true;
    int mTrackLength = 1944;
    double[] x = getXCircle();  //Get X
    double[] y = getYCircle();  //Get Y
    double ratio = ratio(x,y,4,5,steps,mTrackLength);
    double [] [] trackPoints = drawTrack(x,y,4,5,steps); //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap, Length in m desired
    double [] [] radius = radius(trackPoints,steps,ratio);
    double [] [] speeds = maxSpeed(radius,steps);
    visualisation(x,y,speeds,steps,showWaypoints,showPoints,showSpeeds);
    carAroundTrack(trackPoints,speeds);
    tests(trackPoints,speeds,radius,steps);
}

//CIRCLE
double [] getXCircle()
{
 double[] x = {900, 1000, 1100, 1000, 900, 1000, 1100, 1000, 900, 1000, 1100, 1000, 900};
 
 return x;
}
 
double [] getYCircle()
{
 double[] y = {200, 100, 200, 300, 200, 100, 200, 300, 200, 100, 200, 300, 200};
 
  return y;
}
