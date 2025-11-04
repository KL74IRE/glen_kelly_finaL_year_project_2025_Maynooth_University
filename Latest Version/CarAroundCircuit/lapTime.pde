double lapTime(double [] []telemetry, int mTrackLength,int steps)
{
  double segmentLength = mTrackLength/steps;
  double lapTime = 0;
  int minutes = 0;
  double seconds = 0;
  for(int i = 0; i < steps; i++)
  {
    double segmentTime = segmentLength/telemetry [i][2];
    lapTime = lapTime + segmentTime;
    minutes = (int)(lapTime / 60);
    seconds = lapTime % 60;
    System.out.println("Step : " + i + ", Step Length = "+ segmentLength + ", Segment Speed = " + telemetry [i][2] + ", Segment Time = " + segmentTime + ", Total Time = " + lapTime + " = " + minutes + ":" + seconds);
    
  }
  
  return lapTime;
}
