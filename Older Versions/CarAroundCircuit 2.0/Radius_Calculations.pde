double [] [] radius(double [] [] points, int steps, double ratio)
{
  double radius [] [] = new double [steps] [3];
   
    //print(ratio);
    radius [0] [0] = (points [0] [0] / ratio);
    radius [0] [1] = (points [0] [1] / ratio);
    radius [0] [2] = getRadius(points [steps-2][0],  points [steps-2][1],
                               points [0]      [0],  points [0]      [1],
                               points [1]      [0],  points [1]      [1]);
    radius [0] [2] = (radius [0] [2] /ratio);
                               
    radius [steps-2] [0] = points [0] [0];
    radius [steps-2] [1] = points [0] [1];
    radius [steps-2] [2] = getRadius(points [steps-2][0],  points [steps-2][1],
                                     points [steps-1][0],  points [steps-1][1],
                                     points [1]      [0],  points [1]      [1]);
    radius [steps-2] [2] = (radius [steps-2] [2] /ratio);
   
  for(int i = 1; i < (steps -2) ; i++)
  {
    //print("Point: " + i + ", ");
    radius [i] [0] = points [i] [0];  //x
    radius [i] [1] = points [i] [1];  //y
    radius [i] [2] = getRadius(points [i-1][0],  points [i-1][1],
                               points [i]  [0],  points [i]  [1],
                               points [i+1][0],  points [i+1][1]);
    radius [i] [2] = (radius [i] [2] /ratio);
    
    //println("x: " + radius [i] [0] + ", y: " + radius [i] [1] + ", radius: " +radius [i] [2]);
  }
  
  for(int i =0; i<steps-1; i++)
  {
  //println("x: " + radius [i] [0] + ", y: " + radius [i] [1] + ", radius: " +radius [i] [2]);
  }
  
  return radius; //returned in meters
 }

double getRadius(double x1, double y1, double x2, double y2, double x3, double y3)
{
  double d = 2 * (x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2));
  
  double cx = ((x1*x1 + y1*y1)*(y2 - y3) +
               (x2*x2 + y2*y2)*(y3 - y1) +
               (x3*x3 + y3*y3)*(y1 - y2)) / d;
  
  double cy = ((x1*x1 + y1*y1)*(x3 - x2) +
               (x2*x2 + y2*y2)*(x1 - x3) +
               (x3*x3 + y3*y3)*(x2 - x1)) / d;

  double radius = Math.sqrt((x1 - cx)*(x1 - cx) + (y1 - cy)*(y1 - cy));
  
  //println("x1: " + nf((float)x1,3,3) + ", y1: " + nf((float)y1,3,3) + ", x2: " + nf((float)x2,3,3) + ", y2: " + nf((float)y2,3,3) + ", x3: " + nf((float)x3,3,3) + ", y3: " + nf((float)y3,3,3) + ", radius: " +radius);
  
  return radius; //radius gotten in pixels
}
