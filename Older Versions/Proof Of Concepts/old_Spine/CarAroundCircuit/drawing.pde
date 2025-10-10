void drawTrack(double [] x, double [] y, int start, int end, int steps)
{
  double[] s = new double[x.length];
  for (int i = 0; i < x.length; i++) {
    s[i] = i;
  }

  SplineInterpolator interpolator = new SplineInterpolator();
  splineX = interpolator.interpolate(s, x);
  splineY = interpolator.interpolate(s, y);

  for(int i = 0; i<start; i++)
  {
  drawPoints(x[i], y[i]);
  }
  
  double interval = (s[s.length - end] - start)/(steps-1);
  
  stroke(0);
  strokeWeight(2);
  noFill();
  beginShape();
  for (double i = start; i <= s[s.length - end]; i += interval) {
    double xi = splineX.value(i);
    double yi = splineY.value(i);
    strokeWeight(2);
    vertex((float)xi, (float)yi);
  }
  endShape();
}



void drawPoints(double x, double y) {
  stroke(0);
  strokeWeight(10);
  point((float)x, (float)y);
}
