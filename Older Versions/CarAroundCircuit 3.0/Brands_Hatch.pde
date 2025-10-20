/*
Method used to initialise the Brands Hatch Indy circuit,

Method should posses track length,
should grab the co-ordinates of the manually inputed waypoints,
should posses the position of the waypoint at the start and end of the 2nd spline pass, in order to get a smooth 
*/

void brandsHatch(int steps, boolean excel,boolean showWaypoints,boolean showPoints,boolean showSpeeds)
{
    int mTrackLength = 1944;                                                                                //Brands Hatch Indy Circuit Length of 1944 meters
    double[] x = getXBrands();                                                                              //Retrieve x co-ordinates of Brands Hatch Indy Circuit
    double[] y = getYBrands();                                                                              //Retrieve y co-ordinates of Brands Hatch Indy Circuit
    int start = 24;                                                                                         //Start of 2nd Spline pass at point 33
    int end = 25;                                                                                           //End of 2nd Spine pass at point array.length - 35
    main(x,y,start,end,steps,mTrackLength,showWaypoints,showPoints,showSpeeds,excel);                       //Call Main method in order to calculate splines, draw track and run tests
}

/*
Method containing x co-ordinates of Brands Hatch Indy Circuit
*/

double [] getXBrands()
{
  double[] x = {850, 600, 340, 226, 279, 422, 545, 602, 493, 483, 540, 680, 770, 860, 1100, 1172, 1202, 1270, 1390, 1519, 1549, 1515, 1420, 1220,
                850, 600, 340, 226, 279, 422, 545, 602, 493, 483, 540, 680, 770, 860, 1100, 1172, 1202, 1270, 1390, 1519, 1549, 1515, 1420, 1220,
                850, 600, 340, 226, 279, 422, 545, 602, 493, 483, 540, 680, 770, 860, 1100, 1172, 1202, 1270, 1390, 1519, 1549, 1515, 1420, 1220, 850};
  return x;
}

/*
Method containing x co-ordinates of Brands Hatch Indy Circuit
*/

double [] getYBrands()
{
  double[] y = {850, 857, 797, 600, 400, 130, 88,  210, 450, 540, 600, 638, 648, 645, 627,  590,  510,  420,  370,  430,  560,  670,  764,  835,
                850, 857, 797, 600, 400, 130, 88,  210, 450, 540, 600, 638, 648, 645, 627,  590,  510,  420,  370,  430,  560,  670,  764,  835,
                850, 857, 797, 600, 400, 130, 88,  210, 450, 540, 600, 638, 648, 645, 627,  590,  510,  420,  370,  430,  560,  670,  764,  835, 850};
  return y;
}
