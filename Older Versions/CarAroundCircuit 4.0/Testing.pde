import java.time.LocalTime; //Grabs Local Time

/*
Method to run tests on existing methods.

Method should grab loacl time,
should check all points throughout the program match,
should check that the radius method works as intended
*/

void tests(double [] [] trackPoints,double [] [] speeds, double [] [] radius, double steps)
{
  System.out.println("Tests running at: " + LocalTime.now());                                 //Prints Local Time
  checkPoints(trackPoints,speeds,radius,steps);                                               //Checks points throughout calculations to ensure all match
  checkRadius();                                                                              //Checks radius method works successfully
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
   boolean flag = false;                                                                    //Error Flag
   int point = 0;                                                                           //Point of error
   for(int i = 0; i< steps; i++)                                                            //All points
   { 
      if(trackPoints [i][0] == speeds [i][0] && trackPoints [i][1] == speeds [i][1])        //compare speeds to track Points
      {
        if(trackPoints [i][0] == speeds [i][0] && trackPoints [i][1] == radius [i][1])      //compare track points to radius
        {
                                                                                            //All Match - No Action
        }
        else
        {
          flag = true;                                                                      //Discrepency found, Flag
          point = i;                                                                        //Mark point of discrepency
        }
      }
      else
      {
        flag = true;                                                                        //Discrepency found, Flag
        point = i;                                                                          //Mark point of discrepency
      }
   }
   if(flag)                                                                                 //If Flag
   {
     System.out.println("Test: checkPoints has failed at point: " + point);                 //Error Messages
     System.out.println("     x: Track Points: " + trackPoints [point][0] + ", Radius: " + radius [point][0] + ", Speeds: " + speeds [point][0]);
     System.out.println("     y: Track Points: " + trackPoints [point][1] + ", Radius: " + radius [point][1] + ", Speeds: " + speeds [point][1]);
   }
   else                                                                                     //else
   {                                                                                        //Pass Messages
     //for( int i = 0; i< steps; i++){
     //System.out.println("     x: Track Points: " + trackPoints [i][0] + ", Radius: " + radius [i][0] + ", Speeds: " + speeds [i][0]);
     //System.out.println("     y: Track Points: " + trackPoints [i][1] + ", Radius: " + radius [i][1] + ", Speeds: " + speeds [i][1]);}
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
  double x1 = 0, y1 = 1;                                      //x1 , y1
  double x2 = 1, y2 = 0;                                      //x2 , y2
  double x3 = -1,y3 = 0;                                      //x3 , y3

  double radius = getRadius(x1,y1,x2,y2,x3,y3);               // Send all 3 pointst to getRadius()
  
  if(radius == 1)                                             //If expected radius is returned
  {
     System.out.println("Test: checkRadius has passed!");       //Success Message
     System.out.println("   ");
  }
  
  else                                                        //Else
  {
     System.out.println("Test: checkPoints has failed!");       //Fail Message
     System.out.println("   ");
  }
}
