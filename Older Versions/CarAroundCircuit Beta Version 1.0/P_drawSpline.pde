import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

PolynomialSplineFunction splineX;
PolynomialSplineFunction splineY;

double[][] getSpline(double[] x, double[] y, int start, int end, int steps) {
  double[] s = new double[x.length];
  s[0] = 0;
  for (int i = 1; i < x.length; i++) {
    double dx = x[i] - x[i - 1];
    double dy = y[i] - y[i - 1];
    s[i] = s[i - 1] + Math.sqrt(dx * dx + dy * dy);
  }

  SplineInterpolator interpolator = new SplineInterpolator();
  splineX = interpolator.interpolate(s, x);
  splineY = interpolator.interpolate(s, y);

  double startDistance = s[Math.min(start, s.length - 1)];
  double endDistance = s[Math.max(0, s.length - end + 1)];
  double interval = (endDistance - startDistance) / (steps - 1);

  double[][] trackPoints = new double[steps][2];
  for (int j = 0; j < steps; j++) {
    double t = startDistance + j * interval;
    double tx = splineX.value(t);
    double ty = splineY.value(t);
    trackPoints[j][0] = tx;
    trackPoints[j][1] = ty;
  }
  trackPoints[steps - 1][0] = trackPoints[0][0];
  trackPoints[steps - 1][1] = trackPoints[0][1];

  endShape();

  return trackPoints;
}
