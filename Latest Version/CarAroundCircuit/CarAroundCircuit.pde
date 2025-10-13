import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;
PrintWriter output;

PolynomialSplineFunction splineX;
PolynomialSplineFunction splineY;

void setup() {
  size(1280, 800);
  background(255);
  int steps = 5000000;
  boolean excel = false;
  boolean showWaypoints = false;
  boolean showPoints = false;
  boolean showSpeeds = false;
  brandsHatch(steps,excel,showWaypoints,showPoints,showSpeeds);
  basicCircle(steps,excel,showWaypoints,showPoints,showSpeeds);
}
