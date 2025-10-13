void tests(double [] [] trackPoints,double [] [] speeds, double [] [] radius, double steps)
{
  checkPoints(trackPoints,speeds,radius,steps);
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
     System.out.println("Test: checkPoints has failed at point: " + point);
     System.out.println("     x: Track Points: " + trackPoints [point][0] + ", Radius: " + radius [point][0] + ", Speeds: " + speeds [point][0]);
     System.out.println("     y: Track Points: " + trackPoints [point][1] + ", Radius: " + radius [point][1] + ", Speeds: " + speeds [point][1]);
     System.out.println("   ");
   }
   else
   {
     System.out.println("Test: checkPoints has passed!" + point);
     System.out.println("   ");
   }
}

void checkRadius()
{
  
}
