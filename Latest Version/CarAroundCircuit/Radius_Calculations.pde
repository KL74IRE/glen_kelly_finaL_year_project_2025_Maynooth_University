/*
Method to take in points, steps and ratio of pixels to meters and return radius values in meters

Method should be able to setup a 2D array to be able to hold x,y and radius values,
should be able to individually calculate first and last radius values due to looping,
should be able to calculate the rest of the points within a loop
should be able to convert all radius values to meters from pixels
*/

double [] [] [] radius(double [] [] [] points, int steps, double ratio)
{
  double radius [] [] []  = new double [3] [steps] [3];                                           //Set up 2D array to be able to hold x, y and radius
  for(int i=0; i<3; i++)
  {
  radius [i] [0] [0] = (points [i] [0] [0]);                                                      //Set x value
  radius [i] [0] [1] = (points [i] [0] [1]);                                                      //Set y value
  radius [i] [0] [2] = getRadius(points [i][steps-2][0],  points [i] [steps-2][1],                   //Get radius using 3 points (x1, y1, x2, y2, x3, y3)
                              points [i][0]      [0],  points [i][0]      [1],
                              points [i][1]      [0],  points [i][1]      [1]);
  radius [i] [0] [2] = (radius [i] [0] [2] /ratio);                                               //Convert radius from pixels into meters
                              
  radius [i] [steps-1] [0] = points [i] [steps-1] [0];                                            //Set x value
  radius [i] [steps-1] [1] = points [i] [steps-1] [1];                                            //Set y value
  radius [i] [steps-1] [2] = getRadius(points [i] [steps-2][0],  points [i] [steps-2][1],             //Get radius using 3 points (x1, y1, x2, y2, x3, y3)
                                    points [i] [steps-1][0],  points [i][steps-1][1],
                                    points [i] [1]      [0],  points [i][1]      [1]);
  radius [i] [steps-1] [2] = (radius [i] [steps-2] [2] /ratio);
   
  for(int j = 1; j < (steps -1) ; j++)                                                    //Loop through remaining points
  {
    radius [i][j] [0] = points [i][j] [0];                                                        //Set x value
    radius [i][j] [1] = points [i][j] [1];                                                        //Set y value
    radius [i][j] [2] = getRadius(points [i][j-1][0],  points [i][j-1][1],                           //Get radius using 3 points (x1, y1, x2, y2, x3, y3)
                               points [i][j]  [0],  points [i][j]  [1],
                               points [i][j+1][0],  points [i][j+1][1]);
    radius [i][j] [2] = (radius [i][j] [2] /ratio);                                               //Convert radius from pixels into meters
  }
  }
  
  return radius;                                                                          //return radius in meters
}

/*
Method to take in 3 points and calculate the radius by getting the circumcenter and length forumla

Method should calculate the determinant of the triangle created,
should calculate the circumcenter of the triangle,
should calculate the radius of the given circle by getting the distance from (x1,y1) to (cx, cy)
should return the radius in terms of pixels
*/

double getRadius(double x1, double y1, double x2, double y2, double x3, double y3)
{
  double d = 2 * (x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2));                            //Calculate the determinant of the triangle
  
  double cx = ((x1*x1 + y1*y1)*(y2 - y3) +                                                //Calculate the x value of the circumcenter
               (x2*x2 + y2*y2)*(y3 - y1) +
               (x3*x3 + y3*y3)*(y1 - y2)) / d;
  
  double cy = ((x1*x1 + y1*y1)*(x3 - x2) +                                                //Calculate the x value of the circumcenter
               (x2*x2 + y2*y2)*(x1 - x3) +
               (x3*x3 + y3*y3)*(x2 - x1)) / d;

  double radius = Math.sqrt((x1 - cx)*(x1 - cx) + (y1 - cy)*(y1 - cy));                   //Calculate the radius by using the distance formula
  
  return radius;                                                                          //return the radius in pixels
}
