/*
Method used to initialise the circle,

Method should posses track length,
should grab the co-ordinates of the manually inputed waypoints,
should posses the position of the waypoint at the start and end of the 2nd spline pass, in order to get a smooth 
*/

void basicCircle(int steps,boolean excel,boolean showWaypoints,boolean showPoints,boolean showSpeeds)
{
    int mTrackLength = 100;                                                                                   //Circle Length of 100 meters
    double[] x = getXCircle();                                                                                //Retrieve x co-ordinates of circle
    double[] y = getYCircle();                                                                                //Retrieve x co-ordinates of circle
    int start = 5;                                                                                            //Start of 2nd Spline pass at point 4
    int end = 5;                                                                                              //End of 2nd Spine pass at point array.length - 5
    main(x,y,start,end,steps,mTrackLength,showWaypoints,showPoints,showSpeeds,excel);                         //Call Main method in order to calculate splines, draw track and run tests
}

/*
Method containing x co-ordinates of circle
*/

double [] getXCircle()
{
 double[] x = {500, 800, 1100, 800, 500, 800, 1100, 800, 500, 800, 1100, 800, 500};
 
 return x;
}

/*
Method containing y co-ordinates of circle
*/
 
double [] getYCircle()
{
 double[] y = {400, 100, 400, 700, 400, 100, 400, 700, 400, 100, 400, 700, 400};
 
  return y;
}
