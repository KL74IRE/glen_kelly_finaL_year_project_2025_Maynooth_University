import java.time.LocalTime;

void tests(double [] [] trackPoints,double [] [] speeds, double [] [] radius, double steps)
{
  System.out.println("Tests running at: " + LocalTime.now());
  checkPoints(trackPoints,speeds,radius,steps);
  checkRadius();
  System.out.println("   ");
}

void checkPoints(double [] [] trackPoints,double [] [] speeds, double [] [] radius, double steps)
{
   boolean flag = false; 
   int point = 0;
   for(int i = 0; i< steps; i++)
   { 
      if(trackPoints [i][0] == speeds [i][0] && trackPoints [i][1] == speeds [i][1])
      {
        if(trackPoints [i][0] == speeds [i][0] && trackPoints [i][1] == radius [i][1])
        {
          //No Action
        }
        else
        {
          flag = true;
          point = i;
        }
      }
      else
      {
        flag = true;
        point = i;
      }
   }
   if(flag)
   {
     //System.out.println("Test: checkPoints has failed at point: " + point);
     //System.out.println("     x: Track Points: " + trackPoints [point][0] + ", Radius: " + radius [point][0] + ", Speeds: " + speeds [point][0]);
     //System.out.println("     y: Track Points: " + trackPoints [point][1] + ", Radius: " + radius [point][1] + ", Speeds: " + speeds [point][1]);
   }
   else
   {
     for( int i = 0; i< steps; i++){
     System.out.println("     x: Track Points: " + trackPoints [i][0] + ", Radius: " + radius [i][0] + ", Speeds: " + speeds [i][0]);
     System.out.println("     y: Track Points: " + trackPoints [i][1] + ", Radius: " + radius [i][1] + ", Speeds: " + speeds [i][1]);}
     System.out.println("Test: checkPoints has passed!");
   }
}

void checkRadius()
{
  double x1 = 0, y1 = 1;
  double x2 = 1, y2 = 0;
  double x3 = -1,y3 = 0;

  double radius = getRadius(x1,y1,x2,y2,x3,y3);
  
  if(radius == 1)
  {
     System.out.println("Test: checkRadius has passed!");
     System.out.println("   ");
  }
  
  else
  {
     System.out.println("Test: checkPoints has failed!");
     System.out.println("   ");
  }
}
