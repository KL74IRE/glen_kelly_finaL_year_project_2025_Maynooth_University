double [] [] drawTrack(double [] x, double [] y, int start, int end, int steps)
{
  double[] s = new double[x.length];
  for (int i = 0; i < x.length; i++) {
    s[i] = i;
  }
  SplineInterpolator interpolator = new SplineInterpolator();
  PolynomialSplineFunction splineX = interpolator.interpolate(s, x);
  PolynomialSplineFunction splineY = interpolator.interpolate(s, y);
  
  double interval = (s[s.length - end] - start)/(steps - 1);
 
  stroke(0);
  strokeWeight(2);
  noFill();
  beginShape();
  double  [] [] trackPoints = new double [steps] [2];
  int j = 0;
  
  for (double t = start; t <= s[s.length - end]; t += interval) { //t
    double tx = splineX.value(t);
    double ty = splineY.value(t);
    vertex((float)tx, (float)ty);
    drawPoints(tx,ty, #0000FF, 10);
    trackPoints [j] [0] = tx;
    trackPoints [j] [1] = ty;
    j++;
    }

  endShape();

  return(trackPoints);
}

void drawPoints(double x, double y, color c, double weight) {
  stroke(c);
  strokeWeight((float)weight);
  point((float)x, (float)y);
  stroke(0);
  strokeWeight(2);
}

void visualisation(double [] x, double [] y, double [][] speeds, int steps, boolean waypoints, boolean points, boolean speed)
{
  if(waypoints)
  {
    for(int i = 0; i < x.length; i++)
    {
      drawPoints(x[i],y[i], #9D00FF, 25);
    }
  }
  
  if(points)
  {
    for(int i = 0; i < steps; i++)
    {
      fill(0);
      text(i, (float)speeds [i][0], (float) speeds [i][1]+ 10);
      drawPoints(speeds [i][0] , speeds [i][1], #FF0000, 5);
    }
  }
}
