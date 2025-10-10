import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

PolynomialSplineFunction splineX;
PolynomialSplineFunction splineY;

void setup() {
  size(600, 400);
  background(255);

  double[] x = {100, 200, 300, 200, 100, 200, 300, 200, 100, 200, 300, 200, 100};
  double[] y = {200, 100, 200, 300, 200, 100, 200, 300, 200, 100, 200, 300, 200};

  double[] s = new double[x.length];
  for (int i = 0; i < x.length; i++) {
    s[i] = i;
  }

  SplineInterpolator interpolator = new SplineInterpolator();
  splineX = interpolator.interpolate(s, x);
  splineY = interpolator.interpolate(s, y);

  for(int i = 0; i<4; i++)
  {
  drawPoints(x[i], y[i]);
  }
  
  stroke(0);
  strokeWeight(2);
  noFill();
  beginShape();
  for (double i = 4; i <= s[s.length - 5]; i += 0.05) {
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
