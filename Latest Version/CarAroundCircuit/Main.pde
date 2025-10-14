void main(double [] x,double [] y,int start,int end, int steps,int mTrackLength, boolean showWaypoints,boolean showPoints,boolean showSpeeds, boolean excel)
{
    double ratio = ratio(x,y,start,end,steps,mTrackLength);
    double [] [] trackPoints = drawTrack(x,y,start,end,steps);
    double [] [] radius = radius(trackPoints,steps,ratio);
    double [] [] speeds = maxSpeed(radius,steps);
    visualisation(x,y,speeds,steps,showWaypoints,showPoints,showSpeeds);
    carAroundTrack(trackPoints,speeds);
    if(excel){saveSpeedsToExcel(radius,steps,getTyres());}
    tests(trackPoints,speeds,radius,steps);
}
