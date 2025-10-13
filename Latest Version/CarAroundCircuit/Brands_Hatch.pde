void brandsHatch(int steps)
{
    boolean showWaypoints = false;
    boolean showPoints = false;
    boolean showSpeeds = false;
    int mTrackLength = 1944;
    double[] x = getXBrands();  //Get X
    double[] y = getYBrands();  //Get Y
    double ratio = ratio(x,y,20,21,steps,mTrackLength);
    double [] [] trackPoints = drawTrack(x,y,20,21,steps); //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap, Length in m desired
    double [] [] radius = radius(trackPoints,steps,ratio);
    double [] [] speeds = maxSpeed(radius,steps);
    visualisation(x,y,speeds,steps,showWaypoints,showPoints,showSpeeds);
    carAroundTrack(trackPoints,speeds);
    saveSpeedsToExcel(radius,steps,getTyres());
    tests(trackPoints,speeds,radius,steps);
}

//BRANDS HATCH
double [] getXBrands()
{
  double[] x = {395, 200, 110, 88, 112, 175, 240, 270, 215, 235, 310, 400, 520, 555, 580, 630, 690, 765, 705, 600,
                395, 200, 110, 88, 112, 175, 240, 270, 215, 235, 310, 400, 520, 555, 580, 630, 690, 765, 705, 600,
                395, 200, 110, 88, 112, 175, 240, 270, 215, 235, 310, 400, 520, 555, 580, 630, 690, 765, 705, 600, 395};
  return x;
}

double [] getYBrands()
{
  double[] y = {470, 470, 410, 320, 250, 130, 94, 160, 280, 345, 365, 370, 362, 332, 280, 240, 240, 300, 400, 460,
                470, 470, 410, 320, 250, 130, 94, 160, 280, 345, 365, 370, 362, 332, 280, 240, 240, 300, 400, 460,
                470, 470, 410, 320, 250, 130, 94, 160, 280, 345, 365, 370, 362, 332, 280, 240, 240, 300, 400, 460, 470};
  return y;
}
