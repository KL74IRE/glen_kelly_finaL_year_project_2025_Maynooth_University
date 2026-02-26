void brandsHatch(int steps, boolean excel,boolean showWaypoints,boolean showPoints,boolean showSpeeds, boolean telemetryS, boolean showTPs)
{
  int mTrackLength = 1944;
  double[] x = getXBrands();
  double[] y = getYBrands();
  int start = 24;
  int end = 26;
  main(x,y,start,end,steps,mTrackLength,showWaypoints,showPoints,showSpeeds,excel, telemetryS, showTPs);
}

double [] getXBrands()
{
  double[] x = {850, 600, 340, 226, 279, 422, 545, 602, 493, 483, 540, 680, 770, 860, 1100, 1172, 1202, 1270, 1390, 1519, 1549, 1515, 1420, 1220,
        850, 600, 340, 226, 279, 422, 545, 602, 493, 483, 540, 680, 770, 860, 1100, 1172, 1202, 1270, 1390, 1519, 1549, 1515, 1420, 1220,
        850, 600, 340, 226, 279, 422, 545, 602, 493, 483, 540, 680, 770, 860, 1100, 1172, 1202, 1270, 1390, 1519, 1549, 1515, 1420, 1220, 850};
  return x;
}

double [] getYBrands()
{
  double[] y = {850, 857, 797, 600, 400, 130, 88,  210, 450, 540, 600, 638, 648, 645, 627,  590,  510,  420,  370,  430,  560,  670,  764,  835,
        850, 857, 797, 600, 400, 130, 88,  210, 450, 540, 600, 638, 648, 645, 627,  590,  510,  420,  370,  430,  560,  670,  764,  835,
        850, 857, 797, 600, 400, 130, 88,  210, 450, 540, 600, 638, 648, 645, 627,  590,  510,  420,  370,  430,  560,  670,  764,  835, 850};
  return y;
}
