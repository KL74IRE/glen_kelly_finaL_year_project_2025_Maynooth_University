void checkPoints(double [] [] trackPoints,double [] [] speeds, double [] [] radius, double steps)
{
  
  int flag = -1;
  for(int i = 0; i < steps; i++)
  {
    println(trackPoints[i][0] + "vrs" +  radius[i][0]);
  }
  
  for(int i = 0; i < steps; i++)
  {
    if(speeds[i][0] != trackPoints[i][0])
    {
      flag = i;
    }
    println(flag);
  }
}
