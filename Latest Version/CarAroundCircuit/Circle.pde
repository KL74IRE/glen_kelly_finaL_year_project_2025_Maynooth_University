void basicCircle(int steps,boolean excel,boolean showWaypoints,boolean showPoints,boolean showSpeeds)
{
    int mTrackLength = 1944;
    double[] x = getXCircle();  //Get X
    double[] y = getYCircle();  //Get Y
    int start = 4;
    int end = 5;
    main(x,y,start,end,steps,mTrackLength,showWaypoints,showPoints,showSpeeds,excel);
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
