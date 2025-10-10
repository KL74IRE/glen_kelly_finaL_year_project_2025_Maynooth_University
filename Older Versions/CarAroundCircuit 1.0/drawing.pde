double [] [] drawTrack(double [] x, double [] y, int start, int end, int steps, int desired)
{
  double[] s = new double[x.length];
  for (int i = 0; i < x.length; i++) {
    s[i] = i;
  }

  SplineInterpolator interpolator = new SplineInterpolator();
  PolynomialSplineFunction splineX = interpolator.interpolate(s, x);
  PolynomialSplineFunction splineY = interpolator.interpolate(s, y);

  UnivariateFunction dxSpline = splineX.derivative(); 
  UnivariateFunction dySpline = splineY.derivative(); 

  for(int i = 0; i < start; i++) {
    drawPoints(x[i], y[i]);
  }
  
  double interval = (s[s.length - end] - start)/(steps - 1);
  double totalLength = 0;

  double prevX = splineX.value(start);
  double prevY = splineY.value(start);
  
  stroke(0);
  strokeWeight(2);
  noFill();
  beginShape();
  double CornerRadius [] [] = new double [steps] [2];
  int j = 0;
  
  for (double t = start; t <= s[s.length - end]; t += interval) { //t
    double tx = splineX.value(t);
    double ty = splineY.value(t);
    vertex((float)tx, (float)ty);

    double dx = dxSpline.value(t);
    double dy = dySpline.value(t);

    double h = 0.001;
    double ddx = (dxSpline.value(t + h) - dxSpline.value(t - h)) / (2 * h);
    double ddy = (dySpline.value(t + h) - dySpline.value(t - h)) / (2 * h);

    double numerator = Math.pow(dx*dx + dy*dy, 1.5);
    double denominator = Math.abs(dx*ddy - dy*ddx);
    double radius = (denominator < 1e-9) ? Double.POSITIVE_INFINITY : numerator / denominator;
    
    double segmentDx = tx - prevX;
    double segmentDy = ty - prevY;
    totalLength += Math.sqrt(segmentDx * segmentDx + segmentDy * segmentDy);
    double ratio = (totalLength / desired);
    
    CornerRadius [j] [0] = t;
    CornerRadius [j] [1] = (radius*ratio);
    j++;
 
    prevX = tx;
    prevY = ty;
    
    
    }

  endShape();
  
  println("Spline length: " + totalLength + " pixels");
  println("Desired length: " + desired + " meters");
  println("Pixel-to-meter ratio: 1 : " + (totalLength / desired));
  return(CornerRadius);

}

void drawPoints(double x, double y) {
  stroke(0);
  strokeWeight(10);
  point((float)x, (float)y);
}
