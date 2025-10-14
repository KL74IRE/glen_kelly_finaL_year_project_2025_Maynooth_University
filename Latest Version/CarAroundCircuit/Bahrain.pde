void bahrain(int steps, boolean excel,boolean showWaypoints,boolean showPoints,boolean showSpeeds)
{
    int mTrackLength = 1944;
    double[] x = getXBrands();  //Get X
    double[] y = getYBrands();  //Get Y
    int start = 24;
    int end = 25;
    main(x,y,start,end,steps,mTrackLength,showWaypoints,showPoints,showSpeeds,excel);
}

//BRANDS HATCH
double [] getXBahrain()
{
  double[] x = {1093, 430, 395, 420, 448, 440, 420, 416, 495, 525, 570, 630, 705, 760, 795, 798, 796, 810, 845, 965, 985, 940};
  return x;
}

double [] getYBahrain()
{
  double[] y = {870,  870, 858, 817, 785, 750, 700, 650, 130, 90, 115, 190, 258, 280, 310, 350, 400, 440, 472, 560, 595, 608};
  return y;
}
