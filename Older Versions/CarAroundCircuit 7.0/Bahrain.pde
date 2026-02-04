/*
Method used to initialise the Bahrain GP circuit,

Method should posses track length,
should grab the co-ordinates of the manually inputed waypoints,
should posses the position of the waypoint at the start and end of the 2nd spline pass, in order to get a smooth 
*/

void bahrain(int steps, boolean excel,boolean showWaypoints,boolean showPoints,boolean showSpeeds,boolean telemetryS, boolean showTPs)
{
    int mTrackLength = 5412;                                                                                //Bahrain GP Circuit Length of 5412 meters
    double[] x = getXBahrain();                                                                             //Retrieve x co-ordinates of Bahrain GP Circuit
    double[] y = getYBahrain();                                                                             //Retrieve y co-ordinates of Bahrain GP Circuit
    int start = 34;                                                                                         //Start of 2nd Spline pass at point 33
    int end = 36;                                                                                           //End of 2nd Spine pass at point array.length - 35
    main(x,y,start,end,steps,mTrackLength,showWaypoints,showPoints,showSpeeds,excel,telemetryS, showTPs);                       //Call Main method in order to calculate splines, draw track and run tests
}

/*
Method containing x co-ordinates of Bahrain GP circuit
*/

double [] getXBahrain()
{
  double[] x = {1093, 480, 400, 448, 416, 460, 490, 570, 630, 705, 760, 795, 798, 796, 810, 845, 965, 985, 940, 680, 595, 570, 693, 1220, 1288, 1250, 1177, 1064, 1092, 1231, 1520, 1590, 1540, 1400,
                1093, 480, 400, 448, 416, 460, 490, 570, 630, 705, 760, 795, 798, 796, 810, 845, 965, 985, 940, 680, 595, 570, 693, 1220, 1288, 1250, 1177, 1064, 1092, 1231, 1520, 1590, 1540, 1400,
                1093, 480, 400, 448, 416, 460, 490, 570, 630, 705, 760, 795, 798, 796, 810, 845, 965, 985, 940, 680, 595, 570, 693, 1220, 1288, 1250, 1177, 1064, 1092, 1231, 1520, 1590, 1540, 1400, 1093};
  return x;
}

/*
Method containing x co-ordinates of Bahrain GP circuit
*/

double [] getYBahrain()
{
  double[] y = {870,  870, 870, 785, 650, 350, 130, 115, 190, 258, 280, 310, 350, 400, 440, 472, 560, 595, 608, 574, 590, 650, 672, 672,  580,  520,  483,  395,  245,  220,  700,  795,  865,  866,
                870,  870, 870, 785, 650, 350, 130, 115, 190, 258, 280, 310, 350, 400, 440, 472, 560, 595, 608, 574, 590, 650, 672, 672,  580,  520,  483,  395,  245,  220,  700,  795,  865,  866,
                870,  870, 870, 785, 650, 350, 130, 115, 190, 258, 280, 310, 350, 400, 440, 472, 560, 595, 608, 574, 590, 650, 672, 672,  580,  520,  483,  395,  245,  220,  700,  795,  865,  866,  870};
  return y;
}
