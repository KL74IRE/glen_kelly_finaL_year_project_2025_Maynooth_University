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
void main(double [] x,double [] y,int start,int end, int steps,int mTrackLength, boolean showWaypoints,boolean showPoints,boolean showSpeeds, boolean excel, boolean telemetryS)
{
    double ratio = ratio(x,y,start,end,steps,mTrackLength);                             //Calls Method to retrieve ratio
    double [] [] trackPoints = drawTrack(x,y,start,end,steps);                          //Calls Method to retrieve track points
    double [] [] radius = radius(trackPoints,steps,ratio);                              //Calls Method to retrieve radius of track points
    double [] [] speeds = maxSpeed(radius,steps);                                       //Calls Method to retrieve max speeds at track points
    double [] [] telemetry = carAroundTrack(speeds,ratio,steps);                        //Calls Method to move to next step and start a car simulation
    double [] lapTime = lapTime(telemetry,mTrackLength,steps);
    visualisation(x, y, speeds, telemetry, steps, showWaypoints, showPoints, showSpeeds, telemetryS, lapTime);     //Calls Method to visualise requested data
    if(excel){saveSpeedsToExcel(radius,steps,getTyres(),telemetry);}                              //Calls a method to output speed data to excel
    tests(trackPoints,speeds,radius,steps);                                             //Calls a method to run tests
}
