double gRatio;

double ratio(double[] x, double[] y, int start, int end, int steps, double mTrackLength) {
  double[] s = new double[x.length];
  for (int i = 0; i < x.length; i++) {
    s[i] = i;
  }

  SplineInterpolator interpolator = new SplineInterpolator();
  PolynomialSplineFunction splineX = interpolator.interpolate(s, x);
  PolynomialSplineFunction splineY = interpolator.interpolate(s, y);

  double interval = (s[s.length - end] - start) / (steps - 1);
  double totalLength = 0;
  double prevX = splineX.value(start);
  double prevY = splineY.value(start);

  for (double t = start; t <= s[s.length - end]; t += interval) {
    double tx = splineX.value(t);
    double ty = splineY.value(t);
    double segmentDx = tx - prevX;
    double segmentDy = ty - prevY;
    totalLength += Math.sqrt(segmentDx * segmentDx + segmentDy * segmentDy);
    prevX = tx;
    prevY = ty;
  }
  double ratio = totalLength / mTrackLength;
  gRatio = ratio;
  return ratio;
}
