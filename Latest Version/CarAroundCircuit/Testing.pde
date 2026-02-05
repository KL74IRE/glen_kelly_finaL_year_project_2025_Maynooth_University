import java.time.LocalTime; //Grabs Local Time

/*
Method to run tests on existing methods.

Method should grab loacl time,
should check all points throughout the program match,
should check that the radius method works as intended
*/

void tests(double [] [] trackPoints,double [] [] speeds, double [] [] radius, double steps)
{
  System.out.println("Tests running at: " + LocalTime.now());
  checkPoints(trackPoints,speeds,radius,steps);
  checkRadius();
  System.out.println("   ");
}

/*
Method to ensure (x,y) values throughout the program matches.

Method should initialise a boolean to represent no problem found,
should initialise a point marker in order to show where the problem was found,
should start a nested for loop in which track points is compared to speeds, which is subsequently compared to steps,
  if all match - no flag
  if no match - flag
should a flag be found output the information to the user,
else Success message
*/

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
  }
  else
  {
    System.out.println("Test: checkPoints has passed!");
  }
}

/*
Method to run test on radius calculation method.

Method should initialise 3 points with a known radius,
should pass them to the calculation method and retrieve a radius,
should check the radius against expected result,
should output either pass or fail messages
*/
void checkRadius()
{
  double x1 = 0, y1 = 1;
  double x2 = 1, y2 = 0;
  double x3 = -1, y3 = 0;

  double radius = getRadius(x1, y1, x2, y2, x3, y3);
  
  if(radius == 1)
  {
     System.out.println("Test: checkRadius has passed!");
  }
  else
  {
     System.out.println("Test: checkPoints has failed!");
  }
}
}
