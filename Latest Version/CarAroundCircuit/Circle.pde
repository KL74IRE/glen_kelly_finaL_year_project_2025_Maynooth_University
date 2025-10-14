void basicCircle(int steps,boolean excel,boolean showWaypoints,boolean showPoints,boolean showSpeeds)
{
    int mTrackLength = 1944;
    double[] x = getXCircle();  //Get X
    double[] y = getYCircle();  //Get Y
    int start = 4;
    int end = 5;
    double ratio = ratio(x,y,start,end,steps,mTrackLength);
    double [] [] trackPoints = drawTrack(x,y,start,end,steps); //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap, Length in m desired
    double [] [] radius = radius(trackPoints,steps,ratio);
    double [] [] speeds = maxSpeed(radius,steps);
    visualisation(x,y,speeds,steps,showWaypoints,showPoints,showSpeeds);
    carAroundTrack(trackPoints,speeds);
    if(excel){saveSpeedsToExcel(radius,steps,getTyres());}
    tests(trackPoints,speeds,radius,steps);
}

//CIRCLE
double [] getXCircle()
{
 double[] x = {500, 800, 1100, 800, 500, 800, 1100, 800, 500, 800, 1100, 800, 500};
 
 return x;
}
 
double [] getYCircle()
{
 double[] y = {400, 100, 400, 700, 400, 100, 400, 700, 400, 100, 400, 700, 400};
 
  return y;
}
