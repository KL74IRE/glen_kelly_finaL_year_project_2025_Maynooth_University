/*
Main Method of each circuit run

Method should call a method to calculate and retrieve the ratio of the circuit between pixels and meters,
should call a method to calculate,draw and retrieve the spline points and vertex's,
should call a method to calculate and retrieve the radius of the corners at each spline point,
should call a method that visualises all the data on screen that is requested,
should call a method to move into car simulation around the track,
should call a method to send speed telemetry to excel
should call a method to run tests on existing methods

*/
void main(double [] x,double [] y,int start,int end, int steps,int mTrackLength, boolean showWaypoints,boolean showPoints,boolean showSpeeds, boolean excel, boolean telemetryS, boolean showTPs)
{
    double ratio = ratio(x,y,start,end,steps,mTrackLength);
    double [] [] trackPoints = getSpline(x,y,start,end,steps);
    double [] [] [] points = get2DPoints(trackPoints,steps, showTPs);
    double [] [] [] radius = radius(points,steps,ratio);
    double [] [] [] speeds = maxSpeed(radius,steps); 
    double [] [] [] telemetry = carAroundTrack(speeds,ratio,steps);
    double [] []  lapTime = lapTime(telemetry, speeds, steps ,ratio);
    drawLapTimes(lapTime);
    drawTrack(x, y, 800, 10.0);
    visualisationAllLanes(x, y, speeds, telemetry, steps, showWaypoints, showPoints, showSpeeds, telemetryS, lapTime);
    if(excel){saveSpeedsToExcel(radius,steps,getTyres(),telemetry);}
}
